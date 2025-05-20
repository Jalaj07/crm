// lib/features/resignation/presentation/employee_resignation_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_action_buttons_section.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_dates_section.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_details_section.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_form_section_header.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_resignation_details_section.dart';
import 'package:flutter_development/widgets/hrms/employeeresignation/employeeresignation_status_display.dart';

// Consider adding a logging package like 'package:logging' for proper logging
// import 'package:logging/logging.dart';

class EmployeeResignationPage extends StatefulWidget {
  const EmployeeResignationPage({super.key});

  @override
  State<EmployeeResignationPage> createState() =>
      _EmployeeResignationPageState();
}

class _EmployeeResignationPageState extends State<EmployeeResignationPage> {
  // final _log = Logger('EmployeeResignationPage');
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // --- State Variables ---
  String _status = ResignationConstants.statusDraft;
  bool get _isDraft => _status == ResignationConstants.statusDraft;

  // --- Controllers ---
  late final TextEditingController _departmentController;
  late final TextEditingController _contractController;
  late final TextEditingController _joinDateController;
  late final TextEditingController _lastDayController;
  late final TextEditingController _approvedLastDayController;
  late final TextEditingController _noticePeriodController;
  late final TextEditingController _reasonController;

  // --- Dropdown State ---
  String? _selectedEmployee;
  String? _selectedResignationType;

