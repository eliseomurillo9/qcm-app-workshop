import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../services/local_quiz_service.dart';

final localQuizServiceProvider = Provider((ref) => LocalQuizService());

final quizFutureProvider = FutureProvider<Quiz>((ref) async {
  final service = ref.read(localQuizServiceProvider);
  return service.loadQuizFromAsset();
});

final answersProvider = StateNotifierProvider<AnswersNotifier, Map<int, String>>((ref) => AnswersNotifier());

class AnswersNotifier extends StateNotifier<Map<int, String>> {
  AnswersNotifier(): super({});

  void setAnswer(int questionId, String optionId) {
    state = {...state, questionId: optionId};
  }

  void clear() => state = {};
}
