
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: context.read<AppCubit>().state.username ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;
    final cubit = context.read<AppCubit>();

    final colorChoices = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.red,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Display name',
              border: OutlineInputBorder(),
            ),
            onChanged: cubit.updateUsername,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: state.currencyCode,
            decoration: const InputDecoration(
              labelText: 'Currency code',
              border: OutlineInputBorder(),
            ),
            items: const ['BRL', 'USD', 'EUR', 'GBP', 'INR', 'JPY']
                .map((code) => DropdownMenuItem(value: code, child: Text(code)))
                .toList(),
            onChanged: (value) {
              if (value != null) cubit.updateCurrency(value);
            },
          ),
          const SizedBox(height: 16),
          Text('Theme color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colorChoices
                .map(
                  (color) => ChoiceChip(
                    label: const Text(''),
                    selected: state.themeColor == color.value,
                    avatar: CircleAvatar(backgroundColor: color),
                    onSelected: (_) => cubit.updateThemeColor(color.value),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () {
              cubit.resetDemoData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Demo data restored')),
              );
            },
            child: const Text('Restore demo data'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: cubit.resetAll,
            child: const Text('Reset all'),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This build keeps all data in memory. After closing the app, the demo data is recreated automatically.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
