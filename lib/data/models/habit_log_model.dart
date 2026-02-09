class HabitLogModel {
  final String id;
  final String userId;
  final String habitId;
  final DateTime completedAt;

  const HabitLogModel({
    required this.id,
    required this.userId,
    required this.habitId,
    required this.completedAt,
  });

  factory HabitLogModel.fromJson(Map<String, dynamic> json) {
    return HabitLogModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      habitId: json['habit_id'].toString(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_id': int.tryParse(habitId) ?? habitId,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
