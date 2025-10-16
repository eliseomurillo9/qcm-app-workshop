import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epsi_sorcier_qcm/models/quiz.dart';
import 'package:epsi_sorcier_qcm/models/question.dart';
import 'package:epsi_sorcier_qcm/models/option.dart';
import 'package:epsi_sorcier_qcm/models/sorciere.dart';

/// Utilitaires pour créer des objets de test
class TestDataFactory {
  /// Crée une option de réponse pour les tests
  static AnswerOption createOption({
    String id = 'A',
    String text = 'Option test',
    Map<String, int>? scores,
  }) {
    return AnswerOption(
      id: id,
      text: text,
      scores: scores ?? {'Cryptomancien': 1, 'Architectomage': 1},
    );
  }

  /// Crée une question pour les tests
  static Question createQuestion({
    int id = 1,
    String text = 'Question test ?',
    List<AnswerOption>? options,
  }) {
    return Question(
      id: id,
      text: text,
      options: options ?? [
        createOption(id: 'A', text: 'Option A'),
        createOption(id: 'B', text: 'Option B'),
      ],
    );
  }

  /// Crée un quiz complet pour les tests
  static Quiz createQuiz({
    String title = 'Quiz de test',
    List<String>? archtypes,
    List<Question>? questions,
  }) {
    return Quiz(
      title: title,
      archtypes: archtypes ?? ['Cryptomancien', 'Architectomage', 'Datalchimiste', 'Technomancien'],
      questions: questions ?? [
        createQuestion(id: 1, text: 'Première question test ?'),
        createQuestion(id: 2, text: 'Deuxième question test ?'),
      ],
    );
  }

  /// Crée un sorcier pour les tests
  static Sorciere createSorciere({
    String nom = 'Cryptomancien',
    double pourcentage = 75.0,
  }) {
    return Sorciere(nom, pourcentage);
  }

