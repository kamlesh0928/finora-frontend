import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Achievements')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Color(0xFFF9A825)),
            const SizedBox(height: 20),
            Text('Coming Soon!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            const Text('See all unlockable badges and your progress.'),
          ],
        ),
      ),
    );
  }
}
