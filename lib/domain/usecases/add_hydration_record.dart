import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/hydration.dart';
import '../repositories/hydration_repository.dart';

class AddHydrationRecord extends UseCase<HydrationRecord, HydrationRecord> {
  final HydrationRepository repository;

  AddHydrationRecord(this.repository);

  @override
  Future<Either<Failure, HydrationRecord>> call(HydrationRecord params) {
    return repository.addRecord(params);
  }
}
