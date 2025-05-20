// screen/hrms/survey_form_modal.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // For share button - CORRECTED IMPORT ALREADY
import '../../models/hrms/survey_model.dart';
import '../../models/hrms/survey_question_model.dart';

class SurveyFormModal extends StatefulWidget {
  final Survey survey;

  const SurveyFormModal({super.key, required this.survey});

  @override
  State<SurveyFormModal> createState() => _SurveyFormModalState();
}

class _SurveyFormModalState extends State<SurveyFormModal> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _answers = {};
  int _currentPage = 1;
  bool _isLoading = false;
  bool _attemptedSubmit = false;

  List<int> _sortedUniquePageNumbers = [];

  @override
  void initState() {
    super.initState();
    for (var question in widget.survey.questions) {
      if (question.type == SurveyQuestionType.msq) {
        _answers[question.id] = <String>{};
      }
    }
    if (widget.survey.displayMode == SurveyDisplayMode.singleQuestionPerPage &&
        widget.survey.questions.isNotEmpty) {
      _sortedUniquePageNumbers =
          widget.survey.questions.map((q) => q.page).toSet().toList()..sort();
      if (_sortedUniquePageNumbers.isNotEmpty) {
        _currentPage = _sortedUniquePageNumbers.first;
      }
    } else {
      _currentPage = 1; // For scrollable mode, or if no pages, default to 1
    }
  }

  bool _areAllMandatoryQuestionsAnswered({bool checkAllPages = true}) {
    if (widget.survey.questions.isEmpty) return true;

    Iterable<SurveyQuestion> questionsToCheck = widget.survey.questions;
    if (!checkAllPages &&
        widget.survey.displayMode == SurveyDisplayMode.singleQuestionPerPage) {
      questionsToCheck = widget.survey.questions.where(
        (q) => q.page == _currentPage,
      );
    }

    for (final question in questionsToCheck) {
      if (question.type == SurveyQuestionType.textInfo) {
        continue; // TextInfo questions don't have answers
      }
      if (question.isMandatory) {
        final answer = _answers[question.id];
        if (answer == null) return false;
        if (answer is String && answer.trim().isEmpty) return false;
        if (answer is Set && answer.isEmpty) return false;
      }
    }
    return true;
  }

  List<SurveyQuestion> get _questionsForCurrentPage {
    if (widget.survey.displayMode == SurveyDisplayMode.singleQuestionPerPage) {
      return widget.survey.questions
          .where((q) => q.page == _currentPage)
          .toList();
    }
    return widget.survey.questions;
  }

  int get _totalPages {
    if (widget.survey.displayMode == SurveyDisplayMode.singleQuestionPerPage &&
        _sortedUniquePageNumbers.isNotEmpty) {
      return _sortedUniquePageNumbers.length;
    }
    return 1;
  }

  Widget _buildQuestion(SurveyQuestion question) {
    Widget titleWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        if (question.isMandatory &&
            question.type != SurveyQuestionType.textInfo)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );

    bool showError =
        _attemptedSubmit &&
        question.isMandatory &&
        question.type != SurveyQuestionType.textInfo &&
        (_answers[question.id] == null ||
            (_answers[question.id] is String &&
                (_answers[question.id] as String).trim().isEmpty) ||
            (_answers[question.id] is Set &&
                (_answers[question.id] as Set).isEmpty));

    switch (question.type) {
      case SurveyQuestionType.textInfo:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            question.questionText,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
        );
      case SurveyQuestionType.textInput:
        final tiq = question as TextInputQuestion;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _answers[question.id] as String?,
                decoration: InputDecoration(
                  hintText: tiq.hintText ?? 'Your answer',
                  border: const OutlineInputBorder(),
                  errorText: showError ? 'This field is required.' : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _answers[question.id] = value;
                    if (_attemptedSubmit && question.isMandatory) {
                      _formKey.currentState?.validate();
                    }
                  });
                },
                validator: (value) {
                  if (question.isMandatory &&
                      (value == null || value.trim().isEmpty)) {
                    return 'This field is required.';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      case SurveyQuestionType.mcq:
        final mcq = question as McqQuestion;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              ...mcq.options.map(
                (option) => RadioListTile<String>(
                  title: Text(option.text),
                  value: option.id,
                  groupValue: _answers[question.id] as String?,
                  onChanged: (String? value) {
                    setState(() {
                      _answers[question.id] = value;
                      if (_attemptedSubmit && question.isMandatory) {
                        _formKey.currentState
                            ?.validate(); // No direct validate, rely on overall
                      }
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    left: 12.0,
                  ), // Adjusted for radio typical alignment
                  child: Text(
                    'Please select an option.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      case SurveyQuestionType.msq:
        final msq = question as MsqQuestion;
        _answers[question.id] ??= <String>{};

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              ...msq.options.map((option) {
                return CheckboxListTile(
                  title: Text(option.text),
                  value: (_answers[question.id] as Set<String>).contains(
                    option.id,
                  ),
                  onChanged: (bool? selected) {
                    setState(() {
                      final selectedOptions =
                          _answers[question.id] as Set<String>;
                      if (selected == true) {
                        selectedOptions.add(option.id);
                      } else {
                        selectedOptions.remove(option.id);
                      }
                      if (_attemptedSubmit && question.isMandatory) {
                        _formKey.currentState?.validate(); // No direct validate
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    left: 12.0,
                  ), // Adjusted for checkbox typical alignment
                  child: Text(
                    'Please select at least one option.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
    }
  }

  void _submitSurvey() async {
    setState(() {
      _attemptedSubmit = true;
    });

    bool formFieldsValid =
        _formKey.currentState?.validate() ??
        true; // default true if no form fields
    bool customValidationPassed = _areAllMandatoryQuestionsAnswered(
      checkAllPages: true,
    );

    if (!formFieldsValid || !customValidationPassed) {
      // Check if we need to navigate to an unanswered page
      if (widget.survey.displayMode ==
          SurveyDisplayMode.singleQuestionPerPage) {
        for (final question in widget.survey.questions) {
          if (question.type == SurveyQuestionType.textInfo) continue;
          if (question.isMandatory) {
            final answer = _answers[question.id];
            final bool isUnanswered =
                answer == null ||
                (answer is String && answer.trim().isEmpty) ||
                (answer is Set && answer.isEmpty);
            if (isUnanswered && _currentPage != question.page) {
              setState(() {
                _currentPage = question.page;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please answer all mandatory (*) questions. Navigating to the first unanswered page.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please answer all mandatory (*) questions before submitting.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {}); // Re-render to show errors on current page if any
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.survey.title} submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _nextPage() {
    setState(() {
      _attemptedSubmit = true;
    });

    bool currentPageMandatoryAnswered = _areAllMandatoryQuestionsAnswered(
      checkAllPages: false,
    );
    bool formFieldsValidOnCurrentPage = true;

    // Trigger validation for FormFields on current page only by checking their controllers/values directly.
    _formKey.currentState
        ?.save(); // Ensures onChanged values are captured if using onSaved. For onChanged, they're already in _answers.
    for (var question in _questionsForCurrentPage) {
      if (question.type == SurveyQuestionType.textInput &&
          question.isMandatory) {
        if ((_answers[question.id] as String?)?.trim().isEmpty ?? true) {
          formFieldsValidOnCurrentPage = false;
          break;
        }
      }
    }

    if (!currentPageMandatoryAnswered || !formFieldsValidOnCurrentPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer mandatory question(s) on this page.'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {}); // Re-render to show error messages
      return;
    }

    if (_sortedUniquePageNumbers.isNotEmpty &&
        _currentPage != _sortedUniquePageNumbers.last) {
      final currentIndex = _sortedUniquePageNumbers.indexOf(_currentPage);
      if (currentIndex < _sortedUniquePageNumbers.length - 1) {
        setState(() {
          _currentPage = _sortedUniquePageNumbers[currentIndex + 1];
          _attemptedSubmit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestions = _questionsForCurrentPage;
    bool isLastPage = false;
    if (widget.survey.displayMode == SurveyDisplayMode.singleQuestionPerPage) {
      isLastPage =
          _sortedUniquePageNumbers.isEmpty ||
          _currentPage == _sortedUniquePageNumbers.last;
    } else {
      isLastPage =
          true; // For scrollable page, it's always the "last" page conceptually for buttons
    }

    final bool canSubmitGlobally = _areAllMandatoryQuestionsAnswered(
      checkAllPages: true,
    );

    return AlertDialog(
      title: Text(
        widget.survey.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 24.0,
      ),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95, // Use MediaQuery
        // height: MediaQuery.of(context).size.height * 0.7, // Consider maxHeight if needed
        child: Form(
          key: _formKey,
          autovalidateMode:
              _attemptedSubmit
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_totalPages > 1 &&
                  widget.survey.displayMode ==
                      SurveyDisplayMode.singleQuestionPerPage)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Page ${_sortedUniquePageNumbers.indexOf(_currentPage) + 1} of $_totalPages",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        currentQuestions.isEmpty
                            ? [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text("No questions for this page."),
                                ),
                              ),
                            ]
                            : currentQuestions.map(_buildQuestion).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(Icons.share_outlined, size: 20),
          label: const Text('Share'),
          onPressed: () {
            // CORRECTED: SharePlus.share
            SharePlus.instance.share(
              ShareParams(
                text:
                    'Check out this survey: ${widget.survey.title}, Description: ${widget.survey.description}',
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            if (widget.survey.displayMode ==
                    SurveyDisplayMode.singleQuestionPerPage &&
                !isLastPage)
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Next'),
              ),
            if (isLastPage)
              ElevatedButton(
                // Enable submit if isLoading is false AND (attemptedSubmit is true OR all mandatory are answered)
                // More precisely, only show enabled if _areAllMandatoryQuestionsAnswered(checkAllPages:true) is true.
                // The _attemptedSubmit handles visual cues for individual fields,
                // but the button itself should depend on the overall mandatory question status.
                onPressed:
                    _isLoading || !canSubmitGlobally ? null : _submitSurvey,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (_isLoading || !canSubmitGlobally)
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('Submit'),
              ),
          ],
        ),
      ],
    );
  }
}
