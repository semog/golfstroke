import 'dart:async';

import 'package:golfstroke/Constants.dart';
import 'package:golfstroke/database/DbCreator.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/Hole.dart';
import 'package:golfstroke/model/IMappable.dart';
import 'package:golfstroke/model/IDbStateUpdate.dart';
import 'package:golfstroke/model/Round.dart';
import 'package:golfstroke/model/Setting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  Database _db;
  int _loadHolesCounter = -1;

  Setting<int> lastSlope;
  Setting<double> lastRating;
  Setting<int> lastRound;
  List<Round> rounds;

  static Future<DbProvider> open(IDbStateUpdate stateUpdate) async {
    DbProvider provider = DbProvider();
    String fulldbpath = join(await getDatabasesPath(), databaseStrokeCounts);
    provider._db = await openDatabase(
      fulldbpath,
      version: 1,
      onCreate: DbCreator.createDb,
      onUpgrade: DbCreator.upgradeDb,
    );
    await provider._loadSettings();
    await provider._loadRounds();
    await provider._loadHoles(stateUpdate);
    return provider;
  }

  close() => _db.close();

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
    lastSlope = await getSetting<int>(settingLastSlope, defaultSlope);
    lastRating = await getSetting<double>(settingLastSlope, defaultRating);
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
    maps.forEach((record) {
      Round round = Round.fromMap(record);
      rounds.add(round);
    });
  }

  _loadHoles(IDbStateUpdate stateUpdate) async {
    _loadHolesCounter = rounds.length;
    rounds.forEach((round) => _loadHolesForRound(round).whenComplete(() {
          _loadHolesCounter--;
          stateUpdate.updateState(this);
        }));
    // Update the state at least once in case there are no holes.
    stateUpdate.updateState(this);
  }

  _loadHolesForRound(Round round) async {
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

  bool get finishedLoading => 0 == _loadHolesCounter;

  Round getRound(int id) => rounds.firstWhere((round) => round.id == id, orElse: null);

  Round createRound() {
    var round = Round();
    save(round);
    round.holes.forEach((hole) => save(hole));
    rounds.add(round);
    return round;
  }

  deleteRound(Round round) {
    round.holes.forEach((hole) => delete(hole));
    delete(round);
    rounds.remove(round);
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
