import 'dart:math';

import 'package:golfstroke/IMappable.dart';
import 'package:golfstroke/dbutils.dart';

class Hole implements IMappable {
  String tableName = tableHole;
  String idColumnName = columnHoleId;
  int id;
  int roundId;
  int hole;
  int _strokes;
  int get strokes => _strokes;
  set strokes(int newStrokes) => _strokes = max(newStrokes, 0);

  Hole(int ownerRoundId, int holeNum) {
    id = getId();
    roundId = ownerRoundId;
    hole = holeNum;
    strokes = 0;
  }

  Hole.fromMap(Map<String, dynamic> map) {
    id = map[columnHoleId];
    roundId = map[columnHoleRoundId];
    hole = map[columnHoleHole];
    strokes = map[columnHoleStrokeCount];
  }

  Map<String, dynamic> toMap() {
    return {columnHoleId: id, columnHoleRoundId: roundId, columnHoleHole: hole, columnHoleStrokeCount: strokes};
  }
}
