import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../data/fraud_simulations_data.dart';
import 'fraud_simulation_screen.dart';
import 'fraud_micro_challenge_screen.dart';

class FraudHomeScreen extends StatelessWidget {
  const FraudHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final game = context.watch<GameProvider>();
    final role = auth.userRole ?? 'Student';
    final simulations = fraudSimulationsByRole[role] ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: Color(0xFFD32F2F),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'fraud_prevention'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'learn_prevent_scams'.tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              // Safety Score Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'safety_score'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${game.safetyScore}/100',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: game.safetyScore / 100,
                              backgroundColor: Colors.white24,
                              color: Colors.white,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Micro Challenges
              Text(
                '⚡ ${'quick_challenges'.tr()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FraudMicroChallengeScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFD32F2F,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.quiz,
                          color: Color(0xFFD32F2F),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'spot_scam_quiz'.tr(),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${microChallenges.length} ${'challenges_points'.tr()}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFFD32F2F),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Fraud Simulations
              Text(
                '🎭 ${'fraud_simulations'.tr()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'face_realistic_scams'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              ...simulations.map(
                (sim) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildSimulationCard(context, sim),
                ),
              ),
              const SizedBox(height: 24),

              // Live Fraud Feed
              Text(
                '📢 ${'trending_alerts'.tr()}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _feedCard(
                theme,
                '🔴 UPI Fraud',
                'Fake collect requests pretending to be refunds. Never accept from unknown.',
              ),
              const SizedBox(height: 8),
              _feedCard(
                theme,
                '🟠 KYC Scam',
                'Messages claiming account block unless you update KYC via link.',
              ),
              const SizedBox(height: 8),
              _feedCard(
                theme,
                '🔴 Delivery OTP',
                'Callers pretending to be agents asking OTP for "verification".',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimulationCard(BuildContext context, FraudSimulation sim) {
    final theme = Theme.of(context);
    IconData typeIcon;
    Color typeColor;
    switch (sim.type) {
      case 'sms':
        typeIcon = Icons.sms;
        typeColor = const Color(0xFF1565C0);
        break;
      case 'whatsapp':
        typeIcon = Icons.chat;
        typeColor = const Color(0xFF43A047);
        break;
      case 'phone_call':
        typeIcon = Icons.phone;
        typeColor = const Color(0xFFF57C00);
        break;
      case 'email':
        typeIcon = Icons.email;
        typeColor = const Color(0xFF7B1FA2);
        break;
      default:
        typeIcon = Icons.warning;
        typeColor = const Color(0xFFD32F2F);
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FraudSimulationScreen(simulation: sim),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: typeColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sim.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    sim.type.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: typeColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _feedCard(ThemeData theme, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.3,
              color: const Color(0xFF795548),
            ),
          ),
        ],
      ),
    );
  }
}
