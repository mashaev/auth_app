import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  String id = 'id';
  String note = 'note';
  String nameTable = 'notesTable';

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<Database> initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathDB = dir.path + '/notes.db';

    var noteDB = await openDatabase(pathDB, version: 1, onCreate: _createDb);
    return noteDB;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'Create table $nameTable($id integer primary key autoincrement, $note text)');
  }

  Future<int> insertNote(String noteInsert) async {
    Database db = await this.database;

    var result = await db.rawInsert(
      "insert into $nameTable($note) " + " values('$noteInsert')",
    );

    return result; // до записи было 4 result = 5
  }

  Future<List<Map<String, dynamic>>> selectNote({int id = null}) async {
    Database db = await this.database;
    var result;
    if (id != null) {
      result = await db.query(nameTable, where: 'id = $id');
    } else {
      result = await db.query(nameTable);
    }

    return result; // [{key: value, key: value,},{key: value, key: value,},{key: value, key: value,},]
  }

  Future<int> deleteNote(String noteId) async {
    Database db = await this.database;
    int result = await db.delete(nameTable, where: "id = $noteId");
    return result;
  }

  Future<int> updateNote(String id, String noteUpdate) async {
    Database db = await this.database;

    int count = await db.rawUpdate(
        'Update $nameTable SET note = ? WHERE id = ?',
        [noteUpdate, int.parse(id)]);

    return count;
  }
}
