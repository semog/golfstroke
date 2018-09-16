import 'package:golfstroke/database/DbProvider.dart';
import 'package:golfstroke/utils.dart';

final String databaseStrokeCounts = "strokecounts.db";

final String tableVersion = "versioninfo";
final String columnVersion = "version";

final String tableRound = "rounds";
final String columnRoundId = "_id";
final String columnRoundCourseId = "courseId";
final String columnRoundDate = "date";

final String tableLastRound = "lastround";
final String columnLastRoundId = "_id";
final String columnLastRoundRoundId = "roundId";
final String columnRoundCurrentHole = "currentHole";

final String tableHole = "holes";
final String columnHoleId = "_id";
final String columnHoleRoundId = "roundId";
final String columnHoleHole = "hole";
final String columnHoleStrokeCount = "strokes";

final String indexHoleRoundHole = "holeroundholeIdx";

// TODO: Retrieve Id from database.
int _nextId = totalMilliseconds(DateTime.now());
int getId() => _nextId++;

DbProvider appDb;
