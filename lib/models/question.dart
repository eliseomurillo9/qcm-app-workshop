import 'option.dart';

class Question {
  final int id;
  final String text;
  final List<AnswerOption> options;

  Question({required this.id, required this.text, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    final opts = (json['options'] as List<dynamic>).map((o) => AnswerOption.fromJson(o)).toList();
    return Question(id: json['id'] as int, text: json['text'] as String, options: opts);
  }
}
