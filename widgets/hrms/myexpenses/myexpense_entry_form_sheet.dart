// lib/widgets/expenses/expense_entry_form_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_development/models/hrms/myexpenses/myexpenses.dart';
import 'package:intl/intl.dart';

const double kDefaultPadding = 16.0; // Placeholder if not imported

const List<String> _expenseTypes = [
  'Transport',
  'Meal',
  'Office Supplies',
  'Domestic',
  'International',
  'Other',
];

class ExpenseEntryFormSheet extends StatefulWidget {
  final Expense? initialExpense;
  const ExpenseEntryFormSheet({super.key, this.initialExpense});
  @override
  State<ExpenseEntryFormSheet> createState() => _ExpenseEntryFormSheetState();
}

class _ExpenseEntryFormSheetState extends State<ExpenseEntryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _visitController;
  late TextEditingController _visitScheduleController;
  late TextEditingController _distanceController;
  String? _selectedExpenseType;
  late DateTime _selectedDate;
  final DateFormat _dateFormatter = DateFormat(
    'dd MMM, yyyy',
  ); // For displaying date

  bool get _isEditing => widget.initialExpense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;
    _descriptionController = TextEditingController(
      text: expense?.description ?? '',
    );
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(2) : '',
    );
    _visitController = TextEditingController(
      text:
          (expense?.visit != 'N/A' && expense?.visit.isNotEmpty == true)
              ? expense!.visit
              : '',
    );
    _visitScheduleController = TextEditingController(
      text:
          (expense?.visitSchedule != 'N/A' &&
                  expense?.visitSchedule.isNotEmpty == true)
              ? expense!.visitSchedule
              : '',
    );
    _distanceController = TextEditingController(
      text:
          expense?.distanceCovered != 0 && expense?.distanceCovered != null
              ? expense!.distanceCovered.toString()
              : '',
    );
    _selectedExpenseType =
        expense?.expenseType ??
        _expenseTypes.first; // Ensure _expenseTypes is not empty
    _selectedDate = expense?.expenseDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _visitController.dispose();
    _visitScheduleController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // Not strictly needed if using controllers' text
      final data = {
        'description': _descriptionController.text.trim(),
        'expenseDate': _selectedDate,
        'amount': double.parse(_amountController.text.trim()),
        'expenseType': _selectedExpenseType!,
        'visit': _visitController.text.trim(),
        'visitSchedule': _visitScheduleController.text.trim(),
        'distanceCovered':
            double.tryParse(_distanceController.text.trim()) ?? 0.0,
      };
      Navigator.pop(context, data);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    // MODIFIED: Extracted to a method
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 5), // Example range
      lastDate: DateTime(DateTime.now().year + 5), // Example range
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Use the 'picked' variable here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        top: 20,
        bottom: bottomPadding + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit Expense' : 'New Expense',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (_isEditing && widget.initialExpense != null)
                Text(
                  'ID: ${widget.initialExpense!.id}',
                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) =>
                        (v == null || v.isEmpty)
                            ? 'Description is required'
                            : null,
              ),
              const SizedBox(height: 16), // Increased spacing
              // MODIFIED: Date Picker field
              InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Expense Date *',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ), // Adjust padding
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_dateFormatter.format(_selectedDate)),
                      const Icon(Icons.calendar_today_outlined, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Expense Type *',
                  border: OutlineInputBorder(),
                ),
                value: _selectedExpenseType,
                items:
                    _expenseTypes
                        .map(
                          (et) => DropdownMenuItem(value: et, child: Text(et)),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _selectedExpenseType = val),
                validator:
                    (v) => (v == null) ? 'Expense type is required' : null,
              ),
              const SizedBox(height: 16),

              // MODIFIED: Validator for Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹) *',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ], // Allow up to 2 decimal places
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  final val = double.tryParse(v);
                  if (val == null) return 'Please enter a valid number';
                  if (val <= 0) return 'Amount must be greater than zero';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _visitController,
                decoration: const InputDecoration(
                  labelText: 'Visit Location (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _visitScheduleController,
                decoration: const InputDecoration(
                  labelText: 'Visit Schedule (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance (km) (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ], // Allow one decimal for distance
              ),

              const SizedBox(height: 24), // Increased spacing
              ElevatedButton.icon(
                icon: Icon(
                  _isEditing
                      ? Icons.save_alt_outlined
                      : Icons.add_circle_outline,
                ),
                onPressed: _saveForm,
                label: Text(_isEditing ? 'Update Expense' : 'Submit Expense'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
