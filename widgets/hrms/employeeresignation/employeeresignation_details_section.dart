// lib/features/resignation/presentation/widgets/employee_details_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';

class EmployeeDetailsSection extends StatelessWidget {
  final bool isDraft;
  final String? selectedEmployee;
  final List<Map<String, dynamic>> employees;
  final ValueChanged<String?> onEmployeeSelected;
  final FormFieldValidator<String?> validateEmployee;
  final TextEditingController departmentController;
  final TextEditingController contractController;
  final FormFieldValidator<String?> validateContract;

  const EmployeeDetailsSection({
    super.key,
    required this.isDraft,
    required this.selectedEmployee,
    required this.employees,
    required this.onEmployeeSelected,
    required this.validateEmployee,
    required this.departmentController,
    required this.contractController,
    required this.validateContract,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: 'Anshul Sharma',
          decoration: ResignationConstants.inputDecoration(
            'Employee Name',
            isEnabled: false,
          ),
          readOnly: true,
        ),
        const SizedBox(height: ResignationConstants.formFieldSpacing),
        TextFormField(
          initialValue: 'IT',
          decoration: ResignationConstants.inputDecoration(
            ResignationConstants.labelDepartment,
            isEnabled: false,
          ),
          readOnly: true,
        ),
        const SizedBox(height: ResignationConstants.formFieldSpacing),
        TextFormField(
          initialValue: 'FT-ENG-001',
          decoration: ResignationConstants.inputDecoration(
            'Employee ID',
            isEnabled: false,
          ),
          readOnly: true,
        ),
      ],
    );
  }
}
