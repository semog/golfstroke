import 'package:golfstroke/database/DbUtils.dart';
import 'package:sqflite/sqflite.dart';

class DbCreator {
  static createDb(Database db, int version) {
    db.execute('''create table $tableSetting (
$columnSettingId integer primary key,
$columnSettingName text not null,
$columnSettingValue text)''');
    db.execute("create unique index $indexSettingName on $tableSetting ($columnSettingName)");

    db.execute('''create table $tableRound (
$columnRoundId integer primary key,
$columnRoundDate text not null,
$columnRoundName text,
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

  static upgradeDb(Database db, int oldVersion, int newVersion) {
    // Perform any upgrades from old versions.
    if (1 == oldVersion && 2 == newVersion) {
      // Do updates as needed
    } else if (2 == oldVersion && 3 == newVersion) {
      // Do updates as needed
    }
  }
}
