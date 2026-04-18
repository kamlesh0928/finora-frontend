/// Smart Budgeting Home Screen — hub for budget allocation and scenarios.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/budget_scenarios_data.dart';
import 'budget_allocation_screen.dart';
import 'budget_scenario_screen.dart';

class BudgetingHomeScreen extends StatelessWidget {
  const BudgetingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final wallet = context.watch<WalletProvider>();
    final role = auth.userRole ?? 'Student';
    final budgetAmount = budgetCategoriesByRole.containsKey(role) ? budgetCategoriesByRole[role]!.fold<double>(0, (s, c) => s + c.recommended) : 15000.0;
    final scenarios = budgetScenariosByRole[role] ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF1565C0).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.receipt_long, color: Color(0xFF1565C0), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Smart Budgeting', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Learn to allocate money wisely through interactive challenges.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 24),

              // Budget Challenge Card
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetAllocationScreen(role: role))),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFF1565C0).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('💰 Budget Challenge', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Allocate ${Formatters.currency(budgetAmount)} wisely this month!', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Text('Start Challenge →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.pie_chart, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 50-30-20 Rule Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📐 The 50-30-20 Rule', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1))),
                    const SizedBox(height: 8),
                    _ruleRow('50%', 'Needs', 'Rent, food, bills', const Color(0xFF1565C0)),
                    _ruleRow('30%', 'Wants', 'Entertainment, dining', const Color(0xFF42A5F5)),
                    _ruleRow('20%', 'Savings', 'Emergency, investments', const Color(0xFF0D47A1)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Real-Life Scenarios
              Text('Real-Life Scenarios', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Make decisions that affect your wallet', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              ...scenarios.map((scenario) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildScenarioCard(context, scenario, wallet),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ruleRow(String pct, String label, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(width: 40, alignment: Alignment.center,
            child: Text(pct, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13))),
          const SizedBox(width: 8),
          Text('$label — ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF546E7A))),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, BudgetScenario scenario, WalletProvider wallet) {
    final theme = Theme.of(context);
    IconData icon;
    Color color;
    switch (scenario.type) {
      case 'salary_increase': icon = Icons.trending_up; color = const Color(0xFF43A047); break;
      case 'medical_bill': icon = Icons.local_hospital; color = const Color(0xFFD32F2F); break;
      case 'festival': icon = Icons.celebration; color = const Color(0xFFF9A825); break;
      case 'job_loss': icon = Icons.warning_amber_rounded; color = const Color(0xFFF57C00); break;
      default: icon = Icons.help_outline; color = Colors.grey;
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => BudgetScenarioScreen(scenario: scenario),
      )),
      child: Container(
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
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scenario.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(scenario.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
