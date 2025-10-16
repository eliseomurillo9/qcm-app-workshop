import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/models/option.dart';

void main() {
  group('AnswerOption', () {
    test('should create AnswerOption from valid JSON', () {
      // Arrange
      final json = {
        'id': 'A',
        'text': 'Option A text',
        'scores': {
          'Cryptomancien': 3,
          'Architectomage': 1,
          'Datalchimiste': 2,
          'Technomancien': 1
        }
      };

      // Act
      final option = AnswerOption.fromJson(json);

      // Assert
      expect(option.id, equals('A'));
      expect(option.text, equals('Option A text'));
      expect(option.scores['Cryptomancien'], equals(3));
      expect(option.scores['Architectomage'], equals(1));
      expect(option.scores['Datalchimiste'], equals(2));
      expect(option.scores['Technomancien'], equals(1));
    });

    test('should create AnswerOption with empty scores when scores is null', () {
      // Arrange
      final json = {
        'id': 'B',
        'text': 'Option B text',
        'scores': null
      };

      // Act
      final option = AnswerOption.fromJson(json);

      // Assert
      expect(option.id, equals('B'));
      expect(option.text, equals('Option B text'));
      expect(option.scores, isEmpty);
    });

    test('should create AnswerOption with empty scores when scores is missing', () {
      // Arrange
      final json = {
        'id': 'C',
        'text': 'Option C text'
      };

      // Act
      final option = AnswerOption.fromJson(json);

      // Assert
      expect(option.id, equals('C'));
      expect(option.text, equals('Option C text'));
      expect(option.scores, isEmpty);
    });

    test('should handle constructor with all parameters', () {
      // Arrange
      final scores = {
        'Cryptomancien': 2,
        'Architectomage': 3,
      };

      // Act
      final option = AnswerOption(
        id: 'D',
        text: 'Test option',
        scores: scores,
      );

      // Assert
      expect(option.id, equals('D'));
      expect(option.text, equals('Test option'));
      expect(option.scores, equals(scores));
    });

    test('should throw when JSON is missing required fields', () {
      // Arrange
      final invalidJson = {
        'text': 'Missing ID'
      };

      // Act & Assert
      expect(
        () => AnswerOption.fromJson(invalidJson),
        throwsA(isA<TypeError>()),
      );
    });
  });
}