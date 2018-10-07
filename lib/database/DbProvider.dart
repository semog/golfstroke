import 'dart:async';

import 'package:golfstroke/database/dbutils.dart';
import 'package:golfstroke/model/Hole.dart';
import 'package:golfstroke/model/IMappable.dart';
import 'package:golfstroke/model/Round.dart';
import 'package:golfstroke/model/Setting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  Database _db;
  Setting<int> lastRound;
  List<Round> rounds;

  Future<DbProvider> open() async {
    // Get a location using getDatabasesPath
    String fulldbpath = join(await getDatabasesPath(), databaseStrokeCounts);
    _db = await openDatabase(fulldbpath, version: 1, onCreate: createDb, onUpgrade: upgradeDb);
    await _loadSettings();
    await _loadRounds();
    return this;
  }

  createDb(Database db, int version) {
    db.execute('''create table $tableSetting (
$columnSettingId integer primary key,
$columnSettingName text not null,
$columnSettingValue text)''');
    db.execute("create unique index $indexSettingName on $tableSetting ($columnSettingName)");

    db.execute('''create table $tableRound (
$columnRoundId integer primary key,
$columnRoundDate text not null,
$columnRoundSlope integer,
$columnRoundRating integer,
$columnRoundCurrentHole integer not null)''');

    db.execute('''create table $tableHole (
$columnHoleId integer primary key,
$columnHoleRoundId integer not null,
$columnHoleHole integer not null,
$columnHoleStrokeCount integer not null)''');
    db.execute("create index $indexHoleRoundId on $tableHole ($columnHoleRoundId)");
  }

  upgradeDb(Database db, int oldVersion, int newVersion) {
    // Perform any upgrades from old versions.
    if (1 == oldVersion && 2 == newVersion) {
      // Do updates as needed
    } else if (2 == oldVersion && 3 == newVersion) {
      // Do updates as needed
    }
  }

  Future close() => _db.close();

  Future<Setting<T>> getSetting<T>(String settingname, T defaultVal) async {
    List<Map<String, dynamic>> maps = await _db.query(tableSetting,
        columns: [columnSettingId, columnSettingName, columnSettingValue],
        where: "$columnSettingName = ?",
        whereArgs: [settingname]);
    if (maps.length > 0) {
      return Setting<T>.fromMap(maps.first);
    }
    return Setting<T>(settingname, defaultVal);
  }

  _loadSettings() async {
    lastRound = await getSetting<int>(settingLastRound, 0);
  }

  _loadRounds() async {
    List<Map<String, dynamic>> maps = await _db.query(tableRound, columns: [
      columnRoundId,
      columnRoundDate,
      columnRoundSlope,
      columnRoundRating,
      columnRoundCurrentHole,
    ]);
    rounds = List<Round>();
    maps.forEach((record) async {
      Round round = Round.fromMap(record);
      rounds.add(round);
      await _loadHoles(round);
    });
  }

  Round getRound(int id) => rounds.firstWhere((round) => round.id == id, orElse: null);

  _loadHoles(Round round) async {
    round.holes = await _getHoles(round);
    round.setCurrentHole();
  }

  Future<List<Hole>> _getHoles(Round round) async {
    List<Map<String, dynamic>> maps = await _db.query(tableHole,
        columns: [columnHoleId, columnHoleHole, columnHoleStrokeCount],
        where: "$columnHoleRoundId = ? ",
        whereArgs: [round.id],
        orderBy: columnHoleHole);
    var holes = List<Hole>();
    maps.forEach((record) => holes.add(Hole.fromMap(round, record)));
    return holes;
  }

  Round createRound() {
    var round = Round();
    save(round);
    round.holes.forEach((hole) => save(hole));
    rounds.add(round);
    return round;
  }

  Future<int> save(IMappable item) {
    if (null == item.id) {
      item.id = getId();
      return _insertItem(item);
    }
    return _updateItem(item);
  }

  Future<int> _insertItem(IMappable item) {
    return _db.insert(item.tableName, item.toMap());
  }

  Future<int> _updateItem(IMappable item) {
    return _db.update(
      item.tableName,
      item.toMap(),
      where: "${item.idColumnName} = ?",
      whereArgs: [item.id],
    );
  }

  Future<int> delete(IMappable item) {
    return _db.delete(
      item.tableName,
      where: "${item.idColumnName} = ?",
      whereArgs: [item.id],
    );
  }
}
