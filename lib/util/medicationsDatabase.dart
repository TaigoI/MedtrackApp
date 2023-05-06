import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MedicationsDatabaseHelper {

  static const String _name = "medications.db";

  static late Database db;

  Future<Database> init() async {
    String path = join(await getDatabasesPath(), _name);

    if(!await databaseExists(path)){
      _load(path);
    }

    db = await openDatabase(path);
    return db;
  }

  Future<void> _load(String path) async {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets", "database", _name));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }

}

