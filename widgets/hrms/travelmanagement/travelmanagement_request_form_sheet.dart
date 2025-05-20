import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Adjust import paths based on your project structure
import '../../../constants/travelmanagement_filter_status.dart';
import '../../../models/hrms/travelmanagement_travel_request.dart';

final String employeeDeptName =
    'Your Dept Name'; // Replace with actual value from backend

class TravelRequestFormSheet extends StatefulWidget {
  final TravelRequest? initialRequest;

  const TravelRequestFormSheet({this.initialRequest, super.key}); // Added key

  @override
  State<TravelRequestFormSheet> createState() => _TravelRequestFormSheetState();
}

class _TravelRequestFormSheetState extends State<TravelRequestFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _travelTypeController;
  late TextEditingController _travellerTypeController;
  late TextEditingController _totalDaysController;
  late TextEditingController _purposeController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final request = widget.initialRequest;
    _nameController = TextEditingController(text: request?.name ?? '');
    _travelTypeController = TextEditingController(
      text: request?.travelType ?? 'Domestic',
    );
    _travellerTypeController = TextEditingController(
      text: request?.travellerType ?? 'Employee',
    );
    _totalDaysController = TextEditingController(
      text: request?.totalDays.toString() ?? '1',
    );
    _purposeController = TextEditingController(text: request?.purpose ?? '');
    _selectedDate = request?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _travelTypeController.dispose();
    _travellerTypeController.dispose();
    _totalDaysController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (!mounted) return;
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final resultData = {
        'name': employeeDeptName,
        'travelType': _travelTypeController.text.trim(),
        'travellerType': _travellerTypeController.text.trim(),
        'totalDays': int.tryParse(_totalDaysController.text.trim()) ?? 1,
        'purpose': _purposeController.text.trim(),
        'status': FilterStatus.pending,
        'date': _selectedDate,
      };
      Navigator.pop(context, resultData);
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        keyboardType: keyboardType,
        validator:
            validator ??
            (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) {
                return 'Please enter $label';
              }
              return null;
            },
        maxLines: maxLines,
        textCapitalization:
            (keyboardType == TextInputType.text ||
                    keyboardType == TextInputType.multiline)
                ? TextCapitalization.sentences
                : TextCapitalization.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialRequest != null;
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
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
                isEditing ? 'Edit Travel Request' : 'New Travel Request',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'ID: ${widget.initialRequest!.requestId}',
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextFormField(
                  controller: TextEditingController(text: employeeDeptName),
                  decoration: const InputDecoration(
                    labelText: 'Dept Name *',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  readOnly: true,
                  enabled: false,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextFormField(
                      controller: _travelTypeController,
                      label: 'Travel Type',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextFormField(
                      controller: _travellerTypeController,
                      label: 'Traveller Type',
                    ),
                  ),
                ],
              ),
              _buildTextFormField(
                controller: _purposeController,
                label: 'Purpose of Travel',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextFormField(
                      controller: _totalDaysController,
                      label: 'Total Days',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final int? days = int.tryParse(v.trim());
                        if (days == null || days <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Request Date',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(_selectedDate),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.edit_calendar_outlined,
                          size: 20,
                        ),
                        label: const Text('Change'),
                        onPressed: () => _selectDate(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(
                  isEditing ? Icons.save_as_outlined : Icons.add_circle_outline,
                ),
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(isEditing ? 'Update Request' : 'Create Request'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
