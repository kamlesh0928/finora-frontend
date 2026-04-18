/// Redesigned Dashboard — central hub showing wallet, health score, and module entry points.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../game/screens/scenario_screen.dart';
import '../../wallet/screens/wallet_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final auth = context.watch<AuthProvider>();
    final wallet = context.watch<WalletProvider>();
    final connectivity = context.watch<ConnectivityProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${auth.userName ?? "Player"} 👋',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getRoleColor(auth.userRole).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                auth.userRole ?? 'Select Role',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getRoleColor(auth.userRole),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!connectivity.isOnline)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.cloud_off, size: 12, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text('Offline', style: theme.textTheme.labelSmall?.copyWith(color: Colors.orange)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Health Score Circle
                  GestureDetector(
                    onTap: () => _showHealthScoreInfo(context, game),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 52, height: 52,
                          child: CircularProgressIndicator(
                            value: game.financialHealthScore / 100,
                            strokeWidth: 4,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            color: _healthColor(game.financialHealthScore),
                          ),
                        ),
                        Text(
                          '${game.financialHealthScore}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _healthColor(game.financialHealthScore),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Wallet Card
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [theme.colorScheme.primary, const Color(0xFF1B5E3B)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wallet Balance', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Formatters.currency(wallet.balance),
                        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _miniStat('↑ Earned', Formatters.shortCurrency(wallet.totalEarned), const Color(0xFF81C784)),
                          const SizedBox(width: 16),
                          _miniStat('↓ Spent', Formatters.shortCurrency(wallet.totalSpent), const Color(0xFFEF9A9A)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.speed, size: 14, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text('Stress ${(game.stressLevel * 100).toInt()}%',
                                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Three Module Cards
              Text('Learning Modules', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // These cards are just informational since bottom nav handles navigation
              _buildModuleCard(context, 'Smart Budgeting', 'Learn to allocate money wisely', Icons.receipt_long, const Color(0xFF1565C0), game.currentScenarioIndex, game.totalScenarios),
              const SizedBox(height: 10),
              _buildModuleCard(context, 'Fraud Prevention', 'Protect yourself from scams', Icons.shield, const Color(0xFFD32F2F), game.safetyScore, 100),
              const SizedBox(height: 10),
              _buildModuleCard(context, 'Emergency Fund', 'Build your safety net', Icons.savings, const Color(0xFFF57C00), (wallet.emergencyFundProgress * 100).toInt(), 100),
              const SizedBox(height: 20),

              // Daily Scenario Challenge
              if (game.hasMoreScenarios) ...[
                Text('Daily Challenge', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScenarioScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: theme.colorScheme.tertiary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.play_arrow_rounded, color: theme.colorScheme.tertiary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(game.currentScenario?.title ?? 'Next Scenario', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Tap to start your next financial challenge', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Quick Tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Color(0xFF7B1FA2), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tip: Follow the 50-30-20 rule — 50% needs, 30% wants, 20% savings.',
                        style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF4A148C), height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, String subtitle, IconData icon, Color color, int progress, int total) {
    final theme = Theme.of(context);
    final pct = total > 0 ? (progress / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: pct, backgroundColor: color.withValues(alpha: 0.1), color: color, minHeight: 4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('${(pct * 100).toInt()}%', style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'Farmer': return const Color(0xFF4CAF50);
      case 'Woman': return const Color(0xFFE91E63);
      case 'Student': return const Color(0xFF2196F3);
      case 'Young Adult': return const Color(0xFFFF9800);
      default: return const Color(0xFF757575);
    }
  }

  Color _healthColor(int score) {
    if (score >= 70) return const Color(0xFF43A047);
    if (score >= 40) return const Color(0xFFF57C00);
    return const Color(0xFFD32F2F);
  }

  void _showHealthScoreInfo(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Financial Health Score'),
        content: Text('Your score: ${game.financialHealthScore}/100\n\nBased on:\n• Wallet balance\n• Emergency fund\n• Stress level\n• Safety score\n\nMake good financial decisions to improve!'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it'))],
      ),
    );
  }
}
