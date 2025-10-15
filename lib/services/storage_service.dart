import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String boxName = 'quiz_state';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get box => Hive.box(boxName);

  static void saveProgress(Map<String, dynamic> map) {
    box.put('progress', map);
  }

  static Map<String, dynamic>? getProgress() {
    final v = box.get('progress');
    if (v == null) return null;
    return Map<String, dynamic>.from(v as Map);
  }

  static void saveResult(Map<String, dynamic> data) {
    box.put('lastResult', data);
  }

  static Map<String, dynamic>? getLastResult() {
    final v = box.get('lastResult');
    if (v == null) return null;
    return Map<String, dynamic>.from(v as Map);
  }
}
