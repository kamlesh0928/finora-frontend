import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../dashboard/screens/main_shell_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  static const List<_RoleOption> _roles = [
    _RoleOption(
      name: 'Farmer',
      icon: Icons.agriculture,
      subtitle: 'Manage irregular income and learn about crop insurance.',
      color: Color(0xFF4CAF50),
    ),
    _RoleOption(
      name: 'Woman',
      icon: Icons.family_restroom,
      subtitle: 'Handle household budgets and build digital confidence.',
      color: Color(0xFFE91E63),
    ),
    _RoleOption(
      name: 'Student',
      icon: Icons.school,
      subtitle: 'Build smart money habits and stay safe online.',
      color: Color(0xFF2196F3),
    ),
    _RoleOption(
      name: 'Young Adult',
      icon: Icons.work_outline,
      subtitle: 'Navigate credit, taxes, and avoid financial scams.',
      color: Color(0xFFFF9800),
    ),
  ];

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _confirmSelection() {
    if (_selectedRole == null) return;

    context.read<AuthProvider>().setUserRole(_selectedRole!);
    context.read<GameProvider>().loadScenariosForRole(_selectedRole!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Who are you?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your profile so we can personalize your financial scenarios.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role.name;
                    return _buildRoleCard(theme, role, isSelected);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedRole != null ? _confirmSelection : null,
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(ThemeData theme, _RoleOption role, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectRole(role.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? role.color.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? role.color : theme.colorScheme.outlineVariant,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: role.color.withValues(alpha: isSelected ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                role.icon,
                size: 36,
                color: isSelected
                    ? role.color
                    : role.color.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              role.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? role.color : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                role.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleOption {
  final String name;
  final IconData icon;
  final String subtitle;
  final Color color;

  const _RoleOption({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.color,
  });
}
