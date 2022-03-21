import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
// Para que se pueda obtner con una única importación en el ScanListProvider
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  // Constructor privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    // Path de almacenamiento de la DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    // print(path);

    // Creacion de la DB
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            type TEXT,
            value TEXT
          )
        ''');
      },
    );
  }

  Future<int> newScanRaw(ScanModel nuevoScan) async {
    final int? id = nuevoScan.id;
    final String? type = nuevoScan.type;
    final String value = nuevoScan.value;

    // Verificar la DB
    final Database db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, type, value)
        VALUE($id, '$type', '$value')
    ''');

    // Retorna el ID del ultimo registro insertado en la DB
    return res;
  }

  Future<int> newScan(ScanModel nuevoScan) async {
    // Verificar la DB
    final Database db = await database;

    // Retorna el ID del ultimo registro insertado en la DB
    return await db.insert('Scans', nuevoScan.toJson());
  }

  Future<ScanModel?> getScanById(int iD) async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [iD]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    // Verificar la DB
    final Database db = await database;

    // final res = await db.query('Scans', where: 'type = ?', whereArgs: [type]);
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE type = '$type'
    ''');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel updateScan) async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.update('Scans', updateScan.toJson(),
        where: 'id = ?', whereArgs: [updateScan.id]);

    return res;
  }

  Future<int> deleteScan(int iD) async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [iD]);

    return res;
  }

  Future<int> deleteAllScans() async {
    // Verificar la DB
    final Database db = await database;

    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');

    return res;
  }
}

/**
 * Cómo resolver el problema de la versión no coincidente de adb. VER:
 * https://olkunmustafa.medium.com/how-to-solve-adb-mismatch-version-issue-9a534c107de
 */
