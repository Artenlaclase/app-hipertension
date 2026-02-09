import '../../core/services/database_helper.dart';
import '../models/hydration_record_model.dart';

abstract class HydrationLocalDataSource {
  /// Obtener registros de un día específico
  Future<List<HydrationRecordModel>> getRecordsByDate(DateTime date);

  /// Insertar un nuevo registro
  Future<HydrationRecordModel> insertRecord(HydrationRecordModel record);

  /// Eliminar un registro por id
  Future<void> deleteRecord(String id);

  /// Obtener meta diaria
  Future<int> getDailyGoal();

  /// Actualizar meta diaria
  Future<void> setDailyGoal(int goalMl);
}

class HydrationLocalDataSourceImpl implements HydrationLocalDataSource {
  final DatabaseHelper databaseHelper;

  HydrationLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<HydrationRecordModel>> getRecordsByDate(DateTime date) async {
    final db = await databaseHelper.database;

    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final maps = await db.query(
      'hydration_records',
      where: 'timestamp >= ? AND timestamp < ?',
      whereArgs: [dayStart.toIso8601String(), dayEnd.toIso8601String()],
      orderBy: 'timestamp DESC',
    );

    return maps.map((m) => HydrationRecordModel.fromMap(m)).toList();
  }

  @override
  Future<HydrationRecordModel> insertRecord(HydrationRecordModel record) async {
    final db = await databaseHelper.database;
    await db.insert('hydration_records', record.toMap());
    return record;
  }

  @override
  Future<void> deleteRecord(String id) async {
    final db = await databaseHelper.database;
    await db.delete('hydration_records', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> getDailyGoal() async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'hydration_settings',
      where: "key = ?",
      whereArgs: ['daily_goal_ml'],
    );
    if (result.isEmpty) return 2000;
    return int.tryParse(result.first['value'] as String) ?? 2000;
  }

  @override
  Future<void> setDailyGoal(int goalMl) async {
    final db = await databaseHelper.database;
    await db.update(
      'hydration_settings',
      {'value': goalMl.toString()},
      where: "key = ?",
      whereArgs: ['daily_goal_ml'],
    );
  }
}
