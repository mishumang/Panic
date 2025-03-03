// complete_breathing_page.dart
import 'package:flutter/material.dart';

class CompleteBreathingPage extends StatelessWidget {
  const CompleteBreathingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Breathing")),
      body: const Center(
        child: Text(
          "Dummy content for Complete Breathing.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
