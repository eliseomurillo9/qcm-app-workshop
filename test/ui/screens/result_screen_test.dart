import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/ui/screens/result_screen.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ResultScreen Widget Tests', () {
    testWidgets('should display winner sorciere correctly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Cryptomancien 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should display different winner correctly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Architectomage'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Architectomage 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should display Datalchimiste winner correctly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Datalchimiste'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Datalchimiste 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should display Technomancien winner correctly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Technomancien'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Technomancien 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should handle multiple sorcieres by showing first one', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien', 'Architectomage', 'Datalchimiste'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Cryptomancien 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should have proper app bar', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Résultat'), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(2)); // AppBar title + result text
    });

    testWidgets('should have correct text styling', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Architectomage'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      final resultText = tester.widget<Text>(
        find.text('Ta sorcière dominante est : Architectomage 🧙‍♀️'),
      );
      
      expect(resultText.style?.fontSize, equals(24));
      expect(resultText.style?.fontWeight, equals(FontWeight.bold));
      expect(resultText.textAlign, equals(TextAlign.center));
    });

    testWidgets('should handle empty sorciere name gracefully', (WidgetTester tester) async {
      // Arrange
      const sorcieres = [''];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est :  🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should handle special characters in sorciere name', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Sorcier-Élève_123'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Sorcier-Élève_123 🧙‍♀️'), findsOneWidget);
    });

    testWidgets('should be responsive to different screen sizes', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien'];
      
      // Test avec une petite taille d'écran
      await tester.binding.setSurfaceSize(const Size(320, 568));
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Cryptomancien 🧙‍♀️'), findsOneWidget);
      
      // Test avec une grande taille d'écran
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      await tester.pumpAndSettle();
      
      expect(find.text('Ta sorcière dominante est : Cryptomancien 🧙‍♀️'), findsOneWidget);
      
      // Reset to default
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle theme changes properly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Datalchimiste'];
      
      final darkTheme = ThemeData.dark();
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestAppWithTheme(
          child: const ResultScreen(sorcieres: sorcieres),
          theme: darkTheme,
        ),
      );

      // Assert
      expect(find.text('Ta sorcière dominante est : Datalchimiste 🧙‍♀️'), findsOneWidget);
      expect(find.byType(ResultScreen), findsOneWidget);
    });

    testWidgets('should render emoji correctly', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['TestSorcier'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      final resultText = find.text('Ta sorcière dominante est : TestSorcier 🧙‍♀️');
      expect(resultText, findsOneWidget);
      
      // Vérifier que l'emoji est bien inclus dans le texte
      final textWidget = tester.widget<Text>(resultText);
      expect(textWidget.data, contains('🧙‍♀️'));
    });

    testWidgets('should have proper accessibility features', (WidgetTester tester) async {
      // Arrange
      const sorcieres = ['Cryptomancien'];
      
      // Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: const ResultScreen(sorcieres: sorcieres),
        ),
      );

      // Assert
      // Vérifie que le texte principal est accessible
      final resultText = find.text('Ta sorcière dominante est : Cryptomancien 🧙‍♀️');
      expect(resultText, findsOneWidget);
      
      // Vérifie la structure sémantique
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}