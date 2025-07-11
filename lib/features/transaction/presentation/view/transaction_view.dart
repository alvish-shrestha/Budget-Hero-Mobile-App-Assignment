import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TransactionView extends StatelessWidget {
  TransactionView({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final ValueNotifier<String> selectedType = ValueNotifier('expense');
  final ValueNotifier<String?> selectedCategory = ValueNotifier(null);
  final ValueNotifier<String?> selectedAccount = ValueNotifier(null);
  final ValueNotifier<String> selectedDate = ValueNotifier(
    DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  final List<String> incomeCategories = ['Salary', 'Gift', 'Bonus'];
  final List<String> expenseCategories = [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
  ];
  final List<String> accountOptions = ['Bank', 'Cash', 'Wallet'];

  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Add Transaction')),
      body: BlocConsumer<TransactionViewModel, TransactionState>(
        listener: (context, state) {
          if (state.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              // Navigator.pop(context);
            });
          }

          if (state.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              showMySnackbar(context: context, content: state.errorMessage!);
            });
          }
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
                                            ? Colors.blue
                                            : Color(0xFFF55345),
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

                    const SizedBox(height: 12),

                    // Date Picker
                    ValueListenableBuilder(
                      valueListenable: selectedDate,
                      builder: (context, date, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(date),
                                  firstDate: DateTime(2014),
                                  lastDate: DateTime(2031, 12, 31),
                                  helpText: 'Select Transaction Date',
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: const Color(0xFFF55345),
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xFFF55345),
                                        ),
                                        textTheme: Theme.of(
                                          context,
                                        ).textTheme.apply(
                                          fontFamily: 'Jaro', // or your font
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(
                                              0xFFF55345,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  selectedDate.value = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(picked);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),

                    _buildTextField("Amount", _amount, prefix: "Rs.  "),

                    const SizedBox(height: 12),

                    ValueListenableBuilder<String>(
                      valueListenable: selectedType,
                      builder: (context, type, _) {
                        return _buildDropdown(
                          "Category",
                          selectedType,
                          selectedCategory,
                          incomeCategories,
                          expenseCategories,
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                    _buildDropdown(
                      "Account",
                      null,
                      selectedAccount,
                      accountOptions,
                      accountOptions,
                    ),

                    const SizedBox(height: 12),
                    _buildTextField("Note", _note),
                    _buildTextField("Description", _description),
                    const SizedBox(height: 20),

                    ValueListenableBuilder<String>(
                      valueListenable: selectedType,
                      builder: (context, type, _) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final transaction = TransactionEntity(
                                id: uuid.v4(),
                                type: selectedType.value,
                                date: selectedDate.value,
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
                                type == 'income'
                                    ? Colors.blue
                                    : const Color(0xFFF55345),
                          ),
                          child:
                              state.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Color(0xFFF55345),
                                  )
                                  : const Text('Save Transaction'),
                        );
                      },
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
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          prefixText: prefix,
          prefixStyle: const TextStyle(color: Colors.black),
          errorStyle: const TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    ValueNotifier<String>? type,
    ValueNotifier<String?> selected,
    List<String> income,
    List<String> expense,
  ) {
    return ValueListenableBuilder(
      valueListenable: selected,
      builder: (context, selectedVal, _) {
        final items =
            type == null ? income : (type.value == 'income' ? income : expense);
        return DropdownButtonFormField<String>(
          value: selectedVal,
          items:
              items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
          onChanged: (val) => selected.value = val,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            errorStyle: const TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          validator:
              (value) =>
                  value == null ? 'Please select $label'.toLowerCase() : null,
        );
      },
    );
  }
}
