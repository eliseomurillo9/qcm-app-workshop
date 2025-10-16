import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/models/question.dart';
import 'package:epsi_sorcier_qcm/models/option.dart';

void main() {
  group('Question', () {
    test('should create Question from valid JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'text': 'Quelle est votre réaction préférée ?',
        'options': [
          {
            'id': 'A',
            'text': 'Option A',
            'scores': {'Cryptomancien': 3, 'Architectomage': 1}
          },
          {
            'id': 'B',
            'text': 'Option B',
            'scores': {'Cryptomancien': 1, 'Architectomage': 3}
          }
        ]
      };

      // Act
      final question = Question.fromJson(json);

      // Assert
      expect(question.id, equals(1));
      expect(question.text, equals('Quelle est votre réaction préférée ?'));
      expect(question.options, hasLength(2));
      expect(question.options[0].id, equals('A'));
      expect(question.options[0].text, equals('Option A'));
      expect(question.options[1].id, equals('B'));
      expect(question.options[1].text, equals('Option B'));
    });

    test('should create Question with empty options list', () {
      // Arrange
      final json = {
        'id': 2,
        'text': 'Question without options',
        'options': []
      };

      // Act
      final question = Question.fromJson(json);

      // Assert
      expect(question.id, equals(2));
      expect(question.text, equals('Question without options'));
      expect(question.options, isEmpty);
    });

    test('should handle constructor with all parameters', () {
      // Arrange
      final options = [
        AnswerOption(id: 'A', text: 'Option A', scores: {'type1': 1}),
        AnswerOption(id: 'B', text: 'Option B', scores: {'type2': 2}),
      ];

      // Act
      final question = Question(
        id: 3,
        text: 'Test question',
        options: options,
      );

      // Assert
      expect(question.id, equals(3));
      expect(question.text, equals('Test question'));
      expect(question.options, equals(options));
      expect(question.options, hasLength(2));
    });

    test('should throw when JSON is missing required fields', () {
      // Arrange
      final invalidJson = {
        'text': 'Missing ID and options'
      };

      // Act & Assert
      expect(
        () => Question.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('should throw when options is not a list', () {
      // Arrange
      final invalidJson = {
        'id': 1,
        'text': 'Valid text',
        'options': 'not a list'
      };

      // Act & Assert
      expect(
        () => Question.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle complex question with multiple options', () {
      // Arrange
      final json = {
        'id': 99,
        'text': 'Une question complexe avec plusieurs options de réponse ?',
        'options': [
          {
            'id': 'A',
            'text': 'Première option très détaillée',
            'scores': {
              'Cryptomancien': 3,
              'Architectomage': 1,
              'Datalchimiste': 2,
              'Technomancien': 0
            }
          },
          {
            'id': 'B',
            'text': 'Deuxième option également détaillée',
            'scores': {
              'Cryptomancien': 1,
              'Architectomage': 3,
              'Datalchimiste': 1,
              'Technomancien': 2
            }
          },
          {
            'id': 'C',
            'text': 'Troisième option pour compléter',
            'scores': {
              'Cryptomancien': 0,
              'Architectomage': 2,
              'Datalchimiste': 3,
              'Technomancien': 1
            }
          }
        ]
      };

      // Act
      final question = Question.fromJson(json);

      // Assert
      expect(question.id, equals(99));
      expect(question.text, contains('complexe'));
      expect(question.options, hasLength(3));
      
      // Vérifier chaque option
      expect(question.options[0].scores['Cryptomancien'], equals(3));
      expect(question.options[1].scores['Architectomage'], equals(3));
      expect(question.options[2].scores['Datalchimiste'], equals(3));
    });
  });
}