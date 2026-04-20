import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/game_provider.dart';

class _AchievementData {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const _AchievementData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const List<_AchievementData> _allAchievements = [
  _AchievementData(
    id: 'a1',
    name: 'First Steps',
    description: 'Complete your first financial scenario',
    icon: Icons.eco,
    color: Color(0xFF43A047),
  ),
  _AchievementData(
    id: 'a2',
    name: 'Smart Saver',
    description: 'Accumulate 10,000 in your wallet balance',
    icon: Icons.savings,
    color: Color(0xFF1565C0),
  ),
  _AchievementData(
    id: 'a3',
    name: 'Fraud Fighter',
    description: 'Achieve a safety score of 80 or higher',
    icon: Icons.shield,
    color: Color(0xFFD32F2F),
  ),
  _AchievementData(
    id: 'a4',
    name: 'Budget Master',
    description: 'Complete a budget allocation challenge',
    icon: Icons.pie_chart,
    color: Color(0xFF7B1FA2),
  ),
  _AchievementData(
    id: 'a5',
    name: 'Emergency Ready',
    description: 'Build an emergency fund of 50,000',
    icon: Icons.account_balance,
    color: Color(0xFFF57C00),
  ),
  _AchievementData(
    id: 'a6',
    name: 'Knowledge Seeker',
    description: 'Read all micro-learning facts',
    icon: Icons.menu_book,
    color: Color(0xFF00838F),
  ),
  _AchievementData(
    id: 'a7',
    name: 'Financial Champion',
    description: 'Complete all scenarios for your role',
    icon: Icons.emoji_events,
    color: Color(0xFFF9A825),
  ),
];

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final game = context.watch<GameProvider>();
    final earned = game.earnedAchievementIds;
    final earnedCount = _allAchievements
        .where((a) => earned.contains(a.id))
        .length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('All Achievements')),
      body: SafeArea(
        child: Column(
          children: [
            // Progress header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9A825), Color(0xFFF57C00)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$earnedCount / ${_allAchievements.length} Unlocked',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: earnedCount / _allAchievements.length,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            color: Colors.white,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Achievement list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _allAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = _allAchievements[index];
                  final isEarned = earned.contains(achievement.id);
                  return _buildAchievementCard(theme, achievement, isEarned);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(
    ThemeData theme,
    _AchievementData achievement,
    bool isEarned,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEarned
            ? achievement.color.withValues(alpha: 0.06)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned
              ? achievement.color.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: isEarned ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEarned
                  ? achievement.color.withValues(alpha: 0.12)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              achievement.icon,
              color: isEarned ? achievement.color : Colors.grey.shade400,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEarned ? theme.colorScheme.onSurface : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isEarned
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isEarned ? Icons.check_circle : Icons.lock_outline,
            color: isEarned ? achievement.color : Colors.grey.shade300,
            size: 24,
          ),
        ],
      ),
    );
  }
}
