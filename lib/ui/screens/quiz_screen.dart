import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/quiz_provider.dart';
import '../../services/storage_service.dart';
import 'result_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int currentIdx = 0;
  Map<String, int> totals = {};

  void initializeTotals(List<String> archtypes) {
    totals = {for (var a in archtypes) a: 0};
  }

  void applyAnswer(Map<String, int> scores) {
    scores.forEach((k, v) {
      totals[k] = (totals[k] ?? 0) + v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizFutureProvider);
    return quizAsync.when(
      data: (quiz) {
        if (totals.isEmpty) initializeTotals(quiz.archtypes);
        final question = quiz.questions[currentIdx];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF002d64),
            title:
                Text('Question ${currentIdx + 1} / ${quiz.questions.length}'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(question.text, style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 20),
                ...question.options.map((opt) {
                  final selected =
                      ref.watch(answersProvider)[question.id] == opt.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(answersProvider.notifier)
                            .setAnswer(question.id, opt.id);
                        applyAnswer(Map<String, int>.from(opt.scores));
                        StorageService.saveProgress({
                          'currentQuestionId': question.id,
                          'answers': ref.read(answersProvider),
                        });
                        if (currentIdx < quiz.questions.length - 1) {
                          setState(() => currentIdx++);
                        } else {
                          final maxEntry = totals.entries
                              .reduce((a, b) => a.value >= b.value ? a : b);
                          final result = {
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'scores': totals,
                            'dominant': maxEntry.key
                          };
                          StorageService.saveResult(result);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ResultScreen(sorcieres: [maxEntry.key]),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selected ? Color(0xFF00a4e4) : Colors.white,
                        foregroundColor:
                            selected ? Color(0xFF002d64) : Color(0xFF002d64),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size(double.infinity, 56),
                      ),
                      child: Text(opt.text, textAlign: TextAlign.left),
                    ),
                  );
                }).toList(),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              StorageService.saveProgress({
                                'currentQuestionId': question.id,
                                'answers': ref.read(answersProvider),
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Sauvegarder & Quitter'))),
                  ],
                )
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('Erreur chargement quiz'))),
    );
  }
}
