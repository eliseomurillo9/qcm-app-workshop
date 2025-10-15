class AnswerOption {
  final String id;
  final String text;
  final Map<String, int> scores;

  AnswerOption({required this.id, required this.text, required this.scores});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'] as String,
      text: json['text'] as String,
      scores: Map<String, int>.from(json['scores'] ?? {}),
    );
  }
}
