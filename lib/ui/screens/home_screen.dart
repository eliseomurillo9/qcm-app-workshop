import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFF002d64),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Lottie.asset('assets/lottie/patronus.json',
                width: 220, repeat: true),
            SizedBox(height: 20),
            Text("Le Choix du Sorcier Tech",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white)),
            SizedBox(height: 12),
            Text("Découvre ton archétype à l'EPSI",
                style: TextStyle(color: Colors.white70)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => QuizScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00a4e4),
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text("Commencer le test",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ResultScreen(sorcieres: []),
                  ),
                );
              },
              child: Text("Voir dernier résultat",
                  style: TextStyle(color: Colors.white70)),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
