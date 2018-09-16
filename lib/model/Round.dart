import 'dart:math';

import 'package:golfstroke/constants.dart';
import 'package:golfstroke/database/dbutils.dart';
import 'package:golfstroke/model/Hole.dart';
import 'package:golfstroke/model/IMappable.dart';

class Round implements IMappable {
  String tableName = tableRound;
  String idColumnName = columnRoundId;
  int id;
  DateTime date;
  int courseId;
  List<Hole> holes;
  Hole currentHole;
  int _currentHoleIndex = 0;
  int get currentHoleIndex => _currentHoleIndex;
  set currentHoleIndex(int index) {
    _currentHoleIndex = min(max(0, index), maxHoles - 1);
    setCurrentHole();
    save();
  }

  int get currentStrokeCount => currentHole.strokes;
  int get currentHoleNum => currentHole.hole;
  int get currentScore {
    int accumulator = 0;
    holes.getRange(0, currentHoleIndex + 1).forEach((x) => accumulator += x.strokes);
    return accumulator;
  }

  Round(int ownerCourseId) {
    id = getId();
    date = DateTime.now();
    courseId = ownerCourseId;
    int holeNum = 1;
    holes = List<Hole>.generate(maxHoles, (_) => Hole(id, holeNum++));
    setCurrentHole();
  }

  Round.fromMap(Map<String, dynamic> map) {
    id = map[columnRoundId];
    date = DateTime.tryParse(map[columnRoundDate]);
    courseId = map[columnRoundCourseId];
    _currentHoleIndex = map[columnRoundCurrentHole];
  }

  Map<String, dynamic> toMap() {
    return {
      columnRoundId: id,
      columnRoundDate: date.toIso8601String(),
      columnRoundCourseId: courseId,
      columnRoundCurrentHole: _currentHoleIndex
    };
  }

  void setCurrentHole() => currentHole = holes[_currentHoleIndex];
  void save() {
    appDb.updateItem(this);
  }
}
