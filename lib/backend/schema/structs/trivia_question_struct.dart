// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TriviaQuestionStruct extends BaseStruct {
  TriviaQuestionStruct({
    String? question,
    List<String>? answers,
    int? correctIndex,
    String? theme,
  })  : _question = question,
        _answers = answers,
        _correctIndex = correctIndex,
        _theme = theme;

  // "question" field.
  String? _question;
  String get question => _question ?? '';
  set question(String? val) => _question = val;

  bool hasQuestion() => _question != null;

  // "answers" field.
  List<String>? _answers;
  List<String> get answers => _answers ?? const [];
  set answers(List<String>? val) => _answers = val;

  void updateAnswers(Function(List<String>) updateFn) {
    updateFn(_answers ??= []);
  }

  bool hasAnswers() => _answers != null;

  // "correctIndex" field.
  int? _correctIndex;
  int get correctIndex => _correctIndex ?? 0;
  set correctIndex(int? val) => _correctIndex = val;

  void incrementCorrectIndex(int amount) =>
      correctIndex = correctIndex + amount;

  bool hasCorrectIndex() => _correctIndex != null;

  // "theme" field.
  String? _theme;
  String get theme => _theme ?? '';
  set theme(String? val) => _theme = val;

  bool hasTheme() => _theme != null;

  static TriviaQuestionStruct fromMap(Map<String, dynamic> data) =>
      TriviaQuestionStruct(
        question: data['question'] as String?,
        answers: getDataList(data['answers']),
        correctIndex: castToType<int>(data['correctIndex']),
        theme: data['theme'] as String?,
      );

  static TriviaQuestionStruct? maybeFromMap(dynamic data) => data is Map
      ? TriviaQuestionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'question': _question,
        'answers': _answers,
        'correctIndex': _correctIndex,
        'theme': _theme,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'question': serializeParam(
          _question,
          ParamType.String,
        ),
        'answers': serializeParam(
          _answers,
          ParamType.String,
          isList: true,
        ),
        'correctIndex': serializeParam(
          _correctIndex,
          ParamType.int,
        ),
        'theme': serializeParam(
          _theme,
          ParamType.String,
        ),
      }.withoutNulls;

  static TriviaQuestionStruct fromSerializableMap(Map<String, dynamic> data) =>
      TriviaQuestionStruct(
        question: deserializeParam(
          data['question'],
          ParamType.String,
          false,
        ),
        answers: deserializeParam<String>(
          data['answers'],
          ParamType.String,
          true,
        ),
        correctIndex: deserializeParam(
          data['correctIndex'],
          ParamType.int,
          false,
        ),
        theme: deserializeParam(
          data['theme'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TriviaQuestionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TriviaQuestionStruct &&
        question == other.question &&
        listEquality.equals(answers, other.answers) &&
        correctIndex == other.correctIndex &&
        theme == other.theme;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([question, answers, correctIndex, theme]);
}

TriviaQuestionStruct createTriviaQuestionStruct({
  String? question,
  int? correctIndex,
  String? theme,
}) =>
    TriviaQuestionStruct(
      question: question,
      correctIndex: correctIndex,
      theme: theme,
    );
