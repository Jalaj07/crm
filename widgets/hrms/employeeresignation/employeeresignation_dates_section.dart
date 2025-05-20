// lib/features/resignation/presentation/widgets/dates_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';

// Define a typedef for the date selection callback
typedef DateSelectionCallback =
    Future<void> Function(
      BuildContext context,
      TextEditingController controller,
    );

class DatesSection extends StatelessWidget {
  final bool isDraft;
  final TextEditingController joinDateController;
  final FormFieldValidator<String?> validateJoinDate;
  final TextEditingController lastDayController;
  final FormFieldValidator<String?> validateLastDay;
  final TextEditingController approvedLastDayController;
  final FormFieldValidator<String?> validateApprovedLastDay;
  final TextEditingController noticePeriodController;
  final FormFieldValidator<String?> validateNoticePeriod;
  final DateSelectionCallback onSelectDate; // Pass the function

  const DatesSection({
    super.key,
    required this.isDraft,
    required this.joinDateController,
    required this.validateJoinDate,
    required this.lastDayController,
    required this.validateLastDay,
    required this.approvedLastDayController,
    required this.validateApprovedLastDay,
    required this.noticePeriodController,
    required this.validateNoticePeriod,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          // Join Date
          controller: joinDateController..text = '2022-01-15',
          decoration: ResignationConstants.inputDecoration(
            ResignationConstants.labelJoinDate,
            isEnabled: false, // Always disabled appearance
          ),
          readOnly: true,
          validator: validateJoinDate,
        ),
        const SizedBox(height: ResignationConstants.formFieldSpacing),
        TextFormField(
          // Notice Period (tentative)
          controller: noticePeriodController,
          decoration: ResignationConstants.inputDecoration(
            ResignationConstants.labelNoticePeriod,
            hintText: 'Tentative',
            isEnabled: isDraft,
          ),
          keyboardType: TextInputType.number,
          readOnly: !isDraft,
          validator: validateNoticePeriod,
        ),
        const SizedBox(height: ResignationConstants.formFieldSpacing),
        TextFormField(
          // Last Day (employee fills)
          controller: lastDayController,
          decoration: ResignationConstants.inputDecoration(
            'Resigning Date',
            suffixIcon: Icons.calendar_today,
            isEnabled: isDraft,
          ),
          readOnly: true, // Use onTap for interaction
          onTap:
              isDraft ? () => onSelectDate(context, lastDayController) : null,
          validator: validateLastDay,
        ),
      ],
    );
  }
}
