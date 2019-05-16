import 'package:flutter/material.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/Round.dart';

abstract class BaseRoundPageState<T extends StatefulWidget> extends AmbientModeState<T> {
  bool _loadedData = false;
  Round round;

  bool get _initialized => null != round;
  final buttonColor = Colors.blue[300];
  Color hideableColor(Color color) => isAmbient ? Colors.black : color;

  BaseRoundPageState() : super.stayOnAmbient();

  bool loadData() {
    if (!_loadedData && dbInitialized) {
      _loadedData = true;
      setState(() => round = appDb.getRound(appDb.lastRound.value));
    }
    return _initialized;
  }
}
