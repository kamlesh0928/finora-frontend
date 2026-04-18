/// Fraud Micro Challenge Screen — quiz-style scam identification.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/game_provider.dart';
import '../../../core/providers/wallet_provider.dart';
import '../data/fraud_simulations_data.dart';

class FraudMicroChallengeScreen extends StatefulWidget {
  const FraudMicroChallengeScreen({super.key});

  @override
  State<FraudMicroChallengeScreen> createState() => _FraudMicroChallengeScreenState();
}

class _FraudMicroChallengeScreenState extends State<FraudMicroChallengeScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int _correctCount = 0;
  String? _selectedId;
  bool _answered = false;

  MicroChallenge get _current => microChallenges[_currentIndex];
  bool get _isLast => _currentIndex >= microChallenges.length - 1;

  void _selectAnswer(String id) {
    if (_answered) return;
    setState(() { _selectedId = id; _answered = true; });

    if (id == _current.correctAnswerId) {
      _score += _current.points;
      _correctCount++;
    }
  }

  void _next() {
    if (_isLast) {
      _showResults();
      return;
    }
    setState(() { _currentIndex++; _selectedId = null; _answered = false; });
  }

  void _showResults() {
    final game = context.read<GameProvider>();
    final wallet = context.read<WalletProvider>();

    game.updateSafetyScore((_correctCount * 3) - ((microChallenges.length - _correctCount) * 2));

    if (_correctCount >= microChallenges.length * 0.8) {
      wallet.credit(amount: 500, category: 'reward', description: 'Micro Challenge: $_correctCount/${microChallenges.length} correct!', sourceModule: 'fraud_prevention');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_correctCount >= microChallenges.length * 0.7 ? Icons.emoji_events : Icons.info_outline,
              size: 56, color: _correctCount >= microChallenges.length * 0.7 ? const Color(0xFFF9A825) : const Color(0xFFF57C00)),
            const SizedBox(height: 12),
            Text('Challenge Complete!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Score: $_score points', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color(0xFF1565C0))),
            Text('$_correctCount/${microChallenges.length} correct', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            if (_correctCount >= microChallenges.length * 0.8)
              const Text('🎉 Bonus ₹500 earned!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF43A047))),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); Navigator.pop(context); },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final challenge = _current;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Challenge ${_currentIndex + 1}/${microChallenges.length}'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(10)),
            child: Text('$_score pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / microChallenges.length,
                  backgroundColor: const Color(0xFFFFCDD2),
                  color: const Color(0xFFD32F2F),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 24),
              Text(challenge.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(challenge.question, style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
              const SizedBox(height: 24),
              // Options
              ...challenge.options.map((opt) {
                final isSelected = _selectedId == opt.id;
                final isCorrect = opt.id == challenge.correctAnswerId;
                Color? cardColor;
                Color? borderColor;
                if (_answered) {
                  if (isCorrect) { cardColor = const Color(0xFFE8F5E9); borderColor = const Color(0xFF43A047); }
                  else if (isSelected) { cardColor = const Color(0xFFFFEBEE); borderColor = const Color(0xFFD32F2F); }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(opt.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor ?? theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor ?? theme.colorScheme.outlineVariant, width: _answered && (isCorrect || isSelected) ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: _answered ? (isCorrect ? const Color(0xFF43A047) : (isSelected ? const Color(0xFFD32F2F) : Colors.grey.shade300)) : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(opt.id.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _answered ? Colors.white : Colors.grey.shade600))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(opt.text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.3))),
                          if (_answered && isCorrect) const Icon(Icons.check_circle, color: Color(0xFF43A047), size: 20),
                          if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Color(0xFFD32F2F), size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // Explanation
              if (_answered) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, size: 18, color: Color(0xFF1565C0)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(challenge.explanation, style: const TextStyle(fontSize: 13, color: Color(0xFF0D47A1), height: 1.3))),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              if (_answered)
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
                    child: Text(_isLast ? 'See Results' : 'Next Challenge', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
