// models/survey_question_model.dart

enum SurveyQuestionType {
  textInfo, // For descriptive text, not a question to answer
  textInput,
  mcq, // Multiple Choice Question (single select)
  msq, // Multiple Selection Question (multi select)
}

class SurveyOption {
  final String id;
  final String text;

  SurveyOption({required this.id, required this.text});
}

abstract class SurveyQuestion {
  final String id;
  final String questionText;
  final SurveyQuestionType type;
  final bool isMandatory;
  final int
  page; // For multi-page surveys (single question per page mode, 1-indexed)

  SurveyQuestion({
    required this.id,
    required this.questionText,
    required this.type,
    this.isMandatory = false,
    this.page = 1, // Default to page 1
  });
}

class TextInfoQuestion extends SurveyQuestion {
  TextInfoQuestion({required super.id, required super.questionText, super.page})
    : super(
        type: SurveyQuestionType.textInfo,
        isMandatory: false,
      ); // TextInfo is never mandatory
}

class TextInputQuestion extends SurveyQuestion {
  final String? hintText;

  TextInputQuestion({
    required super.id,
    required super.questionText,
    super.isMandatory,
    this.hintText,
    super.page,
  }) : super(type: SurveyQuestionType.textInput);
}

class McqQuestion extends SurveyQuestion {
  final List<SurveyOption> options;

  McqQuestion({
    required super.id,
    required super.questionText,
    required this.options,
    super.isMandatory,
    super.page,
  }) : super(type: SurveyQuestionType.mcq);
}

class MsqQuestion extends SurveyQuestion {
  final List<SurveyOption> options;

  MsqQuestion({
    required super.id,
    required super.questionText,
    required this.options,
    super.isMandatory,
    super.page,
  }) : super(type: SurveyQuestionType.msq);
}
