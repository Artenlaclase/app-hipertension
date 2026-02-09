import 'package:equatable/equatable.dart';

/// Duración del tratamiento
enum TreatmentDuration { days7, days15, days30, nextCheckup, chronic }

extension TreatmentDurationX on TreatmentDuration {
  String get label {
    switch (this) {
      case TreatmentDuration.days7:
        return '7 días';
      case TreatmentDuration.days15:
        return '15 días';
      case TreatmentDuration.days30:
        return '30 días';
      case TreatmentDuration.nextCheckup:
        return 'Próximo control médico';
      case TreatmentDuration.chronic:
        return 'Crónico';
    }
  }

  /// Retorna la fecha de fin, null si es crónico
  DateTime? endDate(DateTime startDate) {
    switch (this) {
      case TreatmentDuration.days7:
        return startDate.add(const Duration(days: 7));
      case TreatmentDuration.days15:
        return startDate.add(const Duration(days: 15));
      case TreatmentDuration.days30:
        return startDate.add(const Duration(days: 30));
      case TreatmentDuration.nextCheckup:
        return startDate.add(const Duration(days: 90));
      case TreatmentDuration.chronic:
        return null; // Sin fecha de fin
    }
  }
}

class Medication extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final int frequencyHours; // cada cuántas horas
  final DateTime startTime; // hora de inicio
  final TreatmentDuration duration;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final List<MedicationDose> doses;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequencyHours,
    required this.startTime,
    required this.duration,
    this.endDate,
    this.isActive = true,
    required this.createdAt,
    this.doses = const [],
  });

  /// Calcula la próxima hora en que se debe tomar
  DateTime? get nextDoseTime {
    if (!isActive) return null;
    final now = DateTime.now();

    // Si tiene fecha fin y ya pasó, no hay próxima dosis
    if (endDate != null && now.isAfter(endDate!)) return null;

    DateTime next = startTime;
    while (next.isBefore(now)) {
      next = next.add(Duration(hours: frequencyHours));
    }

    if (endDate != null && next.isAfter(endDate!)) return null;
    return next;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dosage,
    frequencyHours,
    startTime,
    duration,
    endDate,
    isActive,
    createdAt,
    doses,
  ];
}

class MedicationDose extends Equatable {
  final String id;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final bool wasTaken;

  const MedicationDose({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    this.wasTaken = false,
  });

  @override
  List<Object?> get props => [
    id,
    medicationId,
    scheduledTime,
    takenTime,
    wasTaken,
  ];
}
