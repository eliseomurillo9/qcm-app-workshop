import 'dart:math';
import '../models/sorciere.dart';

class ResultService {
  Sorciere? getTopSorciere(List<Sorciere> sorcieres) {
    if (sorcieres.isEmpty) return null;

    final maxPourcentage = sorcieres.map((s) => s.pourcentage).reduce(max);
    final topSorcieres =
        sorcieres.where((s) => s.pourcentage == maxPourcentage).toList();

    final random = Random();
    return topSorcieres[random.nextInt(topSorcieres.length)];
  }
}
