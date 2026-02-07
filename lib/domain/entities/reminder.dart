import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final int hour;
  final int minute;
  final List<int> daysOfWeek; // 1=lunes ... 7=domingo
  final bool isEnabled;
  final String type; // blood_pressure, medication, meal, water, habit

  const Reminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    this.isEnabled = true,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        hour,
        minute,
        daysOfWeek,
        isEnabled,
        type,
      ];
}
