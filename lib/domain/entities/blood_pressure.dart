import 'package:equatable/equatable.dart';

enum PressureCategory { normal, elevated, high, crisis }

class BloodPressure extends Equatable {
  final String id;
  final String userId;
  final double systolic;
  final double diastolic;
  final int? pulse;
  final String? notes;
  final DateTime recordedAt;

  const BloodPressure({
    required this.id,
    required this.userId,
    required this.systolic,
    required this.diastolic,
    this.pulse,
    this.notes,
    required this.recordedAt,
  });

  PressureCategory get category {
    if (systolic >= 180 || diastolic >= 120) return PressureCategory.crisis;
    if (systolic >= 140 || diastolic >= 90) return PressureCategory.high;
    if (systolic >= 130 || diastolic >= 80) return PressureCategory.elevated;
    return PressureCategory.normal;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        systolic,
        diastolic,
        pulse,
        notes,
        recordedAt,
      ];
}
