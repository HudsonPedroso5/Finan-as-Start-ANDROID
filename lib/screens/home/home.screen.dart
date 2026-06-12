import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:fintracker/screens/payment_form.screen.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 0),
    );
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2019),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _range,
    );
    if (picked != null) {
      setState(() => _range = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AppCubit>();
    final payments = cubit.paymentViews(range: _range);
    final income = payments.where((p) => p.payment.type == PaymentType.credit).fold<double>(0, (sum, item) => sum + item.payment.amount);
    final expense = payments.where((p) => p.payment.type == PaymentType.debit).fold<double>(0, (sum, item) => sum + item.payment.amount);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PaymentFormScreen(type: PaymentType.debit),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Payment'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olá, ${cubit.state.username ?? 'usuário'}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Visão geral do mês', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: cubit.summarizedAccounts().length,
                itemBuilder: (context, index) {
                  final account = cubit.summarizedAccounts()[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [account.color.withOpacity(0.75), account.color],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CurrencyText(account.balance, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text('Balance', style: TextStyle(color: Colors.white70)),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(account.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  Text(account.holderName, style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                            Icon(account.icon, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('Payments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pickRange,
                    icon: const Icon(Icons.date_range),
                    label: Text('${DateFormat('dd MMM').format(_range!.start)} - ${DateFormat('dd MMM').format(_range!.end)}'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Income',
                      value: income,
                      color: ThemeColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Expense',
                      value: expense,
                      color: ThemeColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎯 Metas Ativas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Builder(builder: (context) {
                        final goals = cubit.state.goals;
                        if (goals.isEmpty) return const Text('Nenhuma meta ativa');
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: goals.length,
                          itemBuilder: (_, index) {
                            final goal = goals[index];
                            return ListTile(
                              leading: const Icon(Icons.flag),
                              title: Text(goal.title),
                              subtitle: Text('${(goal.progress * 100).toStringAsFixed(0)}%'),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
          if (payments.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Nenhuma transação no período'),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final itemIndex = index ~/ 2;
                  if (index.isOdd) {
                    return const Divider(height: 1);
                  }
                  final item = payments[itemIndex];
                  final sign = item.payment.type == PaymentType.credit ? 1 : -1;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item.category.color.withOpacity(0.15),
                      child: Icon(item.category.icon, color: item.category.color),
                    ),
                    title: Text(item.payment.title.isEmpty ? item.category.name : item.payment.title),
                    subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(item.payment.datetime)),
                    trailing: CurrencyText(
                      sign * item.payment.amount,
                      style: TextStyle(
                        color: sign > 0 ? ThemeColors.success : ThemeColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentFormScreen(
                            type: item.payment.type,
                            payment: item.payment,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: payments.isEmpty ? 0 : payments.length * 2 - 1,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final MaterialColor color;
  const _MetricCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            CurrencyText(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
