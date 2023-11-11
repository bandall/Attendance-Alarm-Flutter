import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'alarm_info.dart';

class AlarmInfoDb {
  static final AlarmInfoDb _instance = AlarmInfoDb._internal();

  factory AlarmInfoDb() {
    return _instance;
  }

  AlarmInfoDb._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'alarm_info.db');

    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE alarm_info(alarmId INTEGER PRIMARY KEY, memberId INTEGER, day INTEGER, hour INTEGER, minute INTEGER, alarmGap INTEGER, isAlarmOn INTEGER, subjectId INTEGER, subjectName TEXT)',
      );
    });
  }

  Future<int> insert(AlarmInfo alarm) async {
    final db = await database;

    return db.insert(
      'alarm_info',
      alarm.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AlarmInfo>> getAllAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alarm_info');

    return List.generate(maps.length, (i) {
      return AlarmInfo(
        alarmId: maps[i]['alarmId'],
        memberId: maps[i]['memberId'],
        day: maps[i]['day'],
        hour: maps[i]['hour'],
        minute: maps[i]['minute'],
        alarmGap: maps[i]['alarmGap'],
        isAlarmOn: maps[i]['isAlarmOn'] == 1,
        subjectId: maps[i]['subjectId'],
        subjectName: maps[i]['subjectName'],
      );
    });
  }

  Future<int> updateAlarmOn(int? alarmId, bool isAlarmOn, int alarmGap) async {
    final db = await database;
    return db.update(
      'alarm_info',
      {'isAlarmOn': isAlarmOn ? 1 : 0, 'alarmGap': alarmGap},
      where: 'alarmId = ?',
      whereArgs: [alarmId],
    );
  }

  Future<void> delete(int? alarmId) async {
    final db = await database;

    await db.delete(
      'alarm_info',
      where: 'alarmId = ?',
      whereArgs: [alarmId],
    );
  }

  Future<void> deleteAll() async {
    final db = await database;

    await db.delete(
      'alarm_info',
    );
  }
}
