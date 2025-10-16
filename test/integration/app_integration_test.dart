import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/main.dart';
import 'package:epsi_sorcier_qcm/ui/screens/home_screen.dart';
import 'package:epsi_sorcier_qcm/ui/screens/quiz_screen.dart';
import 'package:epsi_sorcier_qcm/ui/screens/result_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('QCM App Integration Tests', () {
    testWidgets('complete user flow simulation', (WidgetTester tester) async {
      // Setup mock quiz data
      const mockQuizJson = '''
      {
        "title": "Quel sorcier de l'EPSI es-tu ?",
        "archtypes": ["Cryptomancien", "Architectomage", "Datalchimiste", "Technomancien"],
        "questions": [
          {
            "id": 1,
            "text": "Un serveur tombe en panne lors d'une démo importante. Quelle est ta première réaction ?",
            "options": [
              {
                "id": "A",
                "text": "Je cherche immédiatement la faille de sécurité ou le bug caché.",
                "scores": {"Cryptomancien": 3, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 1}
              },
              {
                "id": "B",
                "text": "J'analyse l'architecture pour identifier le point de défaillance.",
                "scores": {"Cryptomancien": 1, "Architectomage": 3, "Datalchimiste": 1, "Technomancien": 1}
              }
            ]
          },
          {
            "id": 2,
            "text": "Quel est ton environnement de travail idéal ?",
            "options": [
              {
                "id": "A",
                "text": "Un bunker sécurisé avec des écrans multiples et du café.",
                "scores": {"Cryptomancien": 3, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 1}
              },
              {
                "id": "B",
                "text": "Un bureau spacieux avec des whiteboards et des post-its partout.",
                "scores": {"Cryptomancien": 1, "Architectomage": 3, "Datalchimiste": 1, "Technomancien": 1}
              }
            ]
          }
        ]
      }
      ''';

      // Mock the asset bundle
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString' && 
              methodCall.arguments == 'assets/quiz.json') {
            return mockQuizJson;
          }
          return null;
        },
      );

      // Simulate starting the app
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // ÉTAPE 1: Vérifier l'écran d'accueil
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Le Choix du Sorcier Tech'), findsOneWidget);
      expect(find.text('Commencer le test'), findsOneWidget);

      // ÉTAPE 2: Naviguer vers le quiz
      await tester.tap(find.text('Commencer le test'));
      await tester.pumpAndSettle();

      // Vérifier qu'on est sur l'écran de quiz
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Question 1 / 2'), findsOneWidget);

      // ÉTAPE 3: Répondre à la première question
      expect(find.text('Un serveur tombe en panne lors d\'une démo importante. Quelle est ta première réaction ?'), findsOneWidget);
      
      // Choisir la première option (favorise Cryptomancien)
      await tester.tap(find.text('Je cherche immédiatement la faille de sécurité ou le bug caché.'));
      await tester.pumpAndSettle();

      // ÉTAPE 4: Vérifier la deuxième question
      expect(find.text('Question 2 / 2'), findsOneWidget);
      expect(find.text('Quel est ton environnement de travail idéal ?'), findsOneWidget);

      // Choisir la première option à nouveau (encore plus de points pour Cryptomancien)
      await tester.tap(find.text('Un bunker sécurisé avec des écrans multiples et du café.'));
      await tester.pumpAndSettle();

      // ÉTAPE 5: Vérifier l'écran de résultat
      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('Résultat'), findsOneWidget);
      
      // Le résultat devrait contenir l'un des archétypes
      final resultFound = find.textContaining('sorcière dominante').evaluate().isNotEmpty;
      expect(resultFound, isTrue);
    });

    testWidgets('navigation between screens works correctly', (WidgetTester tester) async {
      // Mock minimal quiz data
      const mockQuizJson = TestConstants.mockQuizJson;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString' && 
              methodCall.arguments == 'assets/quiz.json') {
            return mockQuizJson;
          }
          return null;
        },
      );

      // Start the app
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Test navigation to result screen
      expect(find.byType(HomeScreen), findsOneWidget);
      
      await tester.tap(find.text('Voir dernier résultat'));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
    });

    testWidgets('quiz loading and error states work', (WidgetTester tester) async {
      // Test error state
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            throw PlatformException(
              code: 'ASSET_NOT_FOUND',
              message: 'Asset not found',
            );
          }
          return null;
        },
      );

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Commencer le test'));
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.text('Erreur chargement quiz'), findsOneWidget);
    });

    testWidgets('app flows with different quiz configurations', (WidgetTester tester) async {
      // Test with single question quiz
      const singleQuestionQuiz = '''
      {
        "title": "Quiz Simple",
        "archtypes": ["Type1", "Type2"],
        "questions": [
          {
            "id": 1,
            "text": "Seule question ?",
            "options": [
              {
                "id": "A",
                "text": "Option unique",
                "scores": {"Type1": 5, "Type2": 1}
              }
            ]
          }
        ]
      }
      ''';

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            return singleQuestionQuiz;
          }
          return null;
        },
      );

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Start quiz
      await tester.tap(find.text('Commencer le test'));
      await tester.pumpAndSettle();

      // Should show single question
      expect(find.text('Question 1 / 1'), findsOneWidget);
      expect(find.text('Seule question ?'), findsOneWidget);

      // Answer and complete
      await tester.tap(find.text('Option unique'));
      await tester.pumpAndSettle();

      // Should go directly to results
      expect(find.byType(ResultScreen), findsOneWidget);
    });

    testWidgets('theme and styling consistency across screens', (WidgetTester tester) async {
      const mockQuizJson = TestConstants.mockQuizJson;

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            return mockQuizJson;
          }
          return null;
        },
      );

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Check home screen styling
      final homeScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(homeScaffold.backgroundColor, equals(const Color(0xFF002d64)));

      // Navigate to quiz and check styling
      await tester.tap(find.text('Commencer le test'));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Card), findsOneWidget); // Question card

      // Check that buttons are properly styled
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    });

    tearDown(() {
      // Clean up mock method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), null);
    });
  });
}