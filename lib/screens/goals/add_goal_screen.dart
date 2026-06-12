import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/model/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final targetController = TextEditingController();
  final currentController = TextEditingController();

  String? selectedCategory;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    targetController.dispose();
    currentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AppCubit>();
    final categories = cubit.state.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Meta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Nome da Meta')),
              const SizedBox(height: 8),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Descrição')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCategory ?? (categories.isNotEmpty ? categories.first.name : null),
                items: categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 8),
              TextField(controller: targetController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor Alvo')),
              const SizedBox(height: 8),
              TextField(controller: currentController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor Atual')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('Prazo: ${selectedDate.toLocal().toIso8601String().split('T').first}')),
                  TextButton(onPressed: _pickDate, child: const Text('Escolher')),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();
                  final category = selectedCategory ?? (categories.isNotEmpty ? categories.first.name : 'Other');
                  final target = double.tryParse(targetController.text) ?? 0.0;
                  final current = double.tryParse(currentController.text) ?? 0.0;

                  final goal = Goal(
                    id: id,
                    title: title,
                    description: description,
                    targetAmount: target,
                    currentAmount: current,
                    deadline: selectedDate,
                    category: category,
                  );

                  context.read<AppCubit>().addGoal(goal);
                  Navigator.of(context).pop();
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
