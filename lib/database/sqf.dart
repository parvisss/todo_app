// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';

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

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'todos.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE todos(
            id TEXT PRIMARY KEY,
            title TEXT,
            date TEXT,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  // Insert a Todo into the database
  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all todos from the database
  Future<List<Todo>> fetchTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');

    // Convert List<Map<String, dynamic>> to List<Todo>
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: DateTime.parse(maps[i]['date']),
        isDone: maps[i]['isDone'] == 1 ? true : false,
      );
    });
  }

  // Update an existing Todo in the database
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a Todo from the database
  Future<int> deleteTodo(String id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
