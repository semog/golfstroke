import 'package:golfstroke/Hole.dart';
import 'package:golfstroke/IMappable.dart';
import 'package:golfstroke/constants.dart';
import 'package:golfstroke/dbutils.dart';

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
    _currentHoleIndex = index;
    // Wrap the index around the array bounds.
    if (_currentHoleIndex >= maxHoles) {
      _currentHoleIndex = 0;
    } else if (_currentHoleIndex < 0) {
      _currentHoleIndex = maxHoles - 1;
    }
    setCurrentHole();
    save();
  }

  int get currentStrokeCount => currentHole.strokes;
  int get currentHoleNum => currentHole.hole;

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
