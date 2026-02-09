import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/medication_repository.dart';

class DeleteMedication extends UseCase<void, String> {
  final MedicationRepository repository;

  DeleteMedication(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteMedication(params);
  }
}
