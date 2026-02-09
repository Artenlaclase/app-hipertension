import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class GetMedications extends UseCase<List<Medication>, NoParams> {
  final MedicationRepository repository;

  GetMedications(this.repository);

  @override
  Future<Either<Failure, List<Medication>>> call(NoParams params) {
    return repository.getMedications();
  }
}
