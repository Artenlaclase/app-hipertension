import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class CreateMedication extends UseCase<Medication, Medication> {
  final MedicationRepository repository;

  CreateMedication(this.repository);

  @override
  Future<Either<Failure, Medication>> call(Medication params) {
    return repository.createMedication(params);
  }
}
