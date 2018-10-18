import 'package:flutter/material.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/database/dbutils.dart';
import 'package:golfstroke/loadingPage.dart';
import 'package:golfstroke/model/Round.dart';
import 'package:golfstroke/utils.dart';

class CurrentRoundPage extends StatefulWidget {
  @override
  _CurrentRoundPageState createState() => _CurrentRoundPageState();
}

class _CurrentRoundPageState extends AmbientModeState<CurrentRoundPage> {
  bool _loadedData = false;
  Round round;

  bool get _initialized => null != round;

  _CurrentRoundPageState() : super.stayOnAmbient();

  bool _loadData() {
    if (!_loadedData && dbInitialized) {
      _loadedData = true;
      setState(() => round = appDb.getRound(appDb.lastRound.value));
    }
    return _initialized;
  }

  double get _strokeCountPadding => round.currentStrokeCount > 9 ? 21.0 : 1.0;
  double get _cumulativePadding => round.currentStrokeCount > 9 ? 21.0 : 0.0;
  double get _strokeFontSize => round.currentStrokeCount > 9 ? 70.0 : 105.0;

  final _buttonColor = Colors.blue[300];

  Color _hideableColor(Color color) => isAmbient ? Colors.black : color;
  void _incrementStrokes() => setState(() => round.currentHole.strokes++);
  void _decrementStrokes() => setState(() => round.currentHole.strokes--);

  void _nextHole() => setState(() {
        round.currentHoleIndex++;
        _transitionAlignment = Alignment(0.0, 1.0);
      });

  void _previousHole() => setState(() {
        round.currentHoleIndex--;
        _transitionAlignment = Alignment(0.0, -1.0);
      });

  var _transitionAlignment = Alignment(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    if (!_loadData()) {
      return loadingPage;
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => ScaleTransition(
            child: child,
            scale: animation,
            alignment: _transitionAlignment,
          ),
      child: GestureDetector(
        key: Key(round.currentHole.hashCode.toString()),
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
            _previousHole();
          } else if (details.primaryVelocity < 0) {
            _nextHole();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          fmtHoleNum(round.currentHoleNum),
                          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.blueGrey[200]),
                        ),
                        Text(
                          'Hole',
                          style: TextStyle(fontSize: 18.0, color: Colors.blueGrey[300]),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.golf_course,
                      color: Colors.blue[200],
                      size: 35.0,
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _strokeCountPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        iconSize: 50.0,
                        color: _hideableColor(_buttonColor),
                        onPressed: _decrementStrokes,
                      ),
                      Text(
                        '${round.currentStrokeCount}',
                        style: TextStyle(fontSize: _strokeFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        iconSize: 50.0,
                        color: _hideableColor(_buttonColor),
                        onPressed: _incrementStrokes,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: _cumulativePadding),
                  child: Text(
                    'Score: ${round.currentScore}',
                    style: TextStyle(fontSize: 17.0, color: Colors.blueGrey[300]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