  // --- Mock Data --- (Replace with actual data fetching)
  // Keep mock data here or move to a dedicated data source/repository
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 1,
      'name': 'Anshul Sharma',
      'department': 'IT',
      'joinDate': '2022-01-15',
      'contract': 'FT-ENG-001',
    },
  ];
  final List<String> _resignationTypes = [
    'Normal Resignation',
    'Mutual Agreement',
    'Retirement',
  ];

  // --- Lifecycle Methods ---
  @override
  void initState() {
    super.initState();
    _departmentController = TextEditingController();
    _contractController = TextEditingController();
    _joinDateController = TextEditingController();
    _lastDayController = TextEditingController();
    _approvedLastDayController = TextEditingController();
    _noticePeriodController = TextEditingController();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _departmentController.dispose();
    _contractController.dispose();
    _joinDateController.dispose();
    _lastDayController.dispose();
    _approvedLastDayController.dispose();
    _noticePeriodController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  // --- Core Logic Methods (Keep in State) ---

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      // _log.warning('Failed to parse date: $dateString', e);
      return null;
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    // Check if the form is in draft state before showing the date picker
    if (!_isDraft) return;

    DateTime initialDate = DateTime.now();
    final currentDate = _parseDate(controller.text);
    if (currentDate != null) {
      initialDate = currentDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final String formattedDate = _dateFormat.format(picked);
      if (controller.text != formattedDate) {
        setState(() {
          controller.text = formattedDate;
          _formKey.currentState?.validate(); // Re-validate after date change
        });
      }
    }
  }

  void _onEmployeeSelected(String? employeeName) {
    // Check if the form is in draft state
    if (!_isDraft) return;

    setState(() {
      _selectedEmployee = employeeName;
      if (employeeName == null) {
        _departmentController.clear();
        _joinDateController.clear();
        _contractController.clear();
      } else {
        final employeeData = _employees.firstWhere(
          (emp) => emp['name'] == employeeName,
          orElse: () => {'department': '', 'joinDate': '', 'contract': ''},
        );
        _departmentController.text = employeeData['department'] ?? '';
        _joinDateController.text = employeeData['joinDate'] ?? '';
        _contractController.text = employeeData['contract'] ?? '';
      }
      _lastDayController.clear();
      _approvedLastDayController.clear();
      _formKey.currentState?.validate(); // Re-validate
    });
  }

  void _onResignationTypeChanged(String? newValue) {
    // Check if the form is in draft state
    if (!_isDraft) return;

    setState(() {
      _selectedResignationType = newValue;
      _formKey.currentState?.validate(); // Re-validate
    });
  }

  // ignore: unused_element
  void _clearForm() {
    _formKey.currentState?.reset();
    _departmentController.clear();
    _contractController.clear();
    _joinDateController.clear();
    _lastDayController.clear();
    _approvedLastDayController.clear();
    _noticePeriodController.clear();
    _reasonController.clear();
    setState(() {
      _selectedEmployee = null;
      _selectedResignationType = null;
      // Reset status if needed
      // _status = ResignationConstants.statusDraft;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // _log.info('Form is valid...');
      // --- Implement actual submission logic ---

      setState(() {
        _status = ResignationConstants.statusConfirmed;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ResignationConstants.snackBarSuccess)),
        );
      }
    } else {
      // _log.warning('Form validation failed.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(ResignationConstants.snackBarError),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _cancelForm() {
    // Implement cancel logic - maybe clear form or just navigate back
    // _clearForm(); // Optional
    Navigator.maybePop(context); // Default: Try to pop the route
  }

  // --- Validation Methods (Keep in State as they depend on controllers/state) ---

  String? _validateRequired(String? value, String message) {
    if (_isDraft && (value == null || value.isEmpty)) {
      return message;
    }
    return null;
  }

  String? _validateDropdown(String? value, String message) {
    if (_isDraft && value == null) {
      return message;
    }
    return null;
  }

  String? _validateEmployee(String? value) =>
      _validateDropdown(value, ResignationConstants.validationSelectEmployee);
  String? _validateContract(String? value) =>
      _validateRequired(value, ResignationConstants.validationEnterContract);
  String? _validateJoinDate(String? value) =>
      _validateRequired(value, ResignationConstants.validationSelectJoinDate);

  String? _validateLastDay(String? value) {
    if (!_isDraft) return null;
    final requiredError = _validateRequired(
      value,
      ResignationConstants.validationSelectLastDay,
    );
    if (requiredError != null) return requiredError;
    final lastDay = _parseDate(value);
    final joinDate = _parseDate(_joinDateController.text);
    if (joinDate != null && lastDay != null && lastDay.isBefore(joinDate)) {
      return ResignationConstants.validationLastDayBeforeJoin;
    }
    return null;
  }

  String? _validateApprovedLastDay(String? value) {
    if (!_isDraft) return null;
    final requiredError = _validateRequired(
      value,
      ResignationConstants.validationSelectApprovedLastDay,
    );
    if (requiredError != null) return requiredError;
    final approvedDay = _parseDate(value);
    final joinDate = _parseDate(_joinDateController.text);
    if (joinDate != null &&
        approvedDay != null &&
        approvedDay.isBefore(joinDate)) {
      return ResignationConstants.validationApprovedLastDayBeforeJoin;
    }
    return null;
  }

  String? _validateNoticePeriod(String? value) {
    if (!_isDraft) return null;
    final requiredError = _validateRequired(
      value,
      ResignationConstants.validationEnterNoticePeriod,
    );
    if (requiredError != null) return requiredError;
    final number = int.tryParse(value!);
    if (number == null || number <= 0) {
      return ResignationConstants.validationValidNumber;
    }
    return null;
  }

  String? _validateResignationType(String? value) =>
      _validateDropdown(value, ResignationConstants.validationSelectType);
  String? _validateReason(String? value) =>
      _validateRequired(value, ResignationConstants.validationEnterReason);

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    // Return ONLY the body content, without a Scaffold assumed
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Use the new widgets, passing state and callbacks
            StatusDisplay(status: _status),
            const SizedBox(height: ResignationConstants.formFieldSpacing),

            const FormSectionHeader(
              title: ResignationConstants.titleEmployeeDetails,
            ),
            EmployeeDetailsSection(
              isDraft: _isDraft,
              selectedEmployee: _selectedEmployee,
              employees: _employees,
              onEmployeeSelected: _onEmployeeSelected,
              validateEmployee: _validateEmployee,
              departmentController: _departmentController,
              contractController: _contractController,
              validateContract: _validateContract,
            ),
            const SizedBox(height: ResignationConstants.sectionSpacing),

            const FormSectionHeader(title: ResignationConstants.titleDates),
            DatesSection(
              isDraft: _isDraft,
              joinDateController: _joinDateController,
              validateJoinDate: _validateJoinDate,
              lastDayController: _lastDayController,
              validateLastDay: _validateLastDay,
              approvedLastDayController: _approvedLastDayController,
              validateApprovedLastDay: _validateApprovedLastDay,
              noticePeriodController: _noticePeriodController,
              validateNoticePeriod: _validateNoticePeriod,
              onSelectDate: _selectDate, // Pass the method reference
            ),
            const SizedBox(height: ResignationConstants.sectionSpacing),

            const FormSectionHeader(
              title: ResignationConstants.titleResignationDetails,
            ),
            ResignationDetailsSection(
              isDraft: _isDraft,
              selectedResignationType: _selectedResignationType,
              resignationTypes: _resignationTypes,
              onResignationTypeChanged:
                  _onResignationTypeChanged, // Use the new handler
              validateResignationType: _validateResignationType,
              reasonController: _reasonController,
              validateReason: _validateReason,
            ),
            const SizedBox(height: ResignationConstants.sectionSpacing),

            ActionButtonsSection(
              isDraft: _isDraft,
              onCancel: _cancelForm, // Use the cancel handler
              onSubmit: _submitForm,
            ),
            const SizedBox(height: ResignationConstants.formFieldSpacing),
          ],
        ),
      ),
    );
  }
}
