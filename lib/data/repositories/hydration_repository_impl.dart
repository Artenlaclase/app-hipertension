import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/hydration.dart';
import '../../domain/repositories/hydration_repository.dart';
import '../datasources/hydration_local_datasource.dart';
import '../models/hydration_record_model.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  final HydrationLocalDataSource localDataSource;

  HydrationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<HydrationRecord>>> getRecordsByDate(
    DateTime date,
  ) async {
    try {
      final models = await localDataSource.getRecordsByDate(date);
      final records = models.map((m) => m.toEntity()).toList();
      return Right(records);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure('Error al obtener registros: $e'));
    }
  }

  @override
  Future<Either<Failure, HydrationRecord>> addRecord(
    HydrationRecord record,
  ) async {
    try {
      final model = HydrationRecordModel.fromEntity(record);
      final result = await localDataSource.insertRecord(model);
      return Right(result.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure('Error al guardar registro: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecord(String id) async {
    try {
      await localDataSource.deleteRecord(id);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure('Error al eliminar registro: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getDailyGoal() async {
    try {
      final goal = await localDataSource.getDailyGoal();
      return Right(goal);
    } catch (e) {
      return const Right(2000); // Valor por defecto
    }
  }

  @override
  Future<Either<Failure, void>> setDailyGoal(int goalMl) async {
    try {
      await localDataSource.setDailyGoal(goalMl);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure('Error al actualizar meta: $e'));
    }
  }
}
