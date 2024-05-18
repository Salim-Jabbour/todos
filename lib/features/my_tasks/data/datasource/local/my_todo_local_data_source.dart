import 'package:sqflite/sqflite.dart';
import '../../../models/my_todo_model.dart';
import 'package:path/path.dart' as p;

const String fileName = "tasks_database.db";

abstract class MyTodoLocalDataSource {
  Future<Database> get database;

  Future<Database> initDb(String fileName);
  Future<void> createTodo(MyTodoModelOffline todo);
  Future<List<MyTodoModelOffline>?> getAllTodos();
  Future<void> updateUser(MyTodoModelOffline todo);
  Future<void> deleteUser(int id);
  Future<void> closeDb();

  // to clear local db and put the new ones
  Future<void> clearDatabase();
  Future<void> insertTodos(List<MyTodoModelOffline> todos);
}

class MyTodoLocalDataSourceImpl extends MyTodoLocalDataSource {
  static Database? _database;
  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb(fileName);
    return _database!;
  }

  @override
  Future<Database> initDb(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        $idField INTEGER PRIMARY KEY AUTOINCREMENT ,
        $todoField $textType,
        $completedField INTEGER,
        $userIdField INTEGER
      )
    ''');
  }

  @override
  Future<void> createTodo(MyTodoModelOffline todo) async {
    final db = await database;
    await db.insert(
      tableName,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<MyTodoModelOffline>?> getAllTodos() async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((json) => MyTodoModelOffline.fromJson(json)).toList();
  }

  @override
  Future<void> insertTodos(List<MyTodoModelOffline> todos) async {
    final db = await database;
    Batch batch = db.batch();
    for (MyTodoModelOffline todo in todos) {
      batch.insert(
        'todos',
        todo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> deleteUser(int id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(MyTodoModelOffline todo) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<void> closeDb() async {
    final db = await database;
    return db.close();
  }

  @override
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('todos');
  }
}
