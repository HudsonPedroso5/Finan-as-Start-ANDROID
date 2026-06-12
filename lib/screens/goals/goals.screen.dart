import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/widgets/goal_card.dart';
import 'package:fintracker/screens/goals/add_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final goals = state.goals;

        return Scaffold(
          appBar: AppBar(title: const Text('Metas')),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddGoalScreen()));
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: goals.isEmpty
                ? const Center(child: Text('Nenhuma meta criada'))
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (_, index) {
                      final goal = goals[index];
                      return GoalCard(goal);
                    },
                  ),
          ),
        );
      },
    );
  }
}
