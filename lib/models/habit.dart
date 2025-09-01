enum HabitFrequency { daily, weekly }

class Habit {
  final String id;
  String title;
  String category; // Health, Study, Fitness, Productivity, Mental Health, Others
  HabitFrequency frequency;
  DateTime createdAt;
  DateTime? startDate;
  String? notes;
  int currentStreak;
  List<DateTime> completionHistory;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.frequency,
    required this.createdAt,
    this.startDate,
    this.notes,
    this.currentStreak = 0,
    List<DateTime>? completionHistory,
  }) : completionHistory = completionHistory ?? [];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'frequency': frequency.name,
      'creationDate': createdAt.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'notes': notes,
      'currentStreak': currentStreak,
      'completionHistory': completionHistory.map((d) => DateTime(d.year, d.month, d.day).toIso8601String()).toList(),
    };
  }

  factory Habit.fromMap(String id, Map<String, dynamic> data) {
    return Habit(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'Others',
      frequency: (data['frequency'] == 'weekly') ? HabitFrequency.weekly : HabitFrequency.daily,
      createdAt: DateTime.tryParse(data['creationDate'] ?? '') ?? DateTime.now(),
      startDate: (data['startDate'] != null) ? DateTime.tryParse(data['startDate']) : null,
      notes: data['notes'],
      currentStreak: (data['currentStreak'] ?? 0) as int,
      completionHistory: ((data['completionHistory'] ?? []) as List).map((e) => DateTime.tryParse(e) ?? DateTime.now()).toList(),
    );
  }

  static const predefinedCategories = <String>[
    'Health','Study','Fitness','Productivity','Mental Health','Others'
  ];
}
