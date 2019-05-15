import 'package:flutter/material.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/Round.dart';

abstract class BaseRoundPageState<T extends StatefulWidget> extends AmbientModeState<T> {
  bool _loadedData = false;
  Round round;

  bool get _initialized => null != round;

  BaseRoundPageState() : super.stayOnAmbient();

  bool loadData() {
    if (!_loadedData && dbInitialized) {
      _loadedData = true;
      setState(() => round = appDb.getRound(appDb.lastRound.value));
    }
    return _initialized;
  }
}
