import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/services/result_service.dart';
import 'package:epsi_sorcier_qcm/models/sorciere.dart';

void main() {
  group('ResultService', () {
    late ResultService resultService;

    setUp(() {
      resultService = ResultService();
    });

    test('should return null when sorcieres list is empty', () {
      // Arrange
      final List<Sorciere> emptySorcieres = [];

      // Act
      final result = resultService.getTopSorciere(emptySorcieres);

      // Assert
      expect(result, isNull);
    });

    test('should return the only sorciere when list has one element', () {
      // Arrange
      final sorcieres = [Sorciere('Cryptomancien', 75.0)];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Cryptomancien'));
      expect(result.pourcentage, equals(75.0));
    });

    test('should return sorciere with highest percentage', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 75.0),
        Sorciere('Architectomage', 85.0), // Le plus haut
        Sorciere('Datalchimiste', 60.0),
        Sorciere('Technomancien', 70.0),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Architectomage'));
      expect(result.pourcentage, equals(85.0));
    });

    test('should return one of the tied sorcieres when multiple have same max percentage', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 80.0), // Égalité
        Sorciere('Architectomage', 70.0),
        Sorciere('Datalchimiste', 80.0), // Égalité
        Sorciere('Technomancien', 60.0),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.pourcentage, equals(80.0));
      expect(['Cryptomancien', 'Datalchimiste'], contains(result.nom));
    });

    test('should handle all sorcieres having same percentage', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 50.0),
        Sorciere('Architectomage', 50.0),
        Sorciere('Datalchimiste', 50.0),
        Sorciere('Technomancien', 50.0),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.pourcentage, equals(50.0));
      expect(['Cryptomancien', 'Architectomage', 'Datalchimiste', 'Technomancien'], 
             contains(result.nom));
    });

    test('should handle zero percentages', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 0.0),
        Sorciere('Architectomage', 0.0),
        Sorciere('Datalchimiste', 10.0), // Le plus haut
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Datalchimiste'));
      expect(result.pourcentage, equals(10.0));
    });

    test('should handle negative percentages', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', -10.0),
        Sorciere('Architectomage', -5.0), // Le plus haut (moins négatif)
        Sorciere('Datalchimiste', -20.0),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Architectomage'));
      expect(result.pourcentage, equals(-5.0));
    });

    test('should handle very high percentages', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 999.9),
        Sorciere('Architectomage', 1000.0), // Le plus haut
        Sorciere('Datalchimiste', 999.8),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Architectomage'));
      expect(result.pourcentage, equals(1000.0));
    });

    test('should handle decimal percentages', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 75.555),
        Sorciere('Architectomage', 75.556), // Le plus haut par 0.001
        Sorciere('Datalchimiste', 75.554),
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Architectomage'));
      expect(result.pourcentage, equals(75.556));
    });

    test('should return random result when called multiple times with tied percentages', () {
      // Arrange
      final sorcieres = [
        Sorciere('Cryptomancien', 80.0),
        Sorciere('Architectomage', 80.0),
      ];

      // Act - Appeler plusieurs fois pour vérifier la randomisation
      final results = <String>[];
      for (int i = 0; i < 20; i++) {
        final result = resultService.getTopSorciere(sorcieres);
        results.add(result!.nom);
      }

      // Assert - On s'attend à ce qu'au moins les deux noms apparaissent
      // Note: Ce test peut parfois échouer par hasard, mais c'est très improbable
      expect(results, contains('Cryptomancien'));
      expect(results, contains('Architectomage'));
      results.forEach((nom) {
        expect(['Cryptomancien', 'Architectomage'], contains(nom));
      });
    });

    test('should handle empty string names', () {
      // Arrange
      final sorcieres = [
        Sorciere('', 50.0),
        Sorciere('Architectomage', 60.0), // Le plus haut
      ];

      // Act
      final result = resultService.getTopSorciere(sorcieres);

      // Assert
      expect(result, isNotNull);
      expect(result!.nom, equals('Architectomage'));
      expect(result.pourcentage, equals(60.0));
    });
  });
}