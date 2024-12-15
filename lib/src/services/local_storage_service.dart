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
  final String imagesPath = "images";

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
    String fullPath = '$databasePath$_databaseName';
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
$imagesPath TEXT
)
''');
      },
    );
  }

  Future<List<NoteModel>?> getAllNotes() async {
    await openMyDatabase;
    final List<Map<String, Object?>> result =
        await _database!.rawQuery('Select * from $tableName');
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
    _database?.close();
  }
}

final localStorageServiceProvider =
    Provider((ref) => LocalStorageService.instance);
