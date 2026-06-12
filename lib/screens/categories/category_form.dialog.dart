import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/data/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFormDialog extends StatefulWidget {
  final dynamic category;
  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late int _selectedIcon;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name ?? '');
    _budgetController = TextEditingController(text: category?.budget?.toString() ?? '');
    _selectedIcon = category?.icon.codePoint ?? Icons.category.codePoint;
    _selectedColor = category?.color.value ?? Colors.blue.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return AlertDialog(
      title: Text(widget.category == null ? 'New category' : 'Edit category'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _budgetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Budget')),
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
            cubit.upsertCategory(
              id: widget.category?.id,
              name: _nameController.text,
              iconCodePoint: _selectedIcon,
              colorValue: _selectedColor,
              budget: double.tryParse(_budgetController.text) ?? 0,
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
