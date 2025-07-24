import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/presentation/view/goal_form.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_event.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GoalCard extends StatelessWidget {
  final GoalEntity goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final percentage = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
    final remaining = goal.targetAmount - goal.savedAmount;
    final deadline = DateFormat('MMM dd, yyyy').format(goal.deadline);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFFFF0ED),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              color: Colors.green,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Text(
              'Rs. ${goal.savedAmount.toStringAsFixed(2)} / ${goal.targetAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Remaining: Rs. ${remaining.toStringAsFixed(2)} | Deadline: $deadline',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _showContributionDialog(context, goal),
              icon: const Icon(Icons.savings_outlined),
              label: const Text("Contribute"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(
                  fontFamily: "Jaro",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {
                    final bloc = context.read<GoalViewModel>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: bloc,
                              child: GoalForm(initialGoal: goal),
                            ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Delete Goal'),
                            content: const Text(
                              'Are you sure you want to delete this goal?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      // ignore: use_build_context_synchronously
                      context.read<GoalViewModel>().add(
                        DeleteGoalEvent(goal.id),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Goal deleted'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showContributionDialog(BuildContext context, GoalEntity goal) {
  final amountController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: Text(
            'Contribute to "${goal.title}"',
            style: const TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: const TextStyle(color: Colors.black),
              floatingLabelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final input = amountController.text.trim();
                final amount = double.tryParse(input);

                if (amount != null && amount > 0) {
                  context.read<GoalViewModel>().add(
                    ContributeToGoalEvent(id: goal.id, amount: amount),
                  );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Contribution successful!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid amount"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.savings_outlined),
              label: const Text('Contribute'),
            ),
          ],
        ),
  );
}
