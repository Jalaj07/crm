// lib/widgets/myteamplan/sales_entry_form_sheet.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/sales_entry.dart'; // SalesEntry model
import 'package:uuid/uuid.dart';


class SalesEntryFormSheet extends StatefulWidget {
  final SalesEntry? initialSalesEntry;

  const SalesEntryFormSheet({this.initialSalesEntry, super.key});

  @override
  State<SalesEntryFormSheet> createState() => _SalesEntryFormSheetState();
}

class _SalesEntryFormSheetState extends State<SalesEntryFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _salesNumberController;
  late TextEditingController _customerNameController;
  late TextEditingController _customerAddressController;
  late DateTime _selectedDate;
  String? _selectedStatus;
  late TextEditingController _amountController;
  late TextEditingController _notesController;


  @override
  void initState() {
    super.initState();
    final entry = widget.initialSalesEntry;

    _salesNumberController = TextEditingController(text: entry?.salesNumber ?? 'SN-${const Uuid().v4().substring(0,6).toUpperCase()}'); // Auto-generate if new
    _customerNameController = TextEditingController(text: entry?.customerName ?? '');
    _customerAddressController = TextEditingController(text: entry?.customerAddress ?? '');
    _selectedDate = entry?.date ?? DateTime.now();
    _selectedStatus = entry?.status ?? SalesStatus.values.first;
    _amountController = TextEditingController(text: entry?.amount?.toString() ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
  }

  @override
  void dispose() {
    _salesNumberController.dispose();
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() { _selectedDate = picked; });
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final resultData = SalesEntry(
        entryId: widget.initialSalesEntry?.entryId, // Preserve ID if editing
        salesNumber: _salesNumberController.text.trim(),
        customerName: _customerNameController.text.trim(),
        customerAddress: _customerAddressController.text.trim(),
        date: _selectedDate,
        status: _selectedStatus!,
        amount: double.tryParse(_amountController.text.trim()),
        notes: _notesController.text.trim(),
      );
      Navigator.pop(context, resultData); // Pop with the SalesEntry object
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1, bool isRequired = true
  }) {
     return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label + (isRequired ? ' *' : ''), border: const OutlineInputBorder(), isDense: true),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ?? (value) {
          if(isRequired && (value == null || value.trim().isEmpty)){
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialSalesEntry != null;
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: bottomPadding + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Sales Entry' : 'Add Sales Entry',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(controller: _salesNumberController, label: 'Sales Number', isRequired: false), // Could be read-only if auto-generated
              _buildTextFormField(controller: _customerNameController, label: 'Customer Name'),
              _buildTextFormField(controller: _customerAddressController, label: 'Customer Address', maxLines: 2),

              Padding( // Date Picker
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date *', border: OutlineInputBorder(), isDense: true),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Text(DateFormat.yMMMd().format(_selectedDate)), const Icon(Icons.calendar_today_outlined)],
                    ),
                  ),
                ),
              ),

              DropdownButtonFormField<String>( // Status Dropdown
                decoration: const InputDecoration(labelText: 'Status *', border: OutlineInputBorder(), isDense: true),
                value: _selectedStatus,
                items: SalesStatus.values.map((String status) {
                  return DropdownMenuItem<String>(value: status, child: Text(status));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedStatus = newValue),
                validator: (value) => value == null ? 'Status is required' : null,
              ),
              const SizedBox(height: 12),
              _buildTextFormField(controller: _amountController, label: 'Amount (Optional)', keyboardType: TextInputType.numberWithOptions(decimal: true), isRequired: false),
              _buildTextFormField(controller: _notesController, label: 'Notes (Optional)', maxLines: 3, isRequired: false),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(isEditing ? 'Update Entry' : 'Add Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}