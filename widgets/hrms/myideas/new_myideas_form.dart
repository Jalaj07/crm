import 'package:flutter/material.dart';
import 'package:flutter_development/constants/myideas_constants.dart';
import 'package:flutter_development/models/hrms/myideas.dart';

class NewIdeaForm extends StatefulWidget {
  final Function(Idea) onSubmit;
  const NewIdeaForm({super.key, required this.onSubmit});

  @override
  State<NewIdeaForm> createState() => _NewIdeaFormState();
}

class _NewIdeaFormState extends State<NewIdeaForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = AppConstants.ideaCategories[0]; // Default category

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newIdea = Idea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        createdAt: DateTime.now(),
        status: AppConstants.statusPending,
      );
      widget.onSubmit(newIdea);

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = AppConstants.ideaCategories[0];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.itemSpacing),
            _buildTextFormField(
              context: context,
              label: 'Title',
              hintText: 'Give your idea a catchy title',
              controller: _titleController,
              maxLines: 1,
              validator:
                  (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Please enter a title'
                          : null,
            ),
            const SizedBox(height: AppConstants.sectionSpacing),
            _buildDropdownField(
              context: context,
              label: 'Category',
              value: _selectedCategory,
              items: AppConstants.ideaCategories,
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
              validator:
                  (value) => value == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: AppConstants.sectionSpacing),
            _buildTextFormField(
              context: context,
              label: 'Description',
              hintText: 'Describe your idea in detail...',
              controller: _descriptionController,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.largeSectionSpacing),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('SUBMIT IDEA'),
            ),
            const SizedBox(height: AppConstants.screenPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFieldWrapper({
    required BuildContext context,
    required String label,
    required Widget field,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.itemSpacing),
        field,
      ],
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required String label,
    required String hintText,
    required TextEditingController controller,
    required int maxLines,
    required String? Function(String?) validator,
  }) {
    return _buildFormFieldWrapper(
      context: context,
      label: label,
      field: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return _buildFormFieldWrapper(
      context: context,
      label: label,
      field: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        elevation: 4,
        style: textTheme.bodyLarge?.copyWith(color: Colors.grey[800]),
        decoration: const InputDecoration(),
        onChanged: onChanged,
        items:
            items.map<DropdownMenuItem<String>>((String itemValue) {
              return DropdownMenuItem<String>(
                value: itemValue,
                child: Text(itemValue),
              );
            }).toList(),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
