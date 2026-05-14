class StudySession {
  final String id;
  final String subject;
  final DateTime startTime;
  final int durationMinutes;
  final String? notes;
  final bool isCompleted;
  final DateTime date;
  final DateTime createdAt;

  StudySession({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.durationMinutes,
    this.notes,
    this.isCompleted = false,
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'start_time': startTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
      'is_completed': isCompleted ? 1 : 0,
      'date': date.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] as String,
      subject: map['subject'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      durationMinutes: map['duration_minutes'] as int,
      notes: map['notes'] as String?,
      isCompleted: (map['is_completed'] as int) == 1,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  StudySession copyWith({
    String? subject,
    DateTime? startTime,
    int? durationMinutes,
    String? notes,
    bool? isCompleted,
    DateTime? date,
  }) {
    return StudySession(
      id: id,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      createdAt: createdAt,
    );
  }
}
