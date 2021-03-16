import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final dbName = "TodoGoalsDB";
  static final _dbVersion = 1;

  static final id = "_id";
  static final columName = "task";
  static final tableName = "goals";
  static final isComplete = "isComplete";
  static final isDeleted = "isDeleted";

  //Makes it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();

    return _database;
  }

  void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult,
      int insertAndUpdateQueryResult,
      List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  _initiateDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: _onCreate,
      version: _dbVersion,
    );
    return database;
    // Directory directory = await getApplicationDocumentsDirectory();
    // String path = join(directory.path, dbName);
    // print(path);
    // return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableName
    (
      $id INTEGER PRIMARY KEY,
      $columName TEXT NOT NULL,
      $isComplete BIT NOT NULL,
      $isDeleted BIT NOT NULL
     )''');
  }

  Future<String> getDBPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  // Future<List<Map<String, dynamic>>> queryAll() async {
  //   Database db = await instance.database;
  //   return await db.query(dbName);
  // }

  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   //Returns number of updated rows
  //   return await db.update(
  //     dbName,
  //     row,
  //     where: "$columnId = ?",
  //     whereArgs: [id],
  //   );
  // }

// Future<int> insert(Map<String, dynamic> row) async {
//   Database db = await instance.database;
//   //Returns unique ID/Primary Key
//   return await db.insert(dbName, row);
// }

  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(dbName, where: "$columnId =?", whereArgs: [id]);
  // }
}
