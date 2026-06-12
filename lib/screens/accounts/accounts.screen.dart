import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/screens/accounts/account_form.dialog.dart';
import 'package:fintracker/widgets/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AppCubit>().summarizedAccounts();
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AccountFormDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final account = accounts[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: account.color.withOpacity(0.15),
                child: Icon(account.icon, color: account.color),
              ),
              title: Text(account.name),
              subtitle: Text(account.holderName.isEmpty ? 'Sem titular' : account.holderName),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CurrencyText(account.balance, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(account.isDefault ? 'Default' : ''),
                ],
              ),
              onTap: () => showDialog(
                context: context,
                builder: (_) => AccountFormDialog(account: account),
              ),
              onLongPress: () async {
                final remove = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete account?'),
                    content: Text('Remove "${account.name}" and its transactions?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (remove == true && context.mounted) {
                  context.read<AppCubit>().deleteAccount(account.id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
