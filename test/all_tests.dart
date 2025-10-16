import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'models/option_test.dart' as option_tests;
import 'models/question_test.dart' as question_tests;
import 'models/quiz_test.dart' as quiz_tests;
import 'models/sorciere_test.dart' as sorciere_tests;
import 'services/local_quiz_service_test.dart' as local_quiz_service_tests;
import 'services/result_service_test.dart' as result_service_tests;
import 'services/storage_service_test.dart' as storage_service_tests;
import 'providers/quiz_provider_test.dart' as provider_tests;
import 'ui/screens/home_screen_test.dart' as home_screen_tests;
import 'ui/screens/result_screen_test.dart' as result_screen_tests;
import 'integration/app_integration_test.dart' as integration_tests;

void main() {
  group('🧪 Tests Complets QCM App - EPSI Sorciers', () {
    group('📦 Tests des Modèles', () {
      option_tests.main();
      question_tests.main();
      quiz_tests.main();
      sorciere_tests.main();
    });

    group('⚙️ Tests des Services', () {
      local_quiz_service_tests.main();
      result_service_tests.main();
      storage_service_tests.main();
    });

    group('🎭 Tests des Providers', () {
      provider_tests.main();
    });

    group('🖼️ Tests des Widgets/Écrans', () {
      home_screen_tests.main();
      result_screen_tests.main();
    });

    group('🔗 Tests d\'Intégration', () {
      integration_tests.main();
    });
  });
}