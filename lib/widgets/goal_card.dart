import 'package:fintracker/model/goal.dart';
import 'package:fintracker/screens/goals/add_money_dialog.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard(this.goal, {super.key});

  @override
  Widget build(BuildContext context) {
    final progress = goal.progress.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.08))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(goal.description),
          const SizedBox(height: 20),
          Text('R\$ ${goal.currentAmount.toStringAsFixed(2)} / R\$ ${goal.targetAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 14)),
          const SizedBox(height: 10),
          Text('${(progress * 100).toStringAsFixed(0)}%'),
          const SizedBox(height: 10),
          Text('Faltam R\$ ${goal.remaining.toStringAsFixed(2)}'),
          Text('⏳ ${goal.daysLeft} dias'),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(context: context, builder: (_) => AddMoneyDialog(goal));
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
