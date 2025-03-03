import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'movie_model.dart';  // นำเข้าตรง ๆ โดยไม่ใช้ hide

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movie_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        rating INTEGER,
        genre TEXT,
        releaseDate TEXT
      )
    ''');
  }

  Future<List<Movie>> getMovies() async {  // ใช้ `Movie` ตรง ๆ
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);  // ใช้ `Movie` จาก `movie_model.dart`
    });
  }

  Future<int> insertMovie(Movie movie) async {  // ใช้ `Movie` ตรง ๆ
    final db = await instance.database;
    return await db.insert('movies', movie.toMap());
  }

  Future<int> deleteMovie(int id) async {
    final db = await instance.database;
    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateMovie(Movie movie) async {  // ใช้ `Movie` ตรง ๆ
    final db = await instance.database;
    return await db.update('movies', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }
}
