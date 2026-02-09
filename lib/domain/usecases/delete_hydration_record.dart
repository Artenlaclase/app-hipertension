import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/hydration_repository.dart';

class DeleteHydrationRecord extends UseCase<void, String> {
  final HydrationRepository repository;

  DeleteHydrationRecord(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteRecord(params);
  }
}
