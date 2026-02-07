import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/blood_pressure.dart';
import '../repositories/blood_pressure_repository.dart';

class AddBloodPressureRecord extends UseCase<BloodPressure, BloodPressure> {
  final BloodPressureRepository repository;

  AddBloodPressureRecord(this.repository);

  @override
  Future<Either<Failure, BloodPressure>> call(BloodPressure params) {
    return repository.addRecord(params);
  }
}
