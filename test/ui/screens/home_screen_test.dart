import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epsi_sorcier_qcm/ui/screens/home_screen.dart';
import 'package:epsi_sorcier_qcm/ui/screens/quiz_screen.dart';
import 'package:epsi_sorcier_qcm/ui/screens/result_screen.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should display main title and subtitle', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Assert
      expect(find.text('Le Choix du Sorcier Tech'), findsOneWidget);
      expect(find.text('Découvre ton archétype à l\'EPSI'), findsOneWidget);
    });

    testWidgets('should display start test button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Assert
      expect(find.text('Commencer le test'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display last result button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Assert
      expect(find.text('Voir dernier résultat'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should have correct background color', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Assert
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFF002d64)));
    });

    testWidgets('should navigate to quiz screen when start button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Act
      await tester.tap(find.text('Commencer le test'));
      await tester.pumpAndSettle();

      // Assert
      // Vérifie qu'on navigue vers le QuizScreen
      expect(find.byType(QuizScreen), findsOneWidget);
    });

    testWidgets('should navigate to result screen when last result button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Act
      await tester.tap(find.text('Voir dernier résultat'));
      await tester.pumpAndSettle();

      // Assert
      // Vérifie qu'on navigue vers le ResultScreen
      expect(find.byType(ResultScreen), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        WidgetTestHelpers.createTestApp(
          child: HomeScreen(),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Spacer), findsOneWidget);
    });
  });
}