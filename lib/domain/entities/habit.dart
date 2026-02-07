import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String icon;
  final bool isActive;
  final List<DateTime> completedDates;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.icon,
    this.isActive = true,
    this.completedDates = const [],
    required this.createdAt,
  });

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime current = DateTime.now();
    for (final date in sorted) {
      if (_isSameDay(date, current) ||
          _isSameDay(date, current.subtract(const Duration(days: 1)))) {
        streak++;
        current = date;
      } else {
        break;
      }
    }
    return streak;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        icon,
        isActive,
        completedDates,
        createdAt,
      ];
}
