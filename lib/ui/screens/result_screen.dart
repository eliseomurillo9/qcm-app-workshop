import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<String> sorcieres;

  const ResultScreen({super.key, required this.sorcieres});

  @override
  Widget build(BuildContext context) {
    final winner = sorcieres.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Résultat')),
      body: Center(
        child: Text(
          'Ta sorcière dominante est : $winner 🧙‍♀️',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
