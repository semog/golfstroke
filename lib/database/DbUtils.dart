import 'package:golfstroke/database/DbProvider.dart';
import 'package:golfstroke/utils.dart';

const String databaseStrokeCounts = "strokecounts.db";

const String tableVersion = "versioninfo";
const String columnVersion = "version";

const String tableSetting = "settings";
const String columnSettingId = "_id";
const String columnSettingName = "name";
const String columnSettingValue = "value";
const String indexSettingName = "settingnameIdx";

const String tableRound = "rounds";
const String columnRoundId = "_id";
const String columnRoundDate = "date";
const String columnRoundSlope = "slope";
const String columnRoundRating = "rating";
const String columnRoundCurrentHole = "currentHole";

const String tableHole = "holes";
const String columnHoleId = "_id";
const String columnHoleRoundId = "roundId";
const String columnHoleHole = "hole";
const String columnHoleStrokeCount = "strokes";
const String indexHoleRoundId = "holeroundidIdx";

///  Settings
const String settingLastSlope = "lastslope";
const String settingLastRating = "lastrating";
const String settingLastRound = "lastround";

// TODO: Retrieve Id from database.
int _nextId = totalMilliseconds(DateTime.now());
int getId() => _nextId++;

DbProvider appDb;
bool get dbInitialized => null != appDb;
