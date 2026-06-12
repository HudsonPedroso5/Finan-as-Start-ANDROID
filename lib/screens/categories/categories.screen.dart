import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/categories/category_form.dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<AppCubit>().summarizedCategories();
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const CategoryFormDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color.withOpacity(0.15),
                child: Icon(category.icon, color: category.color),
              ),
              title: Text(category.name),
              subtitle: Text('Monthly expense: ${category.expense.toStringAsFixed(2)}'),
              onTap: () => showDialog(
                context: context,
                builder: (_) => CategoryFormDialog(category: category),
              ),
              onLongPress: () async {
                final remove = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete category?'),
                    content: Text('Remove "${category.name}" and its transactions?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (remove == true && context.mounted) {
                  context.read<AppCubit>().deleteCategory(category.id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
