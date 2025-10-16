import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:epsi_sorcier_qcm/services/storage_service.dart';
import 'dart:io';

void main() {
  group('StorageService', () {
    late Directory tempDir;

    setUp(() async {
      // Créer un répertoire temporaire pour les tests
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      
      // Initialiser Hive avec le répertoire temporaire
      Hive.init(tempDir.path);
      
      // Ouvrir la box pour les tests
      await Hive.openBox(StorageService.boxName);
    });

    tearDown(() async {
      // Nettoyer après chaque test
      if (Hive.isBoxOpen(StorageService.boxName)) {
        await Hive.box(StorageService.boxName).clear();
        await Hive.box(StorageService.boxName).close();
      }
      
      // Supprimer le répertoire temporaire
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should save and retrieve progress correctly', () {
      // Arrange
      final progressData = {
        'currentQuestion': 3,
        'answers': {
          '1': 'A',
          '2': 'B',
          '3': 'C'
        },
        'startTime': '2024-01-01T10:00:00Z'
      };

      // Act
      StorageService.saveProgress(progressData);
      final retrievedProgress = StorageService.getProgress();

      // Assert
      expect(retrievedProgress, isNotNull);
      expect(retrievedProgress!['currentQuestion'], equals(3));
      expect(retrievedProgress['answers'], isA<Map>());
      expect(retrievedProgress['answers']['1'], equals('A'));
      expect(retrievedProgress['answers']['2'], equals('B'));
      expect(retrievedProgress['answers']['3'], equals('C'));
      expect(retrievedProgress['startTime'], equals('2024-01-01T10:00:00Z'));
    });

    test('should return null when no progress is saved', () {
      // Act
      final progress = StorageService.getProgress();

      // Assert
      expect(progress, isNull);
    });

    test('should overwrite previous progress when saving new progress', () {
      // Arrange
      final firstProgress = {
        'currentQuestion': 1,
        'answers': {'1': 'A'}
      };
      final secondProgress = {
        'currentQuestion': 5,
        'answers': {'1': 'B', '2': 'C', '3': 'A', '4': 'D', '5': 'B'}
      };

      // Act
      StorageService.saveProgress(firstProgress);
      StorageService.saveProgress(secondProgress);
      final retrievedProgress = StorageService.getProgress();

      // Assert
      expect(retrievedProgress, isNotNull);
      expect(retrievedProgress!['currentQuestion'], equals(5));
      expect(retrievedProgress['answers']['1'], equals('B'));
      expect(retrievedProgress['answers'], hasLength(5));
    });

    test('should save and retrieve result correctly', () {
      // Arrange
      final resultData = {
        'winnerSorcerer': 'Cryptomancien',
        'percentage': 85.5,
        'scores': {
          'Cryptomancien': 85.5,
          'Architectomage': 70.2,
          'Datalchimiste': 60.8,
          'Technomancien': 75.1
        },
        'completedAt': '2024-01-01T12:30:00Z',
        'totalQuestions': 10
      };

      // Act
      StorageService.saveResult(resultData);
      final retrievedResult = StorageService.getLastResult();

      // Assert
      expect(retrievedResult, isNotNull);
      expect(retrievedResult!['winnerSorcerer'], equals('Cryptomancien'));
      expect(retrievedResult['percentage'], equals(85.5));
      expect(retrievedResult['scores'], isA<Map>());
      expect(retrievedResult['scores']['Cryptomancien'], equals(85.5));
      expect(retrievedResult['completedAt'], equals('2024-01-01T12:30:00Z'));
      expect(retrievedResult['totalQuestions'], equals(10));
    });

    test('should return null when no result is saved', () {
      // Act
      final result = StorageService.getLastResult();

      // Assert
      expect(result, isNull);
    });

    test('should overwrite previous result when saving new result', () {
      // Arrange
      final firstResult = {
        'winnerSorcerer': 'Architectomage',
        'percentage': 60.0
      };
      final secondResult = {
        'winnerSorcerer': 'Datalchimiste',
        'percentage': 90.0
      };

      // Act
      StorageService.saveResult(firstResult);
      StorageService.saveResult(secondResult);
      final retrievedResult = StorageService.getLastResult();

      // Assert
      expect(retrievedResult, isNotNull);
      expect(retrievedResult!['winnerSorcerer'], equals('Datalchimiste'));
      expect(retrievedResult['percentage'], equals(90.0));
    });

    test('should handle empty progress data', () {
      // Arrange
      final emptyProgress = <String, dynamic>{};

      // Act
      StorageService.saveProgress(emptyProgress);
      final retrievedProgress = StorageService.getProgress();

      // Assert
      expect(retrievedProgress, isNotNull);
      expect(retrievedProgress!, isEmpty);
    });

    test('should handle empty result data', () {
      // Arrange
      final emptyResult = <String, dynamic>{};

      // Act
      StorageService.saveResult(emptyResult);
      final retrievedResult = StorageService.getLastResult();

      // Assert
      expect(retrievedResult, isNotNull);
      expect(retrievedResult!, isEmpty);
    });

    test('should handle complex nested data structures', () {
      // Arrange
      final complexProgress = {
        'metadata': {
          'version': '1.0',
          'device': 'test'
        },
        'userAnswers': [
          {'questionId': 1, 'optionId': 'A', 'timestamp': '10:00'},
          {'questionId': 2, 'optionId': 'B', 'timestamp': '10:05'},
        ],
        'statistics': {
          'timePerQuestion': [30, 45, 25],
          'confidence': [0.8, 0.9, 0.7]
        }
      };

      // Act
      StorageService.saveProgress(complexProgress);
      final retrievedProgress = StorageService.getProgress();

      // Assert
      expect(retrievedProgress, isNotNull);
      expect(retrievedProgress!['metadata']['version'], equals('1.0'));
      expect(retrievedProgress['userAnswers'], hasLength(2));
      expect(retrievedProgress['userAnswers'][0]['questionId'], equals(1));
      expect(retrievedProgress['statistics']['timePerQuestion'], hasLength(3));
      expect(retrievedProgress['statistics']['confidence'][1], equals(0.9));
    });

    test('should handle null values in data', () {
      // Arrange
      final dataWithNulls = {
        'validField': 'value',
        'nullField': null,
        'emptyString': '',
        'zeroValue': 0
      };

      // Act
      StorageService.saveProgress(dataWithNulls);
      final retrievedProgress = StorageService.getProgress();

      // Assert
      expect(retrievedProgress, isNotNull);
      expect(retrievedProgress!['validField'], equals('value'));
      expect(retrievedProgress['nullField'], isNull);
      expect(retrievedProgress['emptyString'], equals(''));
      expect(retrievedProgress['zeroValue'], equals(0));
    });

    test('should maintain data integrity across multiple operations', () {
      // Arrange
      final progress1 = {'step': 1, 'data': 'first'};
      final result1 = {'score': 80, 'type': 'first_result'};
      final progress2 = {'step': 2, 'data': 'second'};
      final result2 = {'score': 95, 'type': 'second_result'};

      // Act
      StorageService.saveProgress(progress1);
      StorageService.saveResult(result1);
      
      final midProgress = StorageService.getProgress();
      final midResult = StorageService.getLastResult();
      
      StorageService.saveProgress(progress2);
      StorageService.saveResult(result2);
      
      final finalProgress = StorageService.getProgress();
      final finalResult = StorageService.getLastResult();

      // Assert
      // Vérifier les données intermédiaires
      expect(midProgress!['step'], equals(1));
      expect(midResult!['score'], equals(80));
      
      // Vérifier les données finales
      expect(finalProgress!['step'], equals(2));
      expect(finalProgress['data'], equals('second'));
      expect(finalResult!['score'], equals(95));
      expect(finalResult['type'], equals('second_result'));
    });

    test('should access box property correctly', () {
      // Act
      final box = StorageService.box;

      // Assert
      expect(box, isA<Box>());
      expect(box.name, equals(StorageService.boxName));
    });
  });
}