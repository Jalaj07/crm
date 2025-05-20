// lib/features/resignation/presentation/widgets/resignation_details_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_development/constants/employeeresignation_constants.dart';

class ResignationDetailsSection extends StatelessWidget {
  final bool isDraft;
  final String? selectedResignationType;
  final List<String> resignationTypes;
  final ValueChanged<String?> onResignationTypeChanged;
  final FormFieldValidator<String?> validateResignationType;
  final TextEditingController reasonController;
  final FormFieldValidator<String?> validateReason;

  const ResignationDetailsSection({
    super.key,
    required this.isDraft,
    required this.selectedResignationType,
    required this.resignationTypes,
    required this.onResignationTypeChanged,
    required this.validateResignationType,
    required this.reasonController,
    required this.validateReason,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: ResignationConstants.inputDecoration(
            ResignationConstants.labelType,
            isEnabled: isDraft,
          ),
          value: selectedResignationType,
          items:
              resignationTypes.map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
          onChanged: isDraft ? onResignationTypeChanged : null,
          validator: validateResignationType,
        ),
        const SizedBox(height: ResignationConstants.formFieldSpacing),
        TextFormField(
          controller: reasonController,
          decoration: ResignationConstants.inputDecoration(
            ResignationConstants.labelReason,
            alignLabelWithHint: true,
            isEnabled: isDraft,
          ),
          maxLines: 4,
          readOnly: !isDraft,
          validator: validateReason,
        ),
      ],
    );
  }
}
