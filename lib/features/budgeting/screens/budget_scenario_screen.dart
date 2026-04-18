/// Budget Scenario Decision Screen — real-life financial scenario.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/wallet_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/budget_scenarios_data.dart';

class BudgetScenarioScreen extends StatefulWidget {
  final BudgetScenario scenario;
  const BudgetScenarioScreen({super.key, required this.scenario});

  @override
  State<BudgetScenarioScreen> createState() => _BudgetScenarioScreenState();
}

class _BudgetScenarioScreenState extends State<BudgetScenarioScreen> {
  BudgetDecision? _selectedDecision;
  bool _decided = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Budget Decision')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Wallet mini bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text('Wallet: ${Formatters.currency(wallet.balance)}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Scenario title & description
              Text(widget.scenario.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(14)),
                child: Text(widget.scenario.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
              ),
              const SizedBox(height: 24),
              Text('What will you do?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // Decision options
              ...widget.scenario.decisions.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: _decided ? null : () => _makeDecision(context, d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _decided && _selectedDecision == d
                          ? (d.isRecommended ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0))
                          : theme.colorScheme.surface,
                      border: Border.all(
                        color: _decided && _selectedDecision == d
                            ? (d.isRecommended ? const Color(0xFF43A047) : const Color(0xFFF57C00))
                            : theme.colorScheme.outlineVariant,
                        width: _decided && _selectedDecision == d ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(d.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
                            if (d.isRecommended && _decided)
                              const Icon(Icons.star, color: Color(0xFF43A047), size: 18),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(d.subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (d.walletImpact != 0)
                              _impactChip(d.walletImpact > 0 ? '+${Formatters.currency(d.walletImpact)}' : Formatters.currency(d.walletImpact),
                                d.walletImpact > 0 ? const Color(0xFF43A047) : const Color(0xFFD32F2F)),
                            if (d.stressImpact != 0)
                              _impactChip(d.stressImpact > 0 ? '+${(d.stressImpact * 100).toInt()}% stress' : '${(d.stressImpact * 100).toInt()}% stress',
                                d.stressImpact > 0 ? const Color(0xFFF57C00) : const Color(0xFF43A047)),
                          ],
                        ),
                        if (_decided && _selectedDecision == d) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: d.isRecommended ? const Color(0xFFC8E6C9) : const Color(0xFFFFE0B2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(d.isRecommended ? Icons.check_circle : Icons.info_outline,
                                  size: 16, color: d.isRecommended ? const Color(0xFF2E7D32) : const Color(0xFFF57C00)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(
                                  d.isRecommended ? d.feedbackGood : (d.feedbackBad.isNotEmpty ? d.feedbackBad : d.feedbackGood),
                                  style: const TextStyle(fontSize: 12, height: 1.3),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )),
              if (_decided)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _impactChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _makeDecision(BuildContext context, BudgetDecision decision) {
    setState(() { _selectedDecision = decision; _decided = true; });

    final wallet = context.read<WalletProvider>();
    final game = context.read<GameProvider>();

    if (decision.walletImpact > 0) {
      wallet.credit(amount: decision.walletImpact, category: 'budgeting', description: '${widget.scenario.title}: ${decision.title}', sourceModule: 'smart_budgeting');
    } else if (decision.walletImpact < 0) {
      wallet.debit(amount: decision.walletImpact.abs(), category: 'budgeting', description: '${widget.scenario.title}: ${decision.title}', sourceModule: 'smart_budgeting');
    }
    game.updateStressLevel(decision.stressImpact);
  }
}
