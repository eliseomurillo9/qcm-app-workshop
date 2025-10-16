import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/models/sorciere.dart';

void main() {
  group('Sorciere', () {
    test('should create Sorciere with valid parameters', () {
      // Arrange
      const nom = 'Cryptomancien';
      const pourcentage = 75.5;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('Cryptomancien'));
      expect(sorciere.pourcentage, equals(75.5));
    });

    test('should create Sorciere with zero percentage', () {
      // Arrange
      const nom = 'Architectomage';
      const pourcentage = 0.0;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('Architectomage'));
      expect(sorciere.pourcentage, equals(0.0));
    });

    test('should create Sorciere with 100% percentage', () {
      // Arrange
      const nom = 'Datalchimiste';
      const pourcentage = 100.0;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('Datalchimiste'));
      expect(sorciere.pourcentage, equals(100.0));
    });

    test('should create Sorciere with decimal percentage', () {
      // Arrange
      const nom = 'Technomancien';
      const pourcentage = 33.33;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('Technomancien'));
      expect(sorciere.pourcentage, equals(33.33));
    });

    test('should create Sorciere with empty name', () {
      // Arrange
      const nom = '';
      const pourcentage = 50.0;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals(''));
      expect(sorciere.pourcentage, equals(50.0));
    });

    test('should create Sorciere with negative percentage', () {
      // Arrange
      const nom = 'TestSorcier';
      const pourcentage = -10.0;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('TestSorcier'));
      expect(sorciere.pourcentage, equals(-10.0));
    });

    test('should create Sorciere with very high percentage', () {
      // Arrange
      const nom = 'SuperSorcier';
      const pourcentage = 999.99;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('SuperSorcier'));
      expect(sorciere.pourcentage, equals(999.99));
    });

    test('should create multiple different Sorciere instances', () {
      // Arrange & Act
      final cryptomancien = Sorciere('Cryptomancien', 85.0);
      final architectomage = Sorciere('Architectomage', 70.5);
      final datalchimiste = Sorciere('Datalchimiste', 92.3);
      final technomancien = Sorciere('Technomancien', 68.8);

      // Assert
      expect(cryptomancien.nom, equals('Cryptomancien'));
      expect(cryptomancien.pourcentage, equals(85.0));
      
      expect(architectomage.nom, equals('Architectomage'));
      expect(architectomage.pourcentage, equals(70.5));
      
      expect(datalchimiste.nom, equals('Datalchimiste'));
      expect(datalchimiste.pourcentage, equals(92.3));
      
      expect(technomancien.nom, equals('Technomancien'));
      expect(technomancien.pourcentage, equals(68.8));
    });

    test('should handle special characters in name', () {
      // Arrange
      const nom = 'Sorcier-Élève_123 ñü';
      const pourcentage = 42.0;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals('Sorcier-Élève_123 ñü'));
      expect(sorciere.pourcentage, equals(42.0));
    });

    test('should handle very long name', () {
      // Arrange
      const nom = 'Très-long-nom-de-sorcier-avec-beaucoup-de-caractères-pour-tester-les-limites-du-modèle';
      const pourcentage = 15.7;

      // Act
      final sorciere = Sorciere(nom, pourcentage);

      // Assert
      expect(sorciere.nom, equals(nom));
      expect(sorciere.pourcentage, equals(15.7));
    });
  });
}