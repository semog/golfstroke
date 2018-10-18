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
  int slope;
  double rating;
  List<Hole> holes;

  Hole currentHole;
  int _currentHoleIndex = 0;
  int get currentHoleIndex => _currentHoleIndex;
  set currentHoleIndex(int index) {
    _currentHoleIndex = min(max(0, index), maxHoles - 1);
    setCurrentHole();
    appDb.save(this);
  }

  int get currentStrokeCount => currentHole.strokes;
  int get currentHoleNum => currentHole.hole;
  int get currentScore {
    int accumulator = 0;
    holes.getRange(0, currentHoleIndex + 1).forEach((x) => accumulator += x.strokes);
    return accumulator;
  }

  Round() {
    date = DateTime.now();
    slope = appDb.lastSlope.value;
    rating = appDb.lastRating.value;
    holes = List<Hole>.generate(maxHoles, (index) => Hole(this, index + 1));
    setCurrentHole();
  }

  Round.fromMap(Map<String, dynamic> map) {
    id = map[idColumnName];
    date = DateTime.tryParse(map[columnRoundDate]);
    slope = map[columnRoundSlope];
    rating = map[columnRoundRating];
    _currentHoleIndex = map[columnRoundCurrentHole];
  }

  Map<String, dynamic> toMap() => {
        columnRoundId: id,
        columnRoundDate: date.toIso8601String(),
        columnRoundSlope: slope,
        columnRoundRating: rating,
        columnRoundCurrentHole: _currentHoleIndex,
      };

  void setCurrentHole() => currentHole = holes[_currentHoleIndex];
}
