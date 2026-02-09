import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/hydration.dart';
import '../repositories/hydration_repository.dart';

class GetHydrationRecords extends UseCase<List<HydrationRecord>, DateTime> {
  final HydrationRepository repository;

  GetHydrationRecords(this.repository);

  @override
  Future<Either<Failure, List<HydrationRecord>>> call(DateTime params) {
    return repository.getRecordsByDate(params);
  }
}
