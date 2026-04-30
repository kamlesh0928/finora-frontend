import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final game = context.watch<GameProvider>();
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile'.tr(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Profile card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        (auth.userName ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.userName ?? 'Player',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _profileTag(
                            auth.userRole ?? 'No role',
                            _getRoleColor(auth.userRole),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats grid
              Text(
                'your_stats'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.8,
                children: [
                  _statCard(
                    'health_score'.tr(),
                    '${game.financialHealthScore}/100',
                    Icons.favorite,
                    const Color(0xFFD32F2F),
                  ),
                  _statCard(
                    'safety_score'.tr(),
                    '${game.safetyScore}/100',
                    Icons.shield,
                    const Color(0xFF1565C0),
                  ),
                  _statCard(
                    'decisions'.tr(),
                    '${game.totalDecisionsMade}',
                    Icons.check_circle,
                    const Color(0xFF43A047),
                  ),
                  _statCard(
                    'scenarios'.tr(),
                    '${game.currentScenarioIndex}/${game.totalScenarios}',
                    Icons.flag,
                    const Color(0xFFF57C00),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Achievements
              Text(
                'achievements'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _achievementTile(
                theme,
                Icons.eco,
                'First Steps',
                'Complete your first scenario',
                game.earnedAchievementIds.contains('a1'),
              ),
              _achievementTile(
                theme,
                Icons.savings,
                'Smart Saver',
                'Save 10,000 in wallet',
                game.earnedAchievementIds.contains('a2'),
              ),
              _achievementTile(
                theme,
                Icons.shield,
                'Fraud Fighter',
                'Achieve 80+ safety score',
                game.earnedAchievementIds.contains('a3'),
              ),
              _achievementTile(
                theme,
                Icons.pie_chart,
                'Budget Master',
                'Complete budget allocation',
                game.earnedAchievementIds.contains('a4'),
              ),
              _achievementTile(
                theme,
                Icons.account_balance,
                'Emergency Ready',
                'Build 50,000 emergency fund',
                game.earnedAchievementIds.contains('a5'),
              ),
              _achievementTile(
                theme,
                Icons.menu_book,
                'Knowledge Seeker',
                'Read all micro-learning facts',
                game.earnedAchievementIds.contains('a6'),
              ),
              _achievementTile(
                theme,
                Icons.emoji_events,
                'Financial Champion',
                'Complete all modules',
                game.earnedAchievementIds.contains('a7'),
              ),
              const SizedBox(height: 24),

              // Settings
              Text(
                'settings'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _settingsTile(
                context,
                icon: Icons.refresh,
                title: 'reset_progress'.tr(),
                subtitle: 'Start fresh',
                onTap: () => _showResetDialog(context, game, wallet),
              ),
              _settingsTile(
                context,
                icon: Icons.logout,
                title: 'logout'.tr(),
                subtitle: 'Sign out of your account',
                isDestructive: true,
                onTap: () => _handleLogout(context, auth),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievementTile(
    ThemeData theme,
    IconData icon,
    String title,
    String desc,
    bool earned,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned
            ? const Color(0xFFFFF8E1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: earned
            ? Border.all(color: const Color(0xFFF9A825).withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: earned
                  ? const Color(0xFFF9A825).withValues(alpha: 0.15)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: earned ? const Color(0xFFF9A825) : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: earned ? null : Colors.grey,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: earned
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            earned ? Icons.check_circle : Icons.lock_outline,
            color: earned ? const Color(0xFFF9A825) : Colors.grey.shade300,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? const Color(0xFFD32F2F)
        : theme.colorScheme.onSurface;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'Farmer':
        return const Color(0xFF4CAF50);
      case 'Woman':
        return const Color(0xFFE91E63);
      case 'Student':
        return const Color(0xFF2196F3);
      case 'Young Adult':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF757575);
    }
  }

  void _showResetDialog(
    BuildContext context,
    GameProvider game,
    WalletProvider wallet,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Progress'),
        content: const Text(
          'This will reset ALL your progress, wallet, and achievements. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              game.resetGame();
              wallet.reset();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              auth.logout();
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
