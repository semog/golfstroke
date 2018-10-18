import 'package:golfstroke/database/DbProvider.dart';

abstract class IDbStateUpdate {
  void updateState(DbProvider db);
}
