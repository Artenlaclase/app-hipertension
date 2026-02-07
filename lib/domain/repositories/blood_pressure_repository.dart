import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/blood_pressure.dart';

abstract class BloodPressureRepository {
  Future<Either<Failure, BloodPressure>> addRecord(BloodPressure record);
  Future<Either<Failure, List<BloodPressure>>> getRecords(String userId);
  Future<Either<Failure, List<BloodPressure>>> getRecordsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  );
  Future<Either<Failure, BloodPressure?>> getLatestRecord(String userId);
  Future<Either<Failure, void>> deleteRecord(String recordId);
}
