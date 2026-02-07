import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/blood_pressure.dart';
import '../repositories/blood_pressure_repository.dart';

class GetBloodPressureHistory
    extends UseCase<List<BloodPressure>, BloodPressureHistoryParams> {
  final BloodPressureRepository repository;

  GetBloodPressureHistory(this.repository);

  @override
  Future<Either<Failure, List<BloodPressure>>> call(
    BloodPressureHistoryParams params,
  ) {
    if (params.start != null && params.end != null) {
      return repository.getRecordsByDateRange(
        params.userId,
        params.start!,
        params.end!,
      );
    }
    return repository.getRecords(params.userId);
  }
}

class BloodPressureHistoryParams extends Equatable {
  final String userId;
  final DateTime? start;
  final DateTime? end;

  const BloodPressureHistoryParams({
    required this.userId,
    this.start,
    this.end,
  });

  @override
  List<Object?> get props => [userId, start, end];
}
