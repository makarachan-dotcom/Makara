import 'package:flutter/material.dart';
import '../alarm/screens/alarm_screen.dart';
import '../timer/screens/timer_screen.dart';
import '../sleep/screens/sleep_screen.dart';
import '../study/screens/study_screen.dart';
import '../chat/screens/chat_screen.dart';
import '../reminders/screens/reminders_screen.dart';
import '../insights/screens/insights_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../../core/constants/app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AlarmScreen(),
    TimerScreen(),
    SleepScreen(),
    StudyScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerTheme.color ?? Colors.transparent,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.alarm_rounded),
              label: AppStrings.navAlarm,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_rounded),
              label: AppStrings.navTimer,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bedtime_rounded),
              label: AppStrings.navSleep,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school_rounded),
              label: AppStrings.navStudy,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_rounded),
              label: AppStrings.navChat,
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(theme),
    );
  }

  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    child: const Icon(Icons.auto_awesome, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(AppStrings.appName,
                      style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(AppStrings.appTagline,
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.notifications_none_rounded,
              title: AppStrings.reminderTitle,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RemindersScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.insights_rounded,
              title: AppStrings.insightsTitle,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const InsightsScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              title: AppStrings.settingsTitle,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'v1.0.0 • Made with UE5 by Makara',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(width: 20),
            Text(title, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
