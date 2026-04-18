/// Emergency Fund Home Screen — fund meter, events, and micro-learning.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/emergency_events_data.dart';
import 'emergency_event_screen.dart';

class EmergencyHomeScreen extends StatelessWidget {
  const EmergencyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = context.watch<WalletProvider>();
    final auth = context.watch<AuthProvider>();
    final role = auth.userRole ?? 'Student';
    final events = emergencyEventsByRole[role] ?? [];
    final progress = wallet.emergencyFundProgress;

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
                    decoration: BoxDecoration(color: const Color(0xFFF57C00).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.savings, color: Color(0xFFF57C00), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text('Emergency Fund', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Build a safety net for unexpected expenses.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),

              // Fund Meter
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF57C00), Color(0xFFE65100)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFFF57C00).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Emergency Fund', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                        Text('${(progress * 100).toInt()}%', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        Container(height: 20, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Formatters.currency(wallet.emergencyFund), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Target: ${Formatters.currency(AppConstants.emergencyFundTarget)}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contribute button
              SizedBox(
                width: double.infinity, height: 48,
                child: OutlinedButton.icon(
                  onPressed: wallet.balance > 0 ? () => _showContributeDialog(context, wallet) : null,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Contribute to Emergency Fund'),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFF57C00), side: const BorderSide(color: Color(0xFFF57C00))),
                ),
              ),
              const SizedBox(height: 24),

              // Real-Life Events
              Text('🚨 Emergency Events', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Can your fund handle these?', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              ...events.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyEventScreen(event: event))),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF57C00).withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      children: [
                        Text(event.icon, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              Text('Cost: ${Formatters.currency(event.costAmount)}', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFE65100))),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFF57C00)),
                      ],
                    ),
                  ),
                ),
              )),
              const SizedBox(height: 24),

              // Micro Learning
              Text('📖 Did You Know?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: emergencyMicroLearning.length,
                  itemBuilder: (context, i) {
                    final fact = emergencyMicroLearning[i];
                    return Container(
                      width: 240,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fact['icon'] ?? '💡', style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 6),
                          Expanded(child: Text(fact['fact'] ?? '', style: theme.textTheme.bodySmall?.copyWith(height: 1.3, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showContributeDialog(BuildContext context, WalletProvider wallet) {
    final controller = TextEditingController(text: '1000');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Contribute to Emergency Fund'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available: ${Formatters.currency(wallet.balance)}'),
            const SizedBox(height: 12),
            TextField(controller: controller, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(controller.text) ?? 0;
              if (amt > 0 && amt <= wallet.balance) {
                wallet.contributeToEmergencyFund(amt);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contributed ${Formatters.currency(amt)} to emergency fund!'), behavior: SnackBarBehavior.floating));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF57C00)),
            child: const Text('Contribute'),
          ),
        ],
      ),
    );
  }
}
