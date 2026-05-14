import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_strings.dart';
import '../models/study_session.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<StudySession> _todaySessions = [];
  final List<StudySession> _tomorrowSessions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSampleData();
  }

  void _loadSampleData() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    _todaySessions.addAll([
      StudySession(
        id: const Uuid().v4(),
        subject: 'គណិតវិទ្យា',
        startTime: DateTime(today.year, today.month, today.day, 8, 0),
        durationMinutes: 60,
        notes: 'ជំពូកទី ៥ - សមីការ',
        date: today,
      ),
      StudySession(
        id: const Uuid().v4(),
        subject: 'រូបវិទ្យា',
        startTime: DateTime(today.year, today.month, today.day, 10, 0),
        durationMinutes: 45,
        notes: 'ថាមពល និងកម្លាំង',
        date: today,
        isCompleted: true,
      ),
      StudySession(
        id: const Uuid().v4(),
        subject: 'អង់គ្លេស',
        startTime: DateTime(today.year, today.month, today.day, 14, 0),
        durationMinutes: 30,
        notes: 'វេយ្យាករណ៍ - Tenses',
        date: today,
      ),
    ]);

    _tomorrowSessions.addAll([
      StudySession(
        id: const Uuid().v4(),
        subject: 'ជីវវិទ្យា',
        startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8, 30),
        durationMinutes: 60,
        notes: 'កោសិកា និងជីវសាស្រ្ត',
        date: tomorrow,
      ),
      StudySession(
        id: const Uuid().v4(),
        subject: 'គីមីវិទ្យា',
        startTime:
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 30),
        durationMinutes: 45,
        date: tomorrow,
      ),
      StudySession(
        id: const Uuid().v4(),
        subject: 'ប្រវត្តិវិទ្យា',
        startTime:
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14, 0),
        durationMinutes: 60,
        notes: 'អង្គរវត្ត',
        date: tomorrow,
      ),
    ]);
  }

  void _toggleComplete(bool isTomorrow, int index) {
    setState(() {
      final list = isTomorrow ? _tomorrowSessions : _todaySessions;
      list[index] = list[index].copyWith(isCompleted: !list[index].isCompleted);
    });
  }

  void _addSession(bool isTomorrow) async {
    final result = await showModalBottomSheet<StudySession>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddStudySessionSheet(isTomorrow: isTomorrow),
    );

    if (result != null) {
      setState(() {
        if (isTomorrow) {
          _tomorrowSessions.add(result);
        } else {
          _todaySessions.add(result);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.studyTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.onSurface,
          unselectedLabelColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.4),
          indicatorColor: theme.colorScheme.onSurface,
          indicatorWeight: 2,
          labelStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Battambang',
            fontSize: 14,
          ),
          tabs: [
            Tab(text: AppStrings.studyToday),
            Tab(text: '${AppStrings.studyTomorrow} - ${AppStrings.studySchedule}'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StudySessionList(
            sessions: _todaySessions,
            onToggle: (i) => _toggleComplete(false, i),
            onAdd: () => _addSession(false),
          ),
          _StudySessionList(
            sessions: _tomorrowSessions,
            onToggle: (i) => _toggleComplete(true, i),
            onAdd: () => _addSession(true),
          ),
        ],
      ),
    );
  }
}

class _StudySessionList extends StatelessWidget {
  final List<StudySession> sessions;
  final void Function(int) onToggle;
  final VoidCallback onAdd;

  const _StudySessionList({
    required this.sessions,
    required this.onToggle,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        sessions.isEmpty
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
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return _StudySessionCard(
                    session: sessions[index],
                    onToggle: () => onToggle(index),
                    index: index,
                  );
                },
              ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: onAdd,
            backgroundColor: theme.colorScheme.onSurface,
            foregroundColor: theme.colorScheme.surface,
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }
}

class _StudySessionCard extends StatelessWidget {
  final StudySession session;
  final VoidCallback onToggle;
  final int index;

  const _StudySessionCard({
    required this.session,
    required this.onToggle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr =
        '${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')}';
    final opacity = session.isCompleted ? 0.5 : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: session.isCompleted
                    ? Colors.green.withValues(alpha: 0.5)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5 * opacity),
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '${session.durationMinutes} ${AppStrings.minutes}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.3 * opacity),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            session.subject,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: opacity),
                              decoration: session.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (session.notes != null &&
                              session.notes!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              session.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4 * opacity),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onToggle,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: session.isCompleted
                                ? Colors.green
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          color: session.isCompleted
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                        child: session.isCompleted
                            ? const Icon(Icons.check_rounded,
                                size: 16, color: Colors.green)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.05);
  }
}

class _AddStudySessionSheet extends StatefulWidget {
  final bool isTomorrow;
  const _AddStudySessionSheet({required this.isTomorrow});

  @override
  State<_AddStudySessionSheet> createState() => _AddStudySessionSheetState();
}

class _AddStudySessionSheetState extends State<_AddStudySessionSheet> {
  final _subjectController = TextEditingController();
  final _notesController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationMinutes = 30;

  @override
  void dispose() {
    _subjectController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
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
            Text(AppStrings.studyAddSession,
                style: theme.textTheme.headlineMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: AppStrings.studySubject,
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) setState(() => _selectedTime = time);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.studyDuration,
                      style: theme.textTheme.bodyMedium),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_rounded, size: 20),
                        onPressed: _durationMinutes > 15
                            ? () =>
                                setState(() => _durationMinutes -= 15)
                            : null,
                      ),
                      Text(
                        '$_durationMinutes ${AppStrings.minutes}',
                        style: theme.textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_rounded, size: 20),
                        onPressed: () =>
                            setState(() => _durationMinutes += 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: AppStrings.studyNotes,
              ),
              style: theme.textTheme.bodyLarge,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_subjectController.text.isEmpty) return;
                  final date = widget.isTomorrow
                      ? DateTime.now().add(const Duration(days: 1))
                      : DateTime.now();
                  final session = StudySession(
                    id: const Uuid().v4(),
                    subject: _subjectController.text,
                    startTime: DateTime(
                      date.year,
                      date.month,
                      date.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    ),
                    durationMinutes: _durationMinutes,
                    notes: _notesController.text.isEmpty
                        ? null
                        : _notesController.text,
                    date: date,
                  );
                  Navigator.pop(context, session);
                },
                child: Text(AppStrings.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
