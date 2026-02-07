import 'package:equatable/equatable.dart';

enum HypertensionLevel { mild, moderate, severe }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum Gender { male, female }

class UserProfile extends Equatable {
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final double weight; // kg
  final double height; // cm
  final ActivityLevel activityLevel;
  final HypertensionLevel hypertensionLevel;
  final double initialSystolic;
  final double initialDiastolic;
  final DateTime createdAt;
  final bool hasAcceptedDisclaimer;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.hypertensionLevel,
    required this.initialSystolic,
    required this.initialDiastolic,
    required this.createdAt,
    this.hasAcceptedDisclaimer = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    gender,
    weight,
    height,
    activityLevel,
    hypertensionLevel,
    initialSystolic,
    initialDiastolic,
    createdAt,
    hasAcceptedDisclaimer,
  ];
}
