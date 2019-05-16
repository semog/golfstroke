import 'dart:math';

import 'package:golfstroke/Constants.dart';
import 'package:golfstroke/Utils.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/Hole.dart';
import 'package:golfstroke/model/IMappable.dart';

class Round implements IMappable {
  String tableName = tableRound;
  String idColumnName = columnRoundId;
  int id;
  DateTime date;
  int _slope;
  int get slope => _slope;
  set slope(int newSlope) {
    _slope = max(newSlope, 1);
    appDb.lastSlope.value = _slope;
    appDb.save(this);
  }
  double _rating;
  double get rating => _rating;
  set rating(double newRating){
    _rating = max(newRating, 1.0);
    appDb.lastRating.value = _rating;
    appDb.save(this);
  }
  List<Hole> holes;

  String get name => "Round ${dateFormatter.format(date)}";
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
    _slope = appDb.lastSlope.value;
    _rating = appDb.lastRating.value;
    holes = List<Hole>.generate(maxHoles, (index) => Hole(this, index + 1));
    setCurrentHole();
  }

  Round.fromMap(Map<String, dynamic> map) {
    id = map[idColumnName];
    date = DateTime.tryParse(map[columnRoundDate]);
    _slope = map[columnRoundSlope];
    _rating = map[columnRoundRating];
    _currentHoleIndex = map[columnRoundCurrentHole];
  }

  Map<String, dynamic> toMap() => {
        columnRoundId: id,
        columnRoundDate: date.toIso8601String(),
        columnRoundSlope: _slope,
        columnRoundRating: _rating,
        columnRoundCurrentHole: _currentHoleIndex,
      };

  void setCurrentHole() => currentHole = holes[_currentHoleIndex];
}
