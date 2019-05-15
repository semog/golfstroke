import 'package:flutter/cupertino.dart';
import 'package:golfstroke/Constants.dart';
import 'package:golfstroke/CurrentRoundPage.dart';
import 'package:golfstroke/RoundsPage.dart';
import 'package:golfstroke/EditRoundPage.dart';

var routes = <String, WidgetBuilder>{
  roundsPageRoute: (context) => RoundsPage(),
  currentRoundPageRoute: (context) => CurrentRoundPage(),
  editRoundPageRoute: (context) => EditRoundPage(),
};
