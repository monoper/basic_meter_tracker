import 'dart:async';
import 'package:meter_tracker/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  Future<List<Location>> getLocations() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query('locations');
    return result.map((e) => Location.fromMap(e)).toList();
  }

  Future<List<Meter>> getMeters() async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query('meters');
    return result.map((e) => Meter.fromMap(e)).toList();
  }

  Future<void> addLocation(Location location) async {
    final db = await database;
    await db.insert('locations', location.toMap());
  }

  Future<List<MeterReading>> getMeterReadings(int meterId) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query('meter_readings',
        where: 'meter_id = ?', whereArgs: [meterId], orderBy: "timestamp desc");
    return result.map((e) => MeterReading.fromMap(e)).toList();
  }

  Future<void> addMeterReading(MeterReading meterReading) async {
    final db = await database;
    await db.insert('meter_readings', meterReading.toMap());
  }

  Future<void> addMeter(Meter meter) async {
    final db = await database;
    await db.insert('meters', meter.toMap());
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'meter_tracker.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            street_number TEXT, 
            street TEXT, 
            state TEXT, 
            postal_code TEXT, 
            country TEXT,
            archived BOOL
            );''',
        );
        await db.execute(
          '''
          CREATE TABLE meters(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            serial_number TEXT,
            location_id INTEGER,
            archived BOOL,
            type TEXT,
            FOREIGN KEY(location_id) REFERENCES locations(id)
            );''',
        );
        await db.execute(
          '''
          CREATE TABLE meter_readings(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            meter_id INTEGER, 
            timestamp INTEGER, 
            reading REAL,
            FOREIGN KEY(meter_id) REFERENCES meters(id)
            );''',
        );
      },
      version: 1,
    );
  }
}
