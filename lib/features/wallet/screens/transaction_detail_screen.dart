import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt, size: 80, color: Color(0xFF2E7D52)),
            const SizedBox(height: 20),
            Text('Coming Soon!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            const Text('View full breakdown of your past financial decisions.'),
          ],
        ),
      ),
    );
  }
}
