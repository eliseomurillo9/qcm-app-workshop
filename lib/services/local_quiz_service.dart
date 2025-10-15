import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz.dart';

class LocalQuizService {
  Future<Quiz> loadQuizFromAsset() async {
    final raw = await rootBundle.loadString('assets/quiz.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    return Quiz.fromJson(map);
  }
}
