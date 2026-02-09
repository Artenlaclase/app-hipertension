import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/hydration.dart';

abstract class HydrationRepository {
  /// Obtener registros de hidratación de un día
  Future<Either<Failure, List<HydrationRecord>>> getRecordsByDate(
    DateTime date,
  );

  /// Agregar un registro de hidratación
  Future<Either<Failure, HydrationRecord>> addRecord(HydrationRecord record);

  /// Eliminar un registro
  Future<Either<Failure, void>> deleteRecord(String id);

  /// Obtener meta diaria en ml
  Future<Either<Failure, int>> getDailyGoal();

  /// Actualizar meta diaria en ml
  Future<Either<Failure, void>> setDailyGoal(int goalMl);
}
