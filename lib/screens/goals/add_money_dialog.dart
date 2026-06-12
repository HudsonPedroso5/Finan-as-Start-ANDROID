import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/model/goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMoneyDialog extends StatefulWidget {
  final Goal goal;
  const AddMoneyDialog(this.goal, {super.key});

  @override
  State<AddMoneyDialog> createState() => _AddMoneyDialogState();
}

class _AddMoneyDialogState extends State<AddMoneyDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar valor - ${widget.goal.title}'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Valor'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            final value = double.tryParse(controller.text) ?? 0.0;
            if (value > 0) {
              context.read<AppCubit>().addMoneyToGoal(widget.goal.id, value);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
