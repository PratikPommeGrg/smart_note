import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_note/src/features/note/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  final _databaseName = "smartNote.db";
  final _databaseVersion = 1;

  final String tableName = "notes";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnNote = "note";
  final String columnCategory = "category";
  final String columnImagesPath = "images";
  final String columnCardSize = "cardSize";

  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  static Database? _database;

  Future<Database?> get openMyDatabase async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String fullPath = '$databasePath/$_databaseName';
    print("full path :: $fullPath");
    return await openDatabase(
      fullPath,
      version: _databaseVersion,
      onCreate: (db, version) {
        db.execute('''
CREATE TABLE $tableName(
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$columnTitle TEXT NOT NULL,
$columnNote TEXT NOT NULL,
$columnCategory TEXT NOT NULL,
$columnImagesPath TEXT,
$columnCardSize DOUBLE NOT NULL
)
''');
      },
    );
  }

  Future<List<NoteModel>?> getAllNotes() async {
    await openMyDatabase;
    final List<Map<String, Object?>> result =
        await _database!.rawQuery('Select * from $tableName');
    print("resutl all notest :: $result");
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  insertToTable(NoteModel note) async {
    try {
      await openMyDatabase;
      await _database!.insert(
        tableName,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    } finally {
      // _database?.close();
    }
  }

  deleteFromTable(int id) async {
    await openMyDatabase.then((value) => value!.delete(
          tableName,
          where: "$columnId = ?",
          whereArgs: [id],
        ));
    // _database?.close();
  }

  Future<List<NoteModel>?> getNotesByCategory(String category) async {
    print("category in service :: $category");
    await openMyDatabase;
    final List<Map<String, Object?>> result = await _database!
        .query(tableName, where: '$columnCategory = ?', whereArgs: [category]);
    return result.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<NoteModel?> getNoteById(int id) async {
    await openMyDatabase;
    final List<Map<String, Object?>> result = await _database!.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.firstOrNull != null ? NoteModel.fromMap(result.first) : null;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null; // Reset the reference to ensure no further usage.
      print("Database closed successfully.");
    }
  }
}

final localStorageServiceProvider =
    Provider((ref) => LocalStorageService.instance);
