import 'package:flutter/material.dart';

class FraudLiveFeedScreen extends StatelessWidget {
  const FraudLiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Scam Feed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rss_feed, size: 80, color: Color(0xFFD32F2F)),
            const SizedBox(height: 20),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text('Real-time database of trending financial scams.'),
          ],
        ),
      ),
    );
  }
}
