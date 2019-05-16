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
  String _name;
  String get name => _name;
  set name(String newName) {
    _name = newName;
    appDb.lastName.value = _name;
    appDb.save(this);
  }
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
    _name = appDb.lastName.value ?? "Round ${dateFormatter.format(date)}";
    _slope = appDb.lastSlope.value;
    _rating = appDb.lastRating.value;
    holes = List<Hole>.generate(maxHoles, (index) => Hole(this, index + 1));
    setCurrentHole();
  }

  Round.fromMap(Map<String, dynamic> map) {
    id = map[idColumnName];
    date = DateTime.tryParse(map[columnRoundDate]);
    _name = map[columnRoundName];
    _slope = map[columnRoundSlope];
    _rating = map[columnRoundRating];
    _currentHoleIndex = map[columnRoundCurrentHole];
  }

  Map<String, dynamic> toMap() => {
        columnRoundId: id,
        columnRoundDate: date.toIso8601String(),
        columnRoundName: _name,
        columnRoundSlope: _slope,
        columnRoundRating: _rating.toStringAsFixed(1),
        columnRoundCurrentHole: _currentHoleIndex,
      };

  void setCurrentHole() => currentHole = holes[_currentHoleIndex];
}
