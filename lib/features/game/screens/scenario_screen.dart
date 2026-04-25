import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/data/scenario_data.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/providers/wallet_provider.dart';

class ScenarioScreen extends StatelessWidget {
  const ScenarioScreen({super.key});

  /// Maps [IconChoice] enum values to Flutter Material [IconData].
  IconData _resolveIcon(IconChoice choice) {
    switch (choice) {
      case IconChoice.savings:
        return Icons.savings;
      case IconChoice.accountBalance:
        return Icons.account_balance;
      case IconChoice.warning:
        return Icons.warning_amber_rounded;
      case IconChoice.trendingUp:
        return Icons.trending_up;
      case IconChoice.trendingDown:
        return Icons.trending_down;
      case IconChoice.shield:
        return Icons.shield_outlined;
      case IconChoice.school:
        return Icons.school;
      case IconChoice.creditCard:
        return Icons.credit_card;
      case IconChoice.phoneAndroid:
        return Icons.phone_android;
      case IconChoice.agriculture:
        return Icons.agriculture;
      case IconChoice.handshake:
        return Icons.handshake_outlined;
      case IconChoice.localHospital:
        return Icons.local_hospital;
      case IconChoice.store:
        return Icons.store;
      case IconChoice.lightbulb:
        return Icons.lightbulb_outline;
      case IconChoice.buildCircle:
        return Icons.build_circle_outlined;
      case IconChoice.moneyOff:
        return Icons.money_off;
      case IconChoice.receiptLong:
        return Icons.receipt_long;
      case IconChoice.groups:
        return Icons.groups;
      case IconChoice.workspacePremium:
        return Icons.workspace_premium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final theme = Theme.of(context);
    final scenario = gameProvider.currentScenario;

    // Edge case: no more scenarios
    if (scenario == null) {
      return Scaffold(
        appBar: AppBar(title: Text('scenario'.tr())),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'all_scenarios_completed'.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'completed_all_scenarios'.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('back_to_dashboard'.tr()),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '${'scenario'.tr()} ${gameProvider.currentScenarioIndex + 1} / ${gameProvider.totalScenarios}',
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mini stats bar
              _buildMiniStatsBar(context, gameProvider),
              const SizedBox(height: 24),

              // Theme badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _themeColor(
                    scenario.theme,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _themeIcon(scenario.theme),
                      size: 16,
                      color: _themeColor(scenario.theme, theme),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _themeLabel(scenario.theme),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _themeColor(scenario.theme, theme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scenario title
              Text(
                scenario.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Scenario description
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.primaryContainer),
                ),
                child: Text(
                  scenario.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Decisions header
              Text(
                'your_decision'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Decision buttons
              ...scenario.decisions.map(
                (decision) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDecisionButton(
                    context: context,
                    decision: decision,
                    onTap: () {
                      gameProvider.makeDecision(
                        decision,
                        context.read<WalletProvider>(),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatsBar(BuildContext context, GameProvider gameProvider) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.savings_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'INR ${gameProvider.savings.toStringAsFixed(0)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.speed,
            size: 18,
            color: gameProvider.stressLevel > 0.7
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '${'stress'.tr()}: ${(gameProvider.stressLevel * 100).toInt()}%',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: gameProvider.stressLevel > 0.7
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionButton({
    required BuildContext context,
    required Decision decision,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    // Determine impact indicator
    final isPositive =
        decision.savingsImpact >= 0 && decision.stressImpact <= 0;
    final isNegative =
        decision.savingsImpact < 0 || decision.stressImpact > 0.15;

    Color accentColor;
    if (isPositive) {
      accentColor = const Color(0xFF43A047);
    } else if (isNegative) {
      accentColor = const Color(0xFFF57C00);
    } else {
      accentColor = theme.colorScheme.secondary;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _resolveIcon(decision.icon),
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      decision.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      decision.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Impact tags
                    Wrap(
                      spacing: 8,
                      children: [
                        if (decision.savingsImpact != 0)
                          _buildImpactChip(
                            label: decision.savingsImpact > 0
                                ? '+INR ${decision.savingsImpact.toInt()}'
                                : 'INR ${decision.savingsImpact.toInt()}',
                            color: decision.savingsImpact > 0
                                ? const Color(0xFF43A047)
                                : theme.colorScheme.error,
                            theme: theme,
                          ),
                        if (decision.stressImpact != 0)
                          _buildImpactChip(
                            label: decision.stressImpact > 0
                                ? '+${(decision.stressImpact * 100).toInt()}% stress'
                                : '${(decision.stressImpact * 100).toInt()}% stress',
                            color: decision.stressImpact > 0
                                ? const Color(0xFFF57C00)
                                : const Color(0xFF43A047),
                            theme: theme,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImpactChip({
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _themeColor(String themeKey, ThemeData theme) {
    switch (themeKey) {
      case 'savings':
        return const Color(0xFF43A047);
      case 'budgeting':
        return const Color(0xFF1565C0);
      case 'risk_management':
        return const Color(0xFFF57C00);
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _themeIcon(String themeKey) {
    switch (themeKey) {
      case 'savings':
        return Icons.savings;
      case 'budgeting':
        return Icons.receipt_long;
      case 'risk_management':
        return Icons.shield_outlined;
      default:
        return Icons.category;
    }
  }

  String _themeLabel(String themeKey) {
    switch (themeKey) {
      case 'savings':
        return 'Savings';
      case 'budgeting':
        return 'Budgeting';
      case 'risk_management':
        return 'Risk Management'.tr();
      default:
        return themeKey.tr();
    }
  }
}
