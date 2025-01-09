import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, completed INTEGER)",
        );
      },
    );
  }

  Future<void> insertTask(String task) async {
    final db = await database;
    await db.insert(
      'todos',
      {'task': task, 'completed': 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('todos');
  }

  Future<void> updateTask(int id, String task) async {
    final db = await database;
    await db.update(
      'todos',
      {'task': task},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCompletionStatus(int id, int completed) async {
    final db = await database;
    await db.update(
      'todos',
      {'completed': completed},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
