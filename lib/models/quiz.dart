import 'question.dart';

class Quiz {
  final String title;
  final List<String> archtypes;
  final List<Question> questions;

  Quiz({required this.title, required this.archtypes, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final q = (json['questions'] as List<dynamic>).map((e) => Question.fromJson(e)).toList();
    return Quiz(title: json['title'] as String, archtypes: List<String>.from(json['archtypes']), questions: q);
  }
}
