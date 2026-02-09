import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/medication.dart';

abstract class MedicationRepository {
  /// Obtener todos los medicamentos del usuario
  Future<Either<Failure, List<Medication>>> getMedications();

  /// Crear un nuevo medicamento
  Future<Either<Failure, Medication>> createMedication(Medication medication);

  /// Eliminar un medicamento
  Future<Either<Failure, void>> deleteMedication(String id);

  /// Registrar toma de dosis (log)
  Future<Either<Failure, MedicationDose>> logDose({
    required String medicationId,
    required DateTime scheduledTime,
    required bool wasTaken,
  });

  /// Obtener historial de tomas de un medicamento
  Future<Either<Failure, List<MedicationDose>>> getDoseLogs(
    String medicationId,
  );

  /// Obtener adherencia
  Future<Either<Failure, Map<String, dynamic>>> getAdherence({String? period});
}
