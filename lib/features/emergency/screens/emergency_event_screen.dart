import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/wallet_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/emergency_events_data.dart';

class EmergencyEventScreen extends StatefulWidget {
  final EmergencyEvent event;
  const EmergencyEventScreen({super.key, required this.event});

  @override
  State<EmergencyEventScreen> createState() => _EmergencyEventScreenState();
}

class _EmergencyEventScreenState extends State<EmergencyEventScreen> {
  EmergencyChoice? _selectedChoice;
  bool _decided = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Emergency Event')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fund + Wallet status
              Row(
                children: [
                  Expanded(
                    child: _statusChip(
                      '💰 Wallet',
                      Formatters.currency(wallet.balance),
                      const Color(0xFF2E7D52),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statusChip(
                      '🛡️ Fund',
                      Formatters.currency(wallet.emergencyFund),
                      const Color(0xFFF57C00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Event header
              Center(
                child: Text(
                  widget.event.icon,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.event.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Cost: ${Formatters.currency(widget.event.costAmount)}',
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.event.description,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'What will you do?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Choices
              ...widget.event.choices.map(
                (choice) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: _decided ? null : () => _makeChoice(context, choice),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _decided && _selectedChoice == choice
                            ? (choice.isRecommended
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFF3E0))
                            : theme.colorScheme.surface,
                        border: Border.all(
                          color: _decided && _selectedChoice == choice
                              ? (choice.isRecommended
                                    ? const Color(0xFF43A047)
                                    : const Color(0xFFF57C00))
                              : theme.colorScheme.outlineVariant,
                          width: _decided && _selectedChoice == choice ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  choice.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (choice.isRecommended && _decided)
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFF43A047),
                                  size: 18,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            choice.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Micro learning after decision
              if (_decided) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Color(0xFF3F51B5),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.event.microLearning,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color: Color(0xFF283593),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF57C00),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _makeChoice(BuildContext context, EmergencyChoice choice) {
    setState(() {
      _selectedChoice = choice;
      _decided = true;
    });

    final wallet = context.read<WalletProvider>();
    final game = context.read<GameProvider>();

    if (choice.emergencyFundImpact < 0) {
      wallet.useEmergencyFund(choice.emergencyFundImpact.abs());
    }
    if (choice.walletImpact < 0) {
      wallet.debit(
        amount: choice.walletImpact.abs(),
        category: 'emergency',
        description: '${widget.event.title}: ${choice.title}',
        sourceModule: 'emergency_fund',
      );
    }
    game.updateStressLevel(choice.stressImpact);
  }
}
