// lib/widgets/tourplan/tour_plan_form_sheet.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/ffm/tour_plan.dart'; // Ensure this path is correct
import '../../../constants/travelmanagement_filter_status.dart'; // Reusing FilterStatus

// Define options for dropdowns
const List<String> purposeOfVisitOptions = [
  'Client Meeting', 'Site Survey', 'Installation', 'Maintenance', 'Training', 'Conference', 'Sales Visit', 'Other'
];
const List<String> travelModeOptions = ['Car', 'Bike', 'Public Transport', 'TAF (Travel Allowance Fixed)', 'Other'];


class TourPlanFormSheet extends StatefulWidget {
  final TourPlan? initialPlan;

  const TourPlanFormSheet({this.initialPlan, super.key});

  @override
  State<TourPlanFormSheet> createState() => _TourPlanFormSheetState();
}

class _TourPlanFormSheetState extends State<TourPlanFormSheet> {
  final _formKey = GlobalKey<FormState>();

  // Plan ID will be displayed but not directly edited if auto-assigned
  String _planId = '';
  late TextEditingController _planNameController;
  late TextEditingController _locationController;
  String? _selectedPurposeOfVisit;
  late TextEditingController _descriptionController;
  String? _selectedTravelMode;
  late DateTime _selectedFromDate;
  late DateTime _selectedToDate;
  int _totalDays = 1;

  @override
  void initState() {
    super.initState();
    final plan = widget.initialPlan;

    _planId = plan?.planId ?? 'TP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'; // Example auto-ID
    _planNameController = TextEditingController(text: plan?.planName ?? '');
    _locationController = TextEditingController(text: plan?.location ?? '');
    _selectedPurposeOfVisit = plan?.purposeOfVisit ?? purposeOfVisitOptions.first;
    _descriptionController = TextEditingController(text: plan?.description ?? '');
    _selectedTravelMode = plan?.travelMode ?? travelModeOptions.first;
    _selectedFromDate = plan?.fromDate ?? DateTime.now();
    _selectedToDate = plan?.toDate ?? DateTime.now();

    _calculateTotalDays(); // Initial calculation
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _calculateTotalDays() {
    if (_selectedToDate.isBefore(_selectedFromDate)) {
      setState(() {
        _totalDays = 0; // Or handle as an error
      });
      return;
    }
    setState(() {
      _totalDays = _selectedToDate.difference(_selectedFromDate).inDays + 1;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime initial = isFromDate ? _selectedFromDate : _selectedToDate;
    final DateTime first = isFromDate ? DateTime.now().subtract(const Duration(days: 365)) : _selectedFromDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _selectedFromDate = picked;
          if (_selectedToDate.isBefore(_selectedFromDate)) {
            _selectedToDate = _selectedFromDate; // Adjust ToDate if FromDate goes past it
          }
        } else {
          _selectedToDate = picked;
        }
        _calculateTotalDays();
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      if (_totalDays <= 0 && _selectedToDate.isBefore(_selectedFromDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('To Date cannot be before From Date.'), backgroundColor: Colors.red),
          );
          return;
      }
      final resultData = {
        'planId': _planId, // This is usually server-assigned or auto-generated if new
        'planName': _planNameController.text.trim(),
        'location': _locationController.text.trim(),
        'purposeOfVisit': _selectedPurposeOfVisit,
        'description': _descriptionController.text.trim(),
        'travelMode': _selectedTravelMode,
        'fromDate': _selectedFromDate,
        'toDate': _selectedToDate,
        'totalDays': _totalDays,
        'status': widget.initialPlan?.status ?? FilterStatus.pending, // Preserve status on edit or default to pending
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
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          // border: const OutlineInputBorder(), // Theme will apply this
          isDense: true,
        ),
        keyboardType: keyboardType,
        validator: validator ?? (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

   Widget _buildDropdownFormField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?)? onChanged,
    String? Function(T?)? validator,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          // border: const OutlineInputBorder(), // Theme will apply this
          isDense: true,
        ),
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(displayText(item)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator ?? (v) {
          if (isRequired && v == null) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildDateField(
      BuildContext context, {
      required String label,
      required DateTime selectedDate,
      required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '$label *',
          // border: const OutlineInputBorder(), // Theme will provide
          isDense: true,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMMd().format(selectedDate),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.calendar_today, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.initialPlan != null;
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: bottomPadding + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Tour Plan' : 'New Tour Plan',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Tour Plan ID (non-editable, auto-assigned/fetched)
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tour Plan ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                child: Text(_planId, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 16),

              _buildTextFormField(controller: _planNameController, label: 'Plan Name'),
              _buildTextFormField(controller: _locationController, label: 'Location'),

              _buildDropdownFormField<String>(
                label: 'Purpose of Visit',
                value: _selectedPurposeOfVisit,
                items: purposeOfVisitOptions,
                displayText: (s) => s,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPurposeOfVisit = newValue;
                  });
                },
              ),

              _buildTextFormField(
                  controller: _descriptionController, label: 'Description', maxLines: 3),

              _buildDropdownFormField<String>(
                label: 'Travel Mode',
                value: _selectedTravelMode,
                items: travelModeOptions,
                displayText: (s) => s,
                onChanged: (newValue) {
                  setState(() {
                    _selectedTravelMode = newValue;
                  });
                },
              ),

              Row(
                children: [
                  Expanded(child: _buildDateField(context, label: 'From Date', selectedDate: _selectedFromDate, onTap: () => _selectDate(context, true))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDateField(context, label: 'To Date', selectedDate: _selectedToDate, onTap: () => _selectDate(context, false))),
                ],
              ),

              // Total Days (non-editable, calculated)
               Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Total Days',
                    // border: OutlineInputBorder(), // Theme will apply this
                    isDense: true,
                  ),
                  child: Text(
                    _totalDays > 0 ? '$_totalDays Day${_totalDays != 1 ? 's' : ''}' : "Invalid date range",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _totalDays <= 0 ? theme.colorScheme.error : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save_as_outlined : Icons.add_circle_outline),
                onPressed: _saveForm,
                // style: theme.elevatedButtonTheme.style, // Theme will provide
                label: Text(isEditing ? 'Update Plan' : 'Create Plan'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}