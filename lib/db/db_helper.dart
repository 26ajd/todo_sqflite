import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';
  Future<Database> get mydb async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }
  Future<Database> _initDb() async {
    try {
      String _path = join(await getDatabasesPath(), 'tasks.db');
      return await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              priority TEXT,
              dueDate TEXT,
              isCompleted INTEGER,
              category TEXT,
              createdAt TEXT
            )
            ''',
          );
        },
      );
    } catch (e) {
      print("DB Init Error: $e");
      rethrow;
    }
  }

  // ===== CRUD Methods =====

  Future<int> insert(Task task) async {
    final db =await mydb;
    return await db.insert(_tableName, task.toJson());
  }

  Future<List<Map<String, dynamic>>> query() async {
    final db = await mydb;
    return await db.query(_tableName);
  }

  Future<int> delete(Task task) async {
    final db = await mydb;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> updateCompleted(int id) async {
    final db = await mydb;
    return await db.rawUpdate(
      '''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [1, id],
    );
  }

  Future<int> updateTask(Task task) async {
    final db = await mydb;
    return await db.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
