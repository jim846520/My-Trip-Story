import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLDiary {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE diary(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        contents TEXT,
      )
      """);
  }
 
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'trip.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);  
      },
    );
  }

  // Create new diary (journal)
  static Future<int> createDiary(String title, String? contents) async {
    final db = await SQLDiary.db();

    final data = {'title': title, 'contents': contents};
    final id = await db.insert('diary', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all diary (journals)
  static Future<List<Map<String, dynamic>>> getDiary() async {
    final db = await SQLDiary.db();
    return db.query('diary', orderBy: "id");
  }

  // Read a single diary by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItems(int id) async {
    final db = await SQLDiary.db();
    return db.query('diary', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an diary by id
  static Future<int> updateDiary(int id, String title, String? contents) async {
    final db = await SQLDiary.db();

    final data = {
      'title': title,
      'contents': contents,
    };

    final result =
        await db.update('diary', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteDiary(int id) async {
    final db = await SQLDiary.db();
    try {
      await db.delete("diary", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}