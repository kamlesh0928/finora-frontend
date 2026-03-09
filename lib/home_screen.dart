import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Finora',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // Placeholder for Sync Status Indicator
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            onPressed: () {
              // TODO: Trigger manual sync or show offline status
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatCard(
              context,
              title: 'Current Savings',
              value: '₹ 12,500',
              icon: Icons.savings,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              title: 'Financial Stress Level',
              value: 'Low',
              icon: Icons.health_and_safety,
              color: Colors.blue,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to the Game Engine / Next Scenario
              },
              icon: const Icon(Icons.play_arrow),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Start Next Scenario',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // A reusable widget for displaying gamified stats
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 30,
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