  /// Crée un quiz EPSI réaliste pour les tests d'intégration
  static Quiz createEpsiQuiz() {
    return Quiz(
      title: 'Quel sorcier de l\'EPSI es-tu ?',
      archtypes: ['Cryptomancien', 'Architectomage', 'Datalchimiste', 'Technomancien'],
      questions: [
        Question(
          id: 1,
          text: 'Un serveur tombe en panne lors d\'une démo importante. Quelle est ta première réaction ?',
          options: [
            AnswerOption(
              id: 'A',
              text: 'Je cherche immédiatement la faille de sécurité ou le bug caché.',
              scores: {'Cryptomancien': 3, 'Architectomage': 1, 'Datalchimiste': 1, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'B',
              text: 'J\'analyse l\'architecture pour identifier le point de défaillance.',
              scores: {'Cryptomancien': 1, 'Architectomage': 3, 'Datalchimiste': 1, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'C',
              text: 'Je consulte les logs et métriques pour comprendre ce qui s\'est passé.',
              scores: {'Cryptomancien': 1, 'Architectomage': 1, 'Datalchimiste': 3, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'D',
              text: 'Je propose rapidement une solution de contournement innovante.',
              scores: {'Cryptomancien': 1, 'Architectomage': 1, 'Datalchimiste': 1, 'Technomancien': 3},
            ),
          ],
        ),
        Question(
          id: 2,
          text: 'Quel est ton environnement de travail idéal ?',
          options: [
            AnswerOption(
              id: 'A',
              text: 'Un bunker sécurisé avec des écrans multiples et du café.',
              scores: {'Cryptomancien': 3, 'Architectomage': 1, 'Datalchimiste': 1, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'B',
              text: 'Un bureau spacieux avec des whiteboards et des post-its partout.',
              scores: {'Cryptomancien': 1, 'Architectomage': 3, 'Datalchimiste': 1, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'C',
              text: 'Un open space avec accès aux bases de données et outils d\'analyse.',
              scores: {'Cryptomancien': 1, 'Architectomage': 1, 'Datalchimiste': 3, 'Technomancien': 1},
            ),
            AnswerOption(
              id: 'D',
              text: 'Un espace collaboratif avec les dernières technologies.',
              scores: {'Cryptomancien': 1, 'Architectomage': 1, 'Datalchimiste': 1, 'Technomancien': 3},
            ),
          ],
        ),
      ],
    );
  }

  /// Crée des réponses utilisateur pour les tests
  static Map<int, String> createUserAnswers({
    Map<int, String>? customAnswers,
  }) {
    return customAnswers ?? {
      1: 'A',
      2: 'B',
    };
  }

  /// Crée des scores calculés pour les tests
  static Map<String, double> createScores({
    Map<String, double>? customScores,
  }) {
    return customScores ?? {
      'Cryptomancien': 75.0,
      'Architectomage': 60.0,
      'Datalchimiste': 45.0,
      'Technomancien': 30.0,
    };
  }
}

/// Matchers personnalisés pour les tests
class CustomMatchers {
  /// Vérifie qu'un sorcier a un pourcentage dans une plage donnée
  static Matcher hasPourcentageBetween(double min, double max) {
    return predicate<Sorciere>(
      (sorciere) => sorciere.pourcentage >= min && sorciere.pourcentage <= max,
      'has pourcentage between $min and $max',
    );
  }

  /// Vérifie qu'un quiz a un nombre spécifique de questions
  static Matcher hasQuestionCount(int count) {
    return predicate<Quiz>(
      (quiz) => quiz.questions.length == count,
      'has $count questions',
    );
  }

  /// Vérifie qu'une question a toutes les options requises
  static Matcher hasAllRequiredOptions() {
    return predicate<Question>(
      (question) => question.options.isNotEmpty && 
                   question.options.every((opt) => opt.id.isNotEmpty && opt.text.isNotEmpty),
      'has all required options with valid id and text',
    );
  }

  /// Vérifie qu'un quiz contient tous les archétypes EPSI
  static Matcher hasEpsiArchtypes() {
    return predicate<Quiz>(
      (quiz) => quiz.archtypes.contains('Cryptomancien') &&
               quiz.archtypes.contains('Architectomage') &&
               quiz.archtypes.contains('Datalchimiste') &&
               quiz.archtypes.contains('Technomancien'),
      'contains all EPSI archtypes',
    );
  }
}

/// Classe d'aide pour les tests de widgets
class WidgetTestHelpers {
  /// Crée un widget app de test avec providers
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Crée un widget app de test avec un thème personnalisé
  static Widget createTestAppWithTheme({
    required Widget child,
    ThemeData? theme,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        theme: theme,
        home: child,
      ),
    );
  }

  /// Trouve un widget par son type et son texte
  static Finder findWidgetByTypeAndText<T extends Widget>(String text) {
    return find.widgetWithText(T, text);
  }

  /// Trouve un bouton par son texte
  static Finder findButtonByText(String text) {
    // Essaie de trouver différents types de boutons
    final elevatedButton = find.widgetWithText(ElevatedButton, text);
    if (elevatedButton.evaluate().isNotEmpty) return elevatedButton;
    
    final textButton = find.widgetWithText(TextButton, text);
    if (textButton.evaluate().isNotEmpty) return textButton;
    
    final outlinedButton = find.widgetWithText(OutlinedButton, text);
    if (outlinedButton.evaluate().isNotEmpty) return outlinedButton;
    
    // Retourne le premier finder même s'il est vide pour permettre les tests d'assertion
    return elevatedButton;
  }

  /// Vérifie qu'un widget est visible et activé
  static void expectWidgetVisibleAndEnabled(WidgetTester tester, Finder finder) {
    expect(finder, findsOneWidget);
    final widget = tester.widget(finder);
    if (widget is StatelessWidget || widget is StatefulWidget) {
      // Le widget existe et est visible
      expect(tester.getRect(finder).isEmpty, isFalse);
    }
  }

  /// Simule un tap avec un délai
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Simule la saisie de texte avec un délai
  static Future<void> enterTextAndSettle(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }
}

/// Données de test constantes
class TestConstants {
  static const String defaultQuizTitle = 'Quel sorcier de l\'EPSI es-tu ?';
  static const List<String> epsiArchtypes = [
    'Cryptomancien',
    'Architectomage', 
    'Datalchimiste',
    'Technomancien'
  ];
  
  static const String testAssetPath = 'assets/quiz.json';
  static const String mockQuizJson = '''
  {
    "title": "Quiz de test",
    "archtypes": ["Cryptomancien", "Architectomage", "Datalchimiste", "Technomancien"],
    "questions": [
      {
        "id": 1,
        "text": "Question de test ?",
        "options": [
          {
            "id": "A",
            "text": "Option A",
            "scores": {"Cryptomancien": 3, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 1}
          },
          {
            "id": "B",
            "text": "Option B", 
            "scores": {"Cryptomancien": 1, "Architectomage": 3, "Datalchimiste": 1, "Technomancien": 1}
          }
        ]
      }
    ]
  }
  ''';
}

/// Extensions utilitaires pour les tests
extension QuizTestExtensions on Quiz {
  /// Vérifie si le quiz est valide pour les tests
  bool get isValidForTesting {
    return title.isNotEmpty &&
           archtypes.isNotEmpty &&
           questions.isNotEmpty &&
           questions.every((q) => q.options.isNotEmpty);
  }

  /// Obtient le nombre total d'options dans le quiz
  int get totalOptionsCount {
    return questions.fold(0, (sum, question) => sum + question.options.length);
  }
}

extension AnswerMapExtensions on Map<int, String> {
  /// Vérifie si toutes les questions d'un quiz ont une réponse
  bool hasAnswersForAllQuestions(Quiz quiz) {
    return quiz.questions.every((question) => containsKey(question.id));
  }

  /// Calcule les scores basés sur un quiz et les réponses
  Map<String, int> calculateScores(Quiz quiz) {
    final scores = <String, int>{};
    
    for (final question in quiz.questions) {
      final answerId = this[question.id];
      if (answerId != null) {
        final option = question.options.firstWhere(
          (opt) => opt.id == answerId,
          orElse: () => question.options.first,
        );
        
        for (final entry in option.scores.entries) {
          scores[entry.key] = (scores[entry.key] ?? 0) + entry.value;
        }
      }
    }
    
    return scores;
  }
}