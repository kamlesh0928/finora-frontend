import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/game_provider.dart';

class ScenarioScreen extends StatelessWidget {
  const ScenarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Scenario')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Unexpected Expense: Your tractor needs an urgent repair. It will cost INR 2,000. How do you want to pay for it?',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildDecisionButton(
              context: context,
              title: 'Use emergency savings',
              subtitle: 'Costs INR 2,000. Low stress impact.',
              onTap: () {
                context.read<GameProvider>().makeDecision(2000.0, -0.05);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            _buildDecisionButton(
              context: context,
              title: 'Take a high-interest local loan',
              subtitle:
                  'Save cash now, but increases stress and long-term debt.',
              onTap: () {
                context.read<GameProvider>().makeDecision(0.0, 0.25);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
