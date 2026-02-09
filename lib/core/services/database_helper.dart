import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'htapp.db');

    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hydration_records (
        id TEXT PRIMARY KEY,
        liquid_type TEXT NOT NULL,
        amount_ml INTEGER NOT NULL,
        note TEXT,
        timestamp TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE hydration_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Meta diaria por defecto: 2000ml
    await db.insert('hydration_settings', {
      'key': 'daily_goal_ml',
      'value': '2000',
    });
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
