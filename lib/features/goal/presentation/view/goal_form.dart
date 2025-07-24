import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_event.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class GoalForm extends StatefulWidget {
  final GoalEntity? initialGoal;

  const GoalForm({super.key, this.initialGoal});

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.initialGoal != null) {
      _titleController.text = widget.initialGoal!.title;
      _targetAmountController.text = widget.initialGoal!.targetAmount
          .toStringAsFixed(2);
      _deadline = widget.initialGoal!.deadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _deadline != null) {
      final goal = GoalEntity(
        id: widget.initialGoal?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        targetAmount: double.parse(_targetAmountController.text),
        savedAmount: widget.initialGoal?.savedAmount ?? 0.0,
        deadline: _deadline!,
      );

      final bloc = context.read<GoalViewModel>();

      if (widget.initialGoal != null) {
        bloc.add(UpdateGoalEvent(goal));
      } else {
        bloc.add(AddGoalEvent(goal));
      }

      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Goal' : 'Add Goal'),
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Goal Title',
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetAmountController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an amount';
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _deadline != null
                      ? 'Deadline: ${DateFormat.yMMMEd().format(_deadline!)}'
                      : 'Select deadline',
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.black),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  isEdit ? 'Update Goal' : 'Add Goal',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
