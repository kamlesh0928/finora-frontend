import 'package:flutter/material.dart';

class BudgetGoalsScreen extends StatelessWidget {
  const BudgetGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Goals')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag_rounded, size: 80, color: Color(0xFF1565C0)),
            const SizedBox(height: 20),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              'Set long-term goals like buying a tractor or pursuing education.',
            ),
          ],
        ),
      ),
    );
  }
}
