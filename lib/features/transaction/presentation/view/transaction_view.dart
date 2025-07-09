import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final ValueNotifier<String> selectedType = ValueNotifier('expense');
  final ValueNotifier<String?> selectedCategory = ValueNotifier(null);
  final ValueNotifier<String?> selectedAccount = ValueNotifier(null);

  final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final List<String> incomeCategories = ['Salary', 'Gift', 'Bonus'];
  final List<String> expenseCategories = [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
  ];

  final List<String> accountOptions = ['Bank', 'Cash', 'Wallet'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: BlocConsumer<TransactionViewModel, TransactionState>(
        listener: (context, state) {
          (context, state) {
            if (state.isSuccess) {
              Future.delayed(Duration(milliseconds: 100), () {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction added!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              });
            }

            if (state.errorMessage != null) {
              Future.delayed(Duration(milliseconds: 100), () {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }
          };
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state.isLoading,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedType,
                      builder: (context, value, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              ['income', 'expense'].map((type) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(type.toUpperCase()),
                                    selected: value == type,
                                    selectedColor:
                                        type == 'income'
                                            ? Colors.green
                                            : Colors.redAccent,
                                    onSelected: (_) {
                                      selectedType.value = type;
                                      selectedCategory.value = null;
                                    },
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField("Amount", _amount, prefix: "Rs"),

                    // 🔽 Category Dropdown
                    ValueListenableBuilder(
                      valueListenable: selectedType,
                      builder: (context, type, _) {
                        final categories =
                            type == 'income'
                                ? incomeCategories
                                : expenseCategories;
                        return ValueListenableBuilder(
                          valueListenable: selectedCategory,
                          builder: (context, selected, _) {
                            return DropdownButtonFormField<String>(
                              value: selected,
                              items:
                                  categories
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) => selectedCategory.value = val,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Please select category'
                                          : null,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // 🔽 Account Dropdown
                    ValueListenableBuilder(
                      valueListenable: selectedAccount,
                      builder: (context, selected, _) {
                        return DropdownButtonFormField<String>(
                          value: selected,
                          items:
                              accountOptions
                                  .map(
                                    (acc) => DropdownMenuItem(
                                      value: acc,
                                      child: Text(acc),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) => selectedAccount.value = val,
                          decoration: const InputDecoration(
                            labelText: 'Account',
                          ),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select account'
                                      : null,
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                    _buildTextField("Note", _note),
                    _buildTextField("Description", _description),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final transaction = TransactionEntity(
                            type: selectedType.value,
                            date: formattedDate,
                            amount: double.parse(_amount.text),
                            category: selectedCategory.value!,
                            account: selectedAccount.value!,
                            note: _note.text,
                            description: _description.text,
                          );

                          context.read<TransactionViewModel>().add(
                            AddTransactionEvent(
                              context: context,
                              transaction: transaction,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedType.value == 'income'
                                ? Colors.green
                                : Colors.redAccent,
                      ),
                      child:
                          state.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Save Transaction'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? prefix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType:
            label == "Amount" ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix,
          border: const OutlineInputBorder(),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}
