/// Budget Allocation Screen — interactive slider challenge.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/wallet_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/budget_scenarios_data.dart';

class BudgetAllocationScreen extends StatefulWidget {
  final String role;
  const BudgetAllocationScreen({super.key, required this.role});

  @override
  State<BudgetAllocationScreen> createState() => _BudgetAllocationScreenState();
}

class _BudgetAllocationScreenState extends State<BudgetAllocationScreen> {
  late List<BudgetCategory> _categories;
  late List<double> _allocations;
  late double _totalBudget;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _categories = budgetCategoriesByRole[widget.role] ?? budgetCategoriesByRole['Student']!;
    _allocations = _categories.map((c) => c.recommended).toList();
    _totalBudget = _allocations.fold(0.0, (s, v) => s + v);
  }

  double get _totalAllocated => _allocations.fold(0.0, (s, v) => s + v);
  double get _remaining => _totalBudget - _totalAllocated;

  int _calculateScore() {
    double needsTotal = 0, wantsTotal = 0, savingsTotal = 0;
    for (int i = 0; i < _categories.length; i++) {
      final name = _categories[i].name.toLowerCase();
      if (name.contains('saving') || name.contains('emergency') || name.contains('investment')) {
        savingsTotal += _allocations[i];
      } else if (name.contains('entertainment') || name.contains('dining') || name.contains('snack')) {
        wantsTotal += _allocations[i];
      } else {
        needsTotal += _allocations[i];
      }
    }
    final total = needsTotal + wantsTotal + savingsTotal;
    if (total == 0) return 0;

    final needsPct = needsTotal / total;
    final wantsPct = wantsTotal / total;
    final savingsPct = savingsTotal / total;

    int score = 50;
    // 50-30-20 rule scoring
    if (savingsPct >= 0.20) score += 20;
    else if (savingsPct >= 0.10) score += 10;
    if (needsPct <= 0.55) score += 15;
    else if (needsPct <= 0.65) score += 5;
    if (wantsPct <= 0.30) score += 15;
    else if (wantsPct <= 0.40) score += 5;

    return score.clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = _calculateScore();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text('Budget ${Formatters.currency(_totalBudget)}')),
      body: SafeArea(
        child: Column(
          children: [
            // Budget remaining indicator
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _remaining >= 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remaining', style: theme.textTheme.labelMedium),
                      Text(Formatters.currency(_remaining),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _remaining >= 0 ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                        )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Budget Score', style: theme.textTheme.labelMedium),
                      Text('$score/100', style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
                    ],
                  ),
                ],
              ),
            ),
            // Category sliders
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${cat.icon} ${cat.name}', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            Text(Formatters.currency(_allocations[i]), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
                          ],
                        ),
                        Slider(
                          value: _allocations[i],
                          min: cat.min, max: cat.max,
                          divisions: ((cat.max - cat.min) / 500).round().clamp(1, 100),
                          activeColor: const Color(0xFF1565C0),
                          onChanged: _submitted ? null : (val) {
                            setState(() => _allocations[i] = (val / 500).roundToDouble() * 500);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Formatters.currency(cat.min), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            Text('Recommended: ${Formatters.currency(cat.recommended)}', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF1565C0))),
                            Text(Formatters.currency(cat.max), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Submit button
            if (!_submitted)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _remaining < 0 ? null : () => _submitBudget(context, score),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
                    child: const Text('Submit Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            if (_submitted)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: score >= 70 ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Icon(score >= 70 ? Icons.check_circle : Icons.info_outline,
                        color: score >= 70 ? const Color(0xFF2E7D32) : const Color(0xFFF57C00), size: 36),
                      const SizedBox(height: 8),
                      Text(score >= 70 ? 'Excellent Budget! 🎉' : 'Room for improvement', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(score >= 70 ? 'You followed the 50-30-20 rule well!' : 'Try allocating more to savings (aim for 20%)',
                        style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Budgeting')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitBudget(BuildContext context, int score) {
    setState(() => _submitted = true);
    final wallet = context.read<WalletProvider>();
    if (score >= 80) {
      wallet.credit(amount: 2000, category: 'reward', description: 'Budget Challenge: Excellent score ($score/100)', sourceModule: 'smart_budgeting');
    } else if (score >= 60) {
      wallet.credit(amount: 1000, category: 'reward', description: 'Budget Challenge: Good score ($score/100)', sourceModule: 'smart_budgeting');
    } else {
      wallet.debit(amount: 500, category: 'budgeting', description: 'Budget Challenge: Poor score ($score/100)', sourceModule: 'smart_budgeting');
    }
  }
}
