import 'package:flutter/material.dart';

class EmergencyLearningScreen extends StatelessWidget {
  const EmergencyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Prep Guide')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Color(0xFFF57C00)),
            const SizedBox(height: 20),
            Text('Coming Soon!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            const Text('Detailed guides on building and maintaining a resilient emergency fund.'),
          ],
        ),
      ),
    );
  }
}
