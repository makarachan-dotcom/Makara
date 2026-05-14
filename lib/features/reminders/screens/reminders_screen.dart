import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../models/reminder.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<Reminder> _reminders = [
    Reminder(
      id: const Uuid().v4(),
      title: 'ផឹកទឹក',
      time: DateTime(2024, 1, 1, 8, 0),
      isDaily: true,
    ),
    Reminder(
      id: const Uuid().v4(),
      title: 'រៀនសូត្រ',
      time: DateTime(2024, 1, 1, 15, 0),
      isDaily: true,
    ),
    Reminder(
      id: const Uuid().v4(),
      title: 'ហាត់ប្រាណ',
      time: DateTime(2024, 1, 1, 17, 30),
      isDaily: false,
    ),
  ];

  void _toggleReminder(int index) {
    setState(() {
      _reminders[index] = _reminders[index].copyWith(
        isEnabled: !_reminders[index].isEnabled,
      );
    });
  }

  void _addReminder() async {
    final titleController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    bool isDaily = false;

    final result = await showModalBottomSheet<Reminder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final theme = Theme.of(context);
            return Container(
              margin: const EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.fromLTRB(
                  24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(AppStrings.reminderAdd,
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 24),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'ចំណងជើង',
                    ),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setSheetState(() => selectedTime = time);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.studyTime,
                              style: theme.textTheme.bodyMedium),
                          Text(
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.reminderDaily,
                            style: theme.textTheme.bodyMedium),
                        Switch(
                          value: isDaily,
                          onChanged: (v) =>
                              setSheetState(() => isDaily = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) return;
                        Navigator.pop(
                          context,
                          Reminder(
                            id: const Uuid().v4(),
                            title: titleController.text,
                            time: DateTime(
                              2024,
                              1,
                              1,
                              selectedTime.hour,
                              selectedTime.minute,
                            ),
                            isDaily: isDaily,
                          ),
                        );
                      },
                      child: Text(AppStrings.save),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => _reminders.add(result));
    }
  }

  void _deleteReminder(int index) {
    setState(() => _reminders.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.reminderTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _addReminder,
          ),
        ],
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Text(
                AppStrings.noData,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                final timeStr =
                    '${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')}';

                return Dismissible(
                  key: Key(reminder.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteReminder(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.08),
                          ),
                          child: Icon(
                            reminder.isDaily
                                ? Icons.repeat_rounded
                                : Icons.notifications_none_rounded,
                            size: 20,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reminder.title,
                                  style: theme.textTheme.titleMedium),
                              const SizedBox(height: 2),
                              Text(
                                '$timeStr ${reminder.isDaily ? '• ${AppStrings.reminderDaily}' : ''}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: reminder.isEnabled,
                          onChanged: (_) => _toggleReminder(index),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: (index * 80).ms).fadeIn().slideX(begin: 0.05);
              },
            ),
    );
  }
}
