import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/features/goal/presentation/view/goal_form.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_event.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_state.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:budgethero/features/goal/presentation/view/goal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GoalViewModel>()..add(LoadGoalsEvent()),
      child: BlocBuilder<GoalViewModel, GoalState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: const Text(
                'Goals 🎯',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            backgroundColor: const Color(0xFFFFF5F3),
            body: _buildBody(context, state),
            floatingActionButton: FloatingActionButton(
              heroTag: "goal-fab",
              onPressed: () {
                final bloc = context.read<GoalViewModel>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: bloc,
                          child: const GoalForm(),
                        ),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, GoalState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    if (state.goals.isEmpty) {
      return const Center(
        child: Text("No goals found.", style: TextStyle(color: Colors.black)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.goals.length,
      itemBuilder: (context, index) {
        final goal = state.goals[index];
        return GoalCard(goal: goal);
      },
    );
  }
}
