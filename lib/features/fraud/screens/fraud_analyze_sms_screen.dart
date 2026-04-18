import 'package:flutter/material.dart';

class FraudAnalyzeSmsScreen extends StatelessWidget {
  const FraudAnalyzeSmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyze Custom SMS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 80, color: Color(0xFFD32F2F)),
            const SizedBox(height: 20),
            Text('Coming Soon!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            const Text('Paste any message here to get instant AI analysis.'),
          ],
        ),
      ),
    );
  }
}
