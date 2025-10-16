import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/models/quiz.dart';
import 'package:epsi_sorcier_qcm/models/question.dart';
import 'package:epsi_sorcier_qcm/models/option.dart';

void main() {
  group('Quiz', () {
    test('should create Quiz from valid JSON', () {
      // Arrange
      final json = {
        'title': 'Quel sorcier de l\'EPSI es-tu ?',
        'archtypes': [
          'Cryptomancien',
          'Architectomage',
          'Datalchimiste',
          'Technomancien'
        ],
        'questions': [
          {
            'id': 1,
            'text': 'Première question ?',
            'options': [
              {
                'id': 'A',
                'text': 'Option A',
                'scores': {'Cryptomancien': 3, 'Architectomage': 1}
              }
            ]
          },
          {
            'id': 2,
            'text': 'Deuxième question ?',
            'options': [
              {
                'id': 'A',
                'text': 'Option A',
                'scores': {'Datalchimiste': 2, 'Technomancien': 3}
              }
            ]
          }
        ]
      };

      // Act
      final quiz = Quiz.fromJson(json);

      // Assert
      expect(quiz.title, equals('Quel sorcier de l\'EPSI es-tu ?'));
      expect(quiz.archtypes, hasLength(4));
      expect(quiz.archtypes, contains('Cryptomancien'));
      expect(quiz.archtypes, contains('Architectomage'));
      expect(quiz.archtypes, contains('Datalchimiste'));
      expect(quiz.archtypes, contains('Technomancien'));
      expect(quiz.questions, hasLength(2));
      expect(quiz.questions[0].id, equals(1));
      expect(quiz.questions[1].id, equals(2));
    });

    test('should create Quiz with empty questions and archtypes', () {
      // Arrange
      final json = {
        'title': 'Quiz vide',
        'archtypes': [],
        'questions': []
      };

      // Act
      final quiz = Quiz.fromJson(json);

      // Assert
      expect(quiz.title, equals('Quiz vide'));
      expect(quiz.archtypes, isEmpty);
      expect(quiz.questions, isEmpty);
    });

    test('should handle constructor with all parameters', () {
      // Arrange
      final archtypes = ['Type1', 'Type2', 'Type3'];
      final questions = [
        Question(
          id: 1,
          text: 'Question test',
          options: [
            AnswerOption(id: 'A', text: 'Option A', scores: {'Type1': 1})
          ],
        ),
      ];

      // Act
      final quiz = Quiz(
        title: 'Quiz de test',
        archtypes: archtypes,
        questions: questions,
      );

      // Assert
      expect(quiz.title, equals('Quiz de test'));
      expect(quiz.archtypes, equals(archtypes));
      expect(quiz.questions, equals(questions));
    });

    test('should throw when JSON is missing required fields', () {
      // Arrange
      final invalidJson = {
        'archtypes': ['Type1'],
        'questions': []
      };

      // Act & Assert
      expect(
        () => Quiz.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw when archtypes is not a list', () {
      // Arrange
      final invalidJson = {
        'title': 'Valid title',
        'archtypes': 'not a list',
        'questions': []
      };

      // Act & Assert
      expect(
        () => Quiz.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw when questions is not a list', () {
      // Arrange
      final invalidJson = {
        'title': 'Valid title',
        'archtypes': ['Type1'],
        'questions': 'not a list'
      };

      // Act & Assert
      expect(
        () => Quiz.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle complex quiz with multiple questions and archtypes', () {
      // Arrange
      final json = {
        'title': 'Quiz Complet EPSI - Découvrez votre profil tech',
        'archtypes': [
          'Cryptomancien',
          'Architectomage',
          'Datalchimiste',
          'Technomancien',
          'DevOpsorcier'
        ],
        'questions': [
          {
            'id': 1,
            'text': 'Votre approche pour résoudre un problème complexe ?',
            'options': [
              {
                'id': 'A',
                'text': 'Analyser la sécurité avant tout',
                'scores': {
                  'Cryptomancien': 3,
                  'Architectomage': 1,
                  'Datalchimiste': 1,
                  'Technomancien': 1,
                  'DevOpsorcier': 1
                }
              },
              {
                'id': 'B',
                'text': 'Concevoir une architecture solide',
                'scores': {
                  'Cryptomancien': 1,
                  'Architectomage': 3,
                  'Datalchimiste': 1,
                  'Technomancien': 1,
                  'DevOpsorcier': 1
                }
              }
            ]
          },
          {
            'id': 2,
            'text': 'Votre outil préféré pour le développement ?',
            'options': [
              {
                'id': 'A',
                'text': 'Outils de cryptographie',
                'scores': {'Cryptomancien': 3}
              },
              {
                'id': 'B',
                'text': 'Outils d\'analyse de données',
                'scores': {'Datalchimiste': 3}
              }
            ]
          }
        ]
      };

      // Act
      final quiz = Quiz.fromJson(json);

      // Assert
      expect(quiz.title, contains('EPSI'));
      expect(quiz.archtypes, hasLength(5));
      expect(quiz.archtypes, contains('DevOpsorcier'));
      expect(quiz.questions, hasLength(2));
      
      // Vérifier la première question
      final firstQuestion = quiz.questions[0];
      expect(firstQuestion.text, contains('problème complexe'));
      expect(firstQuestion.options, hasLength(2));
      expect(firstQuestion.options[0].scores['Cryptomancien'], equals(3));
      expect(firstQuestion.options[1].scores['Architectomage'], equals(3));
      
      // Vérifier la deuxième question
      final secondQuestion = quiz.questions[1];
      expect(secondQuestion.text, contains('outil préféré'));
      expect(secondQuestion.options, hasLength(2));
    });
  });
}