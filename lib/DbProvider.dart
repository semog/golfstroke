import 'dart:async';

import 'package:golfstroke/Hole.dart';
import 'package:golfstroke/IMappable.dart';
import 'package:golfstroke/Round.dart';
import 'package:golfstroke/dbutils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  Database _db;

  Future<DbProvider> open() async {
    // Get a location using getDatabasesPath
    String fulldbpath = join(await getDatabasesPath(), databaseStrokeCounts);
    _db = await openDatabase(fulldbpath, version: 1, onCreate: createDb, onUpgrade: upgradeDb);
    return this;
  }

  createDb(Database db, int version) {
    db.execute('''create table $tableRound (
$columnRoundId integer primary key,
$columnRoundCourseId integer not null,
$columnRoundDate text not null,
$columnRoundCurrentHole integer not null)''');

    db.execute('''create table $tableLastRound (
$columnLastRoundId integer primary key,
$columnLastRoundRoundId integer not null)''');

    db.execute('''create table $tableHole (
$columnHoleId integer primary key,
$columnHoleRoundId integer not null,
$columnHoleHole integer not null,
$columnHoleStrokeCount integer not null)''');

    db.execute("create index $indexHoleRoundHole on $tableHole ($columnHoleRoundId, $columnHoleHole)");
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

  Future<Round> getLastRound() async {
    List<Map<String, dynamic>> maps =
        await _db.query(tableLastRound, columns: [columnLastRoundRoundId], where: "$columnLastRoundId = 0");
    if (maps.length > 0) {
      return getRound(maps.first[columnLastRoundRoundId]);
    } else {
      // Initialize the last round.
      return _insertLastRound(insertRound(Round(1)));
    }
  }

  Round _insertLastRound(Round round) {
    _db.insert(tableLastRound, {columnLastRoundId: 0, columnLastRoundRoundId: round.id},
        conflictAlgorithm: ConflictAlgorithm.replace);
    return round;
  }

  Future<Round> getRound(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(tableRound,
        columns: [columnRoundId, columnRoundDate, columnRoundCourseId, columnRoundCurrentHole],
        where: "$columnRoundId = ?",
        whereArgs: [id]);
    Round round;
    if (maps.length > 0) {
      round = Round.fromMap(maps.first);
      round.holes = await _getHoles(round);
      round.setCurrentHole();
    }
    return round;
  }

  Future<List<Hole>> _getHoles(Round round) async {
    List<Map<String, dynamic>> maps = await _db.query(tableHole,
        columns: [columnHoleId, columnHoleRoundId, columnHoleHole, columnHoleStrokeCount],
        where: "$columnHoleRoundId = ? ",
        whereArgs: [round.id]);
    var holes = List<Hole>();
    maps.forEach((record) => holes.add(Hole.fromMap(record)));
    return holes;
  }

  Round insertRound(Round round) {
    _db.insert(tableRound, round.toMap());
    round.holes.forEach((stroke) => _insertHole(stroke));
    return round;
  }

  Hole _insertHole(Hole hole) {
    _db.insert(tableHole, hole.toMap());
    return hole;
  }

  Future<int> deleteItem(IMappable item) {
    return _db.delete(item.tableName, where: "${item.idColumnName} = ?", whereArgs: [item.id]);
  }

  Future<int> updateItem(IMappable item) {
    return _db.update(item.tableName, item.toMap(), where: "${item.idColumnName} = ?", whereArgs: [item.id]);
  }
}
