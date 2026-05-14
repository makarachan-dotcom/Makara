import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';

class AlarmData {
  final String id;
  final int hour;
  final int minute;
  final String label;
  final bool isEnabled;
  final List<int> repeatDays;

  AlarmData({
    required this.id,
    required this.hour,
    required this.minute,
    this.label = '',
    this.isEnabled = true,
    this.repeatDays = const [],
  });

  String get timeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  AlarmData copyWith({
    int? hour,
    int? minute,
    String? label,
    bool? isEnabled,
    List<int>? repeatDays,
  }) {
    return AlarmData(
      id: id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }
}

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<AlarmData> _alarms = [
    AlarmData(id: '1', hour: 6, minute: 30, label: 'ពេលព្រឹក', repeatDays: [1, 2, 3, 4, 5]),
    AlarmData(id: '2', hour: 7, minute: 0, label: 'សាលារៀន'),
  ];

  void _addAlarm() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _alarms.add(AlarmData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          hour: time.hour,
          minute: time.minute,
        ));
      });
    }
  }

  void _toggleAlarm(int index) {
    setState(() {
      _alarms[index] = _alarms[index].copyWith(
        isEnabled: !_alarms[index].isEnabled,
      );
    });
  }

  void _deleteAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.alarmTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _addAlarm,
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.alarm_off_rounded,
                      size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'គ្មានរោទ៍',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return Dismissible(
                  key: Key(alarm.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteAlarm(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  child: _AlarmCard(
                    alarm: alarm,
                    onToggle: () => _toggleAlarm(index),
                  ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.1),
                );
              },
            ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final AlarmData alarm;
  final VoidCallback onToggle;

  const _AlarmCard({required this.alarm, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opacity = alarm.isEnabled ? 1.0 : 0.4;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.timeString,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: theme.colorScheme.onSurface.withValues(alpha: opacity),
                  ),
                ),
                if (alarm.label.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    alarm.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: opacity * 0.6),
                    ),
                  ),
                ],
                if (alarm.repeatDays.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(7, (i) {
                      final isActive = alarm.repeatDays.contains(i + 1);
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.15 * opacity)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            AppStrings.daysOfWeek[i][0],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: isActive ? opacity : 0.2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: alarm.isEnabled,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}
