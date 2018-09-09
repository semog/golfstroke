import 'package:golfstroke/Hole.dart';
import 'package:golfstroke/IMappable.dart';
import 'package:golfstroke/constants.dart';
import 'package:golfstroke/dbutils.dart';

class Round implements IMappable {
  String tableName = tableRound;
  String idColumnName = columnRoundId;
  int id;
  int courseId;
  DateTime date;
  List<Hole> holes;

  Round(int ownerCourseId) {
    id = getId();
    courseId = ownerCourseId;
    date = DateTime.now();
    int holeNum = 1;
    holes = List<Hole>.generate(maxHoles, (_) => Hole(id, holeNum++));
  }

  Round.fromMap(Map<String, dynamic> map) {
    id = map[columnRoundId];
    courseId = map[columnRoundCourseId];
    date = DateTime.tryParse(map[columnRoundDate]);
  }

  Map<String, dynamic> toMap() {
    return {
      columnRoundId: id,
      columnRoundCourseId: courseId,
      columnRoundDate: date.toIso8601String()
    };
  }
}
