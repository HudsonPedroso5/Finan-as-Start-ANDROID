import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/data/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountFormDialog extends StatefulWidget {
  final dynamic account;
  const AccountFormDialog({super.key, this.account});

  @override
  State<AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends State<AccountFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _holderController;
  late final TextEditingController _numberController;
  late int _selectedIcon;
  late int _selectedColor;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _nameController = TextEditingController(text: account?.name ?? '');
    _holderController = TextEditingController(text: account?.holderName ?? '');
    _numberController = TextEditingController(text: account?.accountNumber ?? '');
    _selectedIcon = account?.icon.codePoint ?? Icons.wallet.codePoint;
    _selectedColor = account?.color.value ?? Colors.green.value;
    _isDefault = account?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _holderController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return AlertDialog(
      title: Text(widget.account == null ? 'New account' : 'Edit account'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _holderController, decoration: const InputDecoration(labelText: 'Holder name')),
              TextField(controller: _numberController, decoration: const InputDecoration(labelText: 'Account number')),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
                title: const Text('Default account'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Color', style: Theme.of(context).textTheme.titleSmall),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Colors.primaries.take(12).map((color) {
                  return ChoiceChip(
                    label: const Text(''),
                    selected: _selectedColor == color.value,
                    avatar: CircleAvatar(backgroundColor: color),
                    onSelected: (_) => setState(() => _selectedColor = color.value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Icon', style: Theme.of(context).textTheme.titleSmall),
              ),
              SizedBox(
                height: 180,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: cubit.iconChoices.map((icon) {
                    final selected = icon.codePoint == _selectedIcon;
                    return InkWell(
                      onTap: () => setState(() => _selectedIcon = icon.codePoint),
                      child: Card(
                        color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
                        child: Icon(icon),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_nameController.text.trim().isEmpty) return;
            cubit.upsertAccount(
              id: widget.account?.id,
              name: _nameController.text,
              holderName: _holderController.text,
              accountNumber: _numberController.text,
              iconCodePoint: _selectedIcon,
              colorValue: _selectedColor,
              isDefault: _isDefault,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
