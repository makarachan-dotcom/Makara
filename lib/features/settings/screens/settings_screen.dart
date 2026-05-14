import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/biometric_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BiometricService _biometric = BiometricService();
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    _biometricAvailable = await _biometric.isAvailable;
    _biometricEnabled = await _biometric.isEnabled;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
          _SectionHeader(title: AppStrings.settingsAppearance),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _ThemeOption(
                  title: AppStrings.settingsSystem,
                  icon: Icons.brightness_auto_rounded,
                  isSelected: themeProvider.themeMode == AppThemeMode.system,
                  onTap: () =>
                      themeProvider.setThemeMode(AppThemeMode.system),
                ),
                Divider(
                    height: 1,
                    indent: 56,
                    color: theme.dividerTheme.color),
                _ThemeOption(
                  title: AppStrings.settingsDark,
                  icon: Icons.dark_mode_rounded,
                  isSelected: themeProvider.themeMode == AppThemeMode.dark,
                  onTap: () =>
                      themeProvider.setThemeMode(AppThemeMode.dark),
                ),
                Divider(
                    height: 1,
                    indent: 56,
                    color: theme.dividerTheme.color),
                _ThemeOption(
                  title: AppStrings.settingsLight,
                  icon: Icons.light_mode_rounded,
                  isSelected: themeProvider.themeMode == AppThemeMode.light,
                  onTap: () =>
                      themeProvider.setThemeMode(AppThemeMode.light),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Security
          _SectionHeader(title: AppStrings.settingsBiometric),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.face_rounded,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    const SizedBox(width: 16),
                    Text(AppStrings.settingsBiometric,
                        style: theme.textTheme.bodyLarge),
                  ],
                ),
                Switch(
                  value: _biometricEnabled,
                  onChanged: _biometricAvailable
                      ? (value) async {
                          await _biometric.setEnabled(value);
                          setState(() => _biometricEnabled = value);
                        }
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // About
          _SectionHeader(title: AppStrings.settingsAbout),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, size: 40),
                const SizedBox(height: 12),
                Text(AppStrings.appName,
                    style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'v1.0.0',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Made with Unreal Engine 5 by Makara',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 16),
            Expanded(
              child:
                  Text(title, style: theme.textTheme.bodyLarge),
            ),
            if (isSelected)
              Icon(Icons.check_rounded,
                  size: 20, color: theme.colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}
