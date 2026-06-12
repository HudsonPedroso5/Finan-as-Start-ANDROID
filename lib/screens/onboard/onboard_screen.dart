import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<_CurrencyOption> _currencies = const [
    _CurrencyOption('BRL', 'R\$', 'Real'),
    _CurrencyOption('USD', '\$', 'US Dollar'),
    _CurrencyOption('EUR', '€', 'Euro'),
    _CurrencyOption('GBP', '£', 'Pound'),
    _CurrencyOption('INR', '₹', 'Rupee'),
    _CurrencyOption('JPY', '¥', 'Yen'),
  ];
  String? _selectedCurrency;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = context.read<AppCubit>().state.username ?? '';
    _selectedCurrency = context.read<AppCubit>().state.currencyCode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fintracker', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(
                    'Crie o perfil inicial. Os dados ficam apenas na memória desta sessão.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Seu nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Moeda', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _currencies.map((currency) {
                      final selected = currency.code == _selectedCurrency;
                      return ChoiceChip(
                        label: Text('${currency.symbol} ${currency.code}'),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCurrency = currency.code),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Sem banco de dados'),
                          SizedBox(height: 8),
                          Text('Ao fechar o app, os dados de teste são recriados automaticamente.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        if (name.isEmpty || _selectedCurrency == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Informe nome e moeda')),
                          );
                          return;
                        }
                        final cubit = context.read<AppCubit>();
                        cubit.updateUsername(name);
                        cubit.updateCurrency(_selectedCurrency!);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Entrar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencyOption {
  final String code;
  final String symbol;
  final String name;
  const _CurrencyOption(this.code, this.symbol, this.name);
}
