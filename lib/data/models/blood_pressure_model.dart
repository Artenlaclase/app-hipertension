import '../../domain/entities/blood_pressure.dart';

class BloodPressureModel extends BloodPressure {
  const BloodPressureModel({
    required super.id,
    required super.userId,
    required super.systolic,
    required super.diastolic,
    super.pulse,
    super.notes,
    required super.recordedAt,
  });

  factory BloodPressureModel.fromJson(Map<String, dynamic> json) {
    return BloodPressureModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      systolic: _parseDouble(json['systolic']),
      diastolic: _parseDouble(json['diastolic']),
      recordedAt: json['measured_at'] != null
          ? DateTime.parse(json['measured_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic.toInt(),
      'diastolic': diastolic.toInt(),
      'measured_at': recordedAt.toIso8601String(),
    };
  }

  factory BloodPressureModel.fromEntity(BloodPressure entity) {
    return BloodPressureModel(
      id: entity.id,
      userId: entity.userId,
      systolic: entity.systolic,
      diastolic: entity.diastolic,
      pulse: entity.pulse,
      notes: entity.notes,
      recordedAt: entity.recordedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
