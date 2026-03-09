import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/game_provider.dart';
import '../../game/screens/scenario_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Finora Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial Overview',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSavingsCard(context, gameProvider.savings),
              const SizedBox(height: 16),
              _buildStressIndicator(context, gameProvider.stressLevel),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScenarioScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Next Scenario',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsCard(BuildContext context, double savings) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Savings',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'INR ${savings.toStringAsFixed(0)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStressIndicator(BuildContext context, double stressLevel) {
    final theme = Theme.of(context);
    Color stressColor = stressLevel > 0.7
        ? theme.colorScheme.error
        : (stressLevel > 0.4 ? Colors.orange : theme.colorScheme.secondary);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Financial Stress', style: theme.textTheme.titleMedium),
              Text(
                '${(stressLevel * 100).toInt()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: stressColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: stressLevel,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: stressColor,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}
