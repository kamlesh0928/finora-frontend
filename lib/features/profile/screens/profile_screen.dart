/// Profile & Achievements Screen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
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
              Text('Profile', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Profile card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                      child: Text(
                        (auth.userName ?? 'U')[0].toUpperCase(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth.userName ?? 'Player', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _profileTag(auth.userRole ?? 'No role', _getRoleColor(auth.userRole)),
                              const SizedBox(width: 6),
                              _profileTag(auth.language == 'hi' ? 'हिन्दी' : 'English', const Color(0xFF1565C0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats grid
              Text('Your Stats', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.8,
                children: [
                  _statCard('Health Score', '${game.financialHealthScore}/100', Icons.favorite, const Color(0xFFD32F2F)),
                  _statCard('Safety Score', '${game.safetyScore}/100', Icons.shield, const Color(0xFF1565C0)),
                  _statCard('Decisions', '${game.totalDecisionsMade}', Icons.check_circle, const Color(0xFF43A047)),
                  _statCard('Scenarios', '${game.currentScenarioIndex}/${game.totalScenarios}', Icons.flag, const Color(0xFFF57C00)),
                ],
              ),
              const SizedBox(height: 24),

              // Achievements
              Text('🏆 Achievements', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _achievementTile(theme, '🌱', 'First Steps', 'Complete your first scenario', game.totalDecisionsMade >= 1),
              _achievementTile(theme, '💰', 'Smart Saver', 'Save ₹10,000 in wallet', wallet.balance >= 10000),
              _achievementTile(theme, '🛡️', 'Fraud Fighter', 'Achieve 80+ safety score', game.safetyScore >= 80),
              _achievementTile(theme, '🎯', 'Budget Master', 'Complete budget allocation', false), // TODO: track
              _achievementTile(theme, '🏦', 'Emergency Ready', 'Build ₹50,000 emergency fund', wallet.emergencyFund >= 50000),
              _achievementTile(theme, '📚', 'Knowledge Seeker', 'Read all micro-learning facts', false),
              _achievementTile(theme, '🏆', 'Financial Champion', 'Complete all modules', game.currentScenarioIndex >= game.totalScenarios && game.totalScenarios > 0),
              const SizedBox(height: 24),

              // Settings
              Text('Settings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _settingsTile(context, icon: Icons.language, title: 'Language', subtitle: auth.language == 'hi' ? 'हिन्दी' : 'English',
                onTap: () => _showLanguageDialog(context, auth)),
              _settingsTile(context, icon: Icons.refresh, title: 'Reset Progress', subtitle: 'Start fresh',
                onTap: () => _showResetDialog(context, game, wallet)),
              _settingsTile(context, icon: Icons.logout, title: 'Logout', subtitle: 'Sign out of your account', isDestructive: true,
                onTap: () => _handleLogout(context, auth)),
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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 6), Text(title, style: TextStyle(fontSize: 12, color: color))]),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _achievementTile(ThemeData theme, String emoji, String title, String desc, bool earned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? const Color(0xFFFFF8E1) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: earned ? Border.all(color: const Color(0xFFF9A825).withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24, color: earned ? null : Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: earned ? null : Colors.grey)),
                Text(desc, style: TextStyle(fontSize: 12, color: earned ? theme.colorScheme.onSurfaceVariant : Colors.grey.shade400)),
              ],
            ),
          ),
          Icon(earned ? Icons.check_circle : Icons.lock_outline, color: earned ? const Color(0xFFF9A825) : Colors.grey.shade300, size: 22),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, VoidCallback? onTap, bool isDestructive = false}) {
    final theme = Theme.of(context);
    final color = isDestructive ? const Color(0xFFD32F2F) : theme.colorScheme.onSurface;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) { case 'Farmer': return const Color(0xFF4CAF50); case 'Woman': return const Color(0xFFE91E63); case 'Student': return const Color(0xFF2196F3); case 'Young Adult': return const Color(0xFFFF9800); default: return const Color(0xFF757575); }
  }

  void _showLanguageDialog(BuildContext context, AuthProvider auth) {
    showDialog(context: context, builder: (ctx) => SimpleDialog(
      title: const Text('Select Language'),
      children: AppConstants.supportedLanguages.entries.map((e) => SimpleDialogOption(
        onPressed: () { auth.setLanguage(e.key); Navigator.pop(ctx); },
        child: Row(children: [
          if (auth.language == e.key) const Icon(Icons.check, color: Color(0xFF43A047), size: 18),
          if (auth.language == e.key) const SizedBox(width: 8),
          Text(e.value, style: const TextStyle(fontSize: 16)),
        ]),
      )).toList(),
    ));
  }

  void _showResetDialog(BuildContext context, GameProvider game, WalletProvider wallet) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Reset Progress'),
      content: const Text('This will reset ALL your progress, wallet, and achievements. This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { game.resetGame(); wallet.reset(); Navigator.pop(ctx); },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
          child: const Text('Reset Everything'),
        ),
      ],
    ));
  }

  void _handleLogout(BuildContext context, AuthProvider auth) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            auth.logout();
            Navigator.pop(ctx);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
          child: const Text('Logout'),
        ),
      ],
    ));
  }
}
