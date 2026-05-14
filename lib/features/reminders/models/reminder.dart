class Reminder {
  final String id;
  final String title;
  final DateTime time;
  final bool isDaily;
  final bool isEnabled;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.title,
    required this.time,
    this.isDaily = false,
    this.isEnabled = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'is_daily': isDaily ? 1 : 0,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String,
      time: DateTime.parse(map['time'] as String),
      isDaily: (map['is_daily'] as int) == 1,
      isEnabled: (map['is_enabled'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Reminder copyWith({
    String? title,
    DateTime? time,
    bool? isDaily,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      time: time ?? this.time,
      isDaily: isDaily ?? this.isDaily,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt,
    );
  }
}
