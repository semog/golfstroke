import 'dart:math';

import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/IMappable.dart';
import 'package:golfstroke/model/Round.dart';

class Hole implements IMappable {
  String tableName = tableHole;
  String idColumnName = columnHoleId;
  int id;
  Round round;
  int _hole;
  int get hole => _hole;
  int _strokes;
  int get strokes => _strokes;
  set strokes(int newStrokes) {
    _strokes = max(newStrokes, 0);
    appDb.save(this);
  }

  Hole(this.round, this._hole) {
    _strokes = 0;
  }

  Hole.fromMap(Round ownerRound, Map<String, dynamic> map) {
    round = ownerRound;
    id = map[idColumnName];
    _hole = map[columnHoleHole];
    _strokes = map[columnHoleStrokeCount];
  }

  Map<String, dynamic> toMap() => {
        columnHoleId: id,
        columnHoleRoundId: round.id,
        columnHoleHole: _hole,
        columnHoleStrokeCount: _strokes,
      };
}
