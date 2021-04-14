import 'dart:io' show Directory;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    final uuid = Uuid();
    var id = uuid.v1;
    _database = await _initDatabase(id);
    return _database;
  }

  _initDatabase(id) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), "aburrinator.db");
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        db.execute('''
        CREATE TABLE contador(
        id STRING PRIMARY KEY,
        contador INTEGER
        ),
        ''');
        await db.rawInsert('''
        INSERT INTO contador(id, contador) VALUES($id, 0);
        ''');
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query("contador");
  }
}