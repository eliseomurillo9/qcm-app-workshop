import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:epsi_sorcier_qcm/providers/quiz_provider.dart';
import 'package:epsi_sorcier_qcm/models/quiz.dart';
import 'package:epsi_sorcier_qcm/services/local_quiz_service.dart';

void main() {
  group('QuizProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('localQuizServiceProvider should provide LocalQuizService instance', () {
      // Act
      final service = container.read(localQuizServiceProvider);

      // Assert
      expect(service, isA<LocalQuizService>());
    });

    testWidgets('quizFutureProvider should load quiz successfully', (WidgetTester tester) async {
      // Arrange
      const mockQuizJson = '''
      {
        "title": "Test Quiz Provider",
        "archtypes": ["Cryptomancien", "Architectomage"],
        "questions": [
          {
            "id": 1,
            "text": "Question de test?",
            "options": [
              {
                "id": "A",
                "text": "Option A",
                "scores": {"Cryptomancien": 3, "Architectomage": 1}
              },
              {
                "id": "B",
                "text": "Option B",
                "scores": {"Cryptomancien": 1, "Architectomage": 3}
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

      // Act
      final quizAsync = container.read(quizFutureProvider);

      // Assert
      expect(quizAsync, isA<AsyncValue<Quiz>>());
      
      // Wait for the future to complete
      final quiz = await quizAsync.value;
      expect(quiz, isNotNull);
      expect(quiz!.title, equals('Test Quiz Provider'));
      expect(quiz.archtypes, hasLength(2));
      expect(quiz.questions, hasLength(1));
    });

    testWidgets('quizFutureProvider should handle errors', (WidgetTester tester) async {
      // Arrange
      // Mock the asset bundle to throw an error
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

      // Act & Assert
      expect(
        () => container.read(quizFutureProvider.future),
        throwsA(isA<PlatformException>()),
      );
    });

    group('AnswersNotifier', () {
      test('should initialize with empty map', () {
        // Act
        final answers = container.read(answersProvider);

        // Assert
        expect(answers, isEmpty);
      });

      test('should set answer correctly', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.setAnswer(1, 'A');

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, hasLength(1));
        expect(answers[1], equals('A'));
      });

      test('should set multiple answers correctly', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.setAnswer(1, 'A');
        notifier.setAnswer(2, 'B');
        notifier.setAnswer(3, 'C');

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, hasLength(3));
        expect(answers[1], equals('A'));
        expect(answers[2], equals('B'));
        expect(answers[3], equals('C'));
      });

      test('should overwrite existing answer', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.setAnswer(1, 'A');
        notifier.setAnswer(1, 'B'); // Overwrite

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, hasLength(1));
        expect(answers[1], equals('B'));
      });

      test('should clear all answers', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);
        notifier.setAnswer(1, 'A');
        notifier.setAnswer(2, 'B');
        notifier.setAnswer(3, 'C');

        // Act
        notifier.clear();

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, isEmpty);
      });

      test('should handle clearing empty answers', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.clear();

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, isEmpty);
      });

      test('should maintain state across multiple operations', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.setAnswer(1, 'A');
        notifier.setAnswer(2, 'B');
        
        var answers = container.read(answersProvider);
        expect(answers, hasLength(2));
        
        notifier.setAnswer(3, 'C');
        notifier.setAnswer(1, 'D'); // Update existing
        
        answers = container.read(answersProvider);
        
        // Assert
        expect(answers, hasLength(3));
        expect(answers[1], equals('D'));
        expect(answers[2], equals('B'));
        expect(answers[3], equals('C'));
      });

      test('should handle large number of answers', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        for (int i = 1; i <= 100; i++) {
          notifier.setAnswer(i, 'Option${i % 4 + 1}'); // A, B, C, D pattern
        }

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, hasLength(100));
        expect(answers[1], equals('OptionB')); // 1 % 4 + 1 = 2, Option2 -> OptionB
        expect(answers[50], equals('OptionC')); // 50 % 4 + 1 = 3, Option3 -> OptionC
        expect(answers[100], equals('OptionA')); // 100 % 4 + 1 = 1, Option1 -> OptionA
      });

      test('should handle special option IDs', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);

        // Act
        notifier.setAnswer(1, 'option_with_underscore');
        notifier.setAnswer(2, 'OPTION-WITH-DASH');
        notifier.setAnswer(3, 'Option123');
        notifier.setAnswer(4, '');
        notifier.setAnswer(5, 'Très_spécial_ñü');

        // Assert
        final answers = container.read(answersProvider);
        expect(answers, hasLength(5));
        expect(answers[1], equals('option_with_underscore'));
        expect(answers[2], equals('OPTION-WITH-DASH'));
        expect(answers[3], equals('Option123'));
        expect(answers[4], equals(''));
        expect(answers[5], equals('Très_spécial_ñü'));
      });

      test('should notify listeners when state changes', () {
        // Arrange
        final notifier = container.read(answersProvider.notifier);
        var notificationCount = 0;
        
        // Listen to state changes
        container.listen(answersProvider, (previous, next) {
          notificationCount++;
        });

        // Act
        notifier.setAnswer(1, 'A'); // +1 notification
        notifier.setAnswer(2, 'B'); // +1 notification
        notifier.setAnswer(1, 'C'); // +1 notification (overwrite)
        notifier.clear(); // +1 notification

        // Assert
        expect(notificationCount, equals(4));
      });
    });

    group('Provider Integration', () {
      testWidgets('should work together in realistic scenario', (WidgetTester tester) async {
        // Arrange
        const mockQuizJson = '''
        {
          "title": "Quiz d'intégration",
          "archtypes": ["Type1", "Type2", "Type3"],
          "questions": [
            {
              "id": 1,
              "text": "Question 1?",
              "options": [
                {"id": "A", "text": "Option A", "scores": {"Type1": 3}},
                {"id": "B", "text": "Option B", "scores": {"Type2": 3}},
                {"id": "C", "text": "Option C", "scores": {"Type3": 3}}
              ]
            },
            {
              "id": 2,
              "text": "Question 2?",
              "options": [
                {"id": "A", "text": "Option A", "scores": {"Type1": 2}},
                {"id": "B", "text": "Option B", "scores": {"Type2": 2}}
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

        // Act
        final quiz = await container.read(quizFutureProvider.future);
        final notifier = container.read(answersProvider.notifier);
        
        // Simulate user answering questions
        notifier.setAnswer(1, 'A'); // Choose Type1
        notifier.setAnswer(2, 'B'); // Choose Type2
        
        final answers = container.read(answersProvider);

        // Assert
        expect(quiz.title, equals('Quiz d\'intégration'));
        expect(quiz.questions, hasLength(2));
        expect(answers, hasLength(2));
        expect(answers[1], equals('A'));
        expect(answers[2], equals('B'));
        
        // Verify we can access the selected options
        final question1 = quiz.questions[0];
        final selectedOption1 = question1.options.firstWhere((opt) => opt.id == answers[1]);
        expect(selectedOption1.scores['Type1'], equals(3));
        
        final question2 = quiz.questions[1];
        final selectedOption2 = question2.options.firstWhere((opt) => opt.id == answers[2]);
        expect(selectedOption2.scores['Type2'], equals(2));
      });
    });
  });
}