import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:epsi_sorcier_qcm/services/local_quiz_service.dart';
import 'package:epsi_sorcier_qcm/models/quiz.dart';

void main() {
  group('LocalQuizService', () {
    late LocalQuizService localQuizService;

    setUp(() {
      localQuizService = LocalQuizService();
    });

    testWidgets('should load quiz from asset successfully', (WidgetTester tester) async {
      // Arrange
      const mockQuizJson = '''
      {
        "title": "Test Quiz",
        "archtypes": ["Type1", "Type2"],
        "questions": [
          {
            "id": 1,
            "text": "Test question?",
            "options": [
              {
                "id": "A",
                "text": "Option A",
                "scores": {"Type1": 3, "Type2": 1}
              },
              {
                "id": "B", 
                "text": "Option B",
                "scores": {"Type1": 1, "Type2": 3}
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
      final quiz = await localQuizService.loadQuizFromAsset();

      // Assert
      expect(quiz, isA<Quiz>());
      expect(quiz.title, equals('Test Quiz'));
      expect(quiz.archtypes, hasLength(2));
      expect(quiz.archtypes, contains('Type1'));
      expect(quiz.archtypes, contains('Type2'));
      expect(quiz.questions, hasLength(1));
      expect(quiz.questions[0].id, equals(1));
      expect(quiz.questions[0].text, equals('Test question?'));
      expect(quiz.questions[0].options, hasLength(2));
    });

    testWidgets('should handle complex quiz with multiple questions', (WidgetTester tester) async {
      // Arrange
      const mockComplexQuizJson = '''
      {
        "title": "Quiz EPSI Complet",
        "archtypes": ["Cryptomancien", "Architectomage", "Datalchimiste", "Technomancien"],
        "questions": [
          {
            "id": 1,
            "text": "Première question complexe?",
            "options": [
              {
                "id": "A",
                "text": "Option sécurité",
                "scores": {"Cryptomancien": 3, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 1}
              },
              {
                "id": "B",
                "text": "Option architecture",
                "scores": {"Cryptomancien": 1, "Architectomage": 3, "Datalchimiste": 1, "Technomancien": 1}
              },
              {
                "id": "C",
                "text": "Option données",
                "scores": {"Cryptomancien": 1, "Architectomage": 1, "Datalchimiste": 3, "Technomancien": 1}
              },
              {
                "id": "D",
                "text": "Option innovation",
                "scores": {"Cryptomancien": 1, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 3}
              }
            ]
          },
          {
            "id": 2,
            "text": "Deuxième question complexe?",
            "options": [
              {
                "id": "A",
                "text": "Réponse A",
                "scores": {"Cryptomancien": 2, "Technomancien": 2}
              },
              {
                "id": "B",
                "text": "Réponse B", 
                "scores": {"Architectomage": 2, "Datalchimiste": 2}
              }
            ]
          },
          {
            "id": 3,
            "text": "Troisième question?",
            "options": [
              {
                "id": "A",
                "text": "Une seule option",
                "scores": {"Cryptomancien": 1, "Architectomage": 1, "Datalchimiste": 1, "Technomancien": 1}
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
            return mockComplexQuizJson;
          }
          return null;
        },
      );

      // Act
      final quiz = await localQuizService.loadQuizFromAsset();

      // Assert
      expect(quiz.title, equals('Quiz EPSI Complet'));
      expect(quiz.archtypes, hasLength(4));
      expect(quiz.questions, hasLength(3));
      
      // Vérifier la première question
      final firstQuestion = quiz.questions[0];
      expect(firstQuestion.options, hasLength(4));
      expect(firstQuestion.options[0].scores['Cryptomancien'], equals(3));
      expect(firstQuestion.options[1].scores['Architectomage'], equals(3));
      expect(firstQuestion.options[2].scores['Datalchimiste'], equals(3));
      expect(firstQuestion.options[3].scores['Technomancien'], equals(3));
      
      // Vérifier la deuxième question
      final secondQuestion = quiz.questions[1];
      expect(secondQuestion.options, hasLength(2));
      expect(secondQuestion.options[0].scores['Cryptomancien'], equals(2));
      expect(secondQuestion.options[1].scores['Architectomage'], equals(2));
      
      // Vérifier la troisième question
      final thirdQuestion = quiz.questions[2];
      expect(thirdQuestion.options, hasLength(1));
    });

    testWidgets('should handle quiz with empty questions array', (WidgetTester tester) async {
      // Arrange
      const mockEmptyQuizJson = '''
      {
        "title": "Quiz Vide",
        "archtypes": ["Type1"],
        "questions": []
      }
      ''';

      // Mock the asset bundle
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString' && 
              methodCall.arguments == 'assets/quiz.json') {
            return mockEmptyQuizJson;
          }
          return null;
        },
      );

      // Act
      final quiz = await localQuizService.loadQuizFromAsset();

      // Assert
      expect(quiz.title, equals('Quiz Vide'));
      expect(quiz.archtypes, hasLength(1));
      expect(quiz.questions, isEmpty);
    });

    testWidgets('should throw error when asset loading fails', (WidgetTester tester) async {
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
        () => localQuizService.loadQuizFromAsset(),
        throwsA(isA<PlatformException>()),
      );
    });

    testWidgets('should throw error when JSON is malformed', (WidgetTester tester) async {
      // Arrange
      const malformedJson = '{"title": "Test", "invalid_json": }';

      // Mock the asset bundle
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString' && 
              methodCall.arguments == 'assets/quiz.json') {
            return malformedJson;
          }
          return null;
        },
      );

      // Act & Assert
      expect(
        () => localQuizService.loadQuizFromAsset(),
        throwsA(isA<FormatException>()),
      );
    });

    testWidgets('should throw error when required JSON fields are missing', (WidgetTester tester) async {
      // Arrange
      const incompleteJson = '''
      {
        "archtypes": ["Type1"],
        "questions": []
      }
      ''';

      // Mock the asset bundle
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString' && 
              methodCall.arguments == 'assets/quiz.json') {
            return incompleteJson;
          }
          return null;
        },
      );

      // Act & Assert
      expect(
        () => localQuizService.loadQuizFromAsset(),
        throwsA(isA<TypeError>()),
      );
    });

    tearDown(() {
      // Clean up mock method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), null);
    });
  });
}