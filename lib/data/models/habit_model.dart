import '../../domain/entities/habit.dart';

class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.icon,
    super.isActive,
    super.completedDates,
    required super.createdAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json, {String userId = ''}) {
    return HabitModel(
      id: json['id'].toString(),
      userId: userId,
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: '💪',
      isActive: true,
      completedDates: const [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
