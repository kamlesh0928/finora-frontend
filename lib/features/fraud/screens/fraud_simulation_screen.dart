/// Fraud Simulation Screen — realistic scam interface with timer.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/game_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../../../core/utils/formatters.dart';
import '../data/fraud_simulations_data.dart';

class FraudSimulationScreen extends StatefulWidget {
  final FraudSimulation simulation;
  const FraudSimulationScreen({super.key, required this.simulation});

  @override
  State<FraudSimulationScreen> createState() => _FraudSimulationScreenState();
}

class _FraudSimulationScreenState extends State<FraudSimulationScreen> {
  bool? _userSaidScam;
  bool _decided = false;
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.simulation.timeLimitSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_decided) { t.cancel(); return; }
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _makeDecision(null); // Time's up — user didn't decide
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _makeDecision(bool? saidScam) {
    if (_decided) return;
    setState(() { _userSaidScam = saidScam; _decided = true; });
    _timer?.cancel();

    final sim = widget.simulation;
    final game = context.read<GameProvider>();
    final wallet = context.read<WalletProvider>();

    bool correct;
    if (saidScam == null) {
      // Time's up
      correct = false;
    } else {
      correct = (saidScam == sim.isScam);
    }

    if (correct) {
      game.updateSafetyScore(sim.safetyScoreImpact.abs());
    } else {
      game.updateSafetyScore(-sim.safetyScoreImpact.abs());
      if (sim.isScam && sim.walletImpactIfFooled < 0) {
        wallet.debit(
          amount: sim.walletImpactIfFooled.abs(),
          category: 'fraud',
          description: 'SCAM: ${sim.title} — You got fooled!',
          sourceModule: 'fraud_prevention',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sim = widget.simulation;
    final isCorrect = _decided ? (_userSaidScam == sim.isScam) : null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Fraud Simulation'),
        actions: [
          if (!_decided)
            Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _timeLeft <= 10 ? const Color(0xFFFFCDD2) : const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, size: 16, color: _timeLeft <= 10 ? const Color(0xFFD32F2F) : const Color(0xFF1565C0)),
                  const SizedBox(width: 4),
                  Text('${_timeLeft}s', style: TextStyle(fontWeight: FontWeight.bold, color: _timeLeft <= 10 ? const Color(0xFFD32F2F) : const Color(0xFF1565C0))),
                ],
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Message type indicator
              Row(
                children: [
                  Icon(_typeIcon(sim.type), size: 18, color: _typeColor(sim.type)),
                  const SizedBox(width: 6),
                  Text(sim.type.toUpperCase(), style: theme.textTheme.labelMedium?.copyWith(color: _typeColor(sim.type), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),

              // Simulated message card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _messageBgColor(sim.type),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 16, backgroundColor: _typeColor(sim.type).withValues(alpha: 0.2),
                          child: Icon(_typeIcon(sim.type), size: 16, color: _typeColor(sim.type))),
                        const SizedBox(width: 10),
                        Text(sim.senderName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(sim.messageContent, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Decision buttons
              if (!_decided) ...[
                Text('Is this a SCAM or LEGITIMATE?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _makeDecision(true),
                          icon: const Icon(Icons.dangerous, size: 22),
                          label: const Text('SCAM 🚫', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _makeDecision(false),
                          icon: const Icon(Icons.check_circle, size: 22),
                          label: const Text('SAFE ✅', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF43A047), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Result
              if (_decided) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCorrect == true ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isCorrect == true ? const Color(0xFF43A047) : const Color(0xFFD32F2F)),
                  ),
                  child: Column(
                    children: [
                      Icon(isCorrect == true ? Icons.check_circle : Icons.cancel,
                        size: 48, color: isCorrect == true ? const Color(0xFF43A047) : const Color(0xFFD32F2F)),
                      const SizedBox(height: 8),
                      Text(isCorrect == true ? 'Correct! 🎉' : (_userSaidScam == null ? 'Time\'s Up! ⏰' : 'Wrong! 😥'),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('This message was ${sim.isScam ? "a SCAM" : "LEGITIMATE"}',
                        style: theme.textTheme.titleSmall?.copyWith(color: sim.isScam ? const Color(0xFFD32F2F) : const Color(0xFF43A047))),
                      const SizedBox(height: 12),
                      Text(sim.explanation, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4), textAlign: TextAlign.center),
                      if (isCorrect != true && sim.walletImpactIfFooled < 0) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFFFCDD2), borderRadius: BorderRadius.circular(8)),
                          child: Text('💸 Lost ${Formatters.currency(sim.walletImpactIfFooled.abs())} from wallet!',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC62828))),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, size: 18, color: Color(0xFF1565C0)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(sim.safetyTip, style: const TextStyle(fontSize: 13, color: Color(0xFF0D47A1), height: 1.3))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Continue')),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) { case 'sms': return Icons.sms; case 'whatsapp': return Icons.chat; case 'phone_call': return Icons.phone; case 'email': return Icons.email; default: return Icons.warning; }
  }
  Color _typeColor(String type) {
    switch (type) { case 'sms': return const Color(0xFF1565C0); case 'whatsapp': return const Color(0xFF43A047); case 'phone_call': return const Color(0xFFF57C00); case 'email': return const Color(0xFF7B1FA2); default: return const Color(0xFFD32F2F); }
  }
  Color _messageBgColor(String type) {
    switch (type) { case 'whatsapp': return const Color(0xFFE8F5E9); case 'sms': return const Color(0xFFF5F5F5); case 'email': return const Color(0xFFF3E5F5); default: return const Color(0xFFFFF3E0); }
  }
}
