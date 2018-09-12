import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:golfstroke/Round.dart';
import 'package:golfstroke/dbutils.dart';
import 'package:golfstroke/utils.dart';

class CurrentRoundPage extends StatefulWidget {
  @override
  _CurrentRoundPageState createState() => _CurrentRoundPageState();
}

class _CurrentRoundPageState extends State<CurrentRoundPage> {
  bool _loadedData = false;
  Round round;

  bool get initialized => null != round;

  bool _loadData() {
    if (!_loadedData && null != appDb) {
      _loadedData = true;
      appDb.getLastRound().then((roundArg) => setState(() {
            round = roundArg;
          }));
    }
    return initialized;
  }

  void _incrementStrokes() => setState(() {
        round.currentHole.strokes++;
      });

  void _decrementStrokes() => setState(() {
        round.currentHole.strokes--;
      });

  void _nextHole() => setState(() {
        round.currentHoleIndex++;
      });

  void _previousHole() => setState(() {
        round.currentHoleIndex--;
      });

  @override
  Widget build(BuildContext context) {
    if (!_loadData()) {
      return loadingScreen;
    }
    return GestureDetector(
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
                padding: EdgeInsets.only(top: _getStrokeCountPadding()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: 50.0,
                      color: Colors.blue[300],
                      onPressed: _decrementStrokes,
                    ),
                    Text(
                      '${round.currentStrokeCount}',
                      style:
                          TextStyle(fontSize: _getStrokeFontSize(), fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: 50.0,
                      color: Colors.blue[300],
                      onPressed: _incrementStrokes,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getStrokeCountPadding() {
    if (round.currentStrokeCount > 9) {
      return 21.0;
    }
    return 1.0;
  }

  double _getStrokeFontSize() {
    if (round.currentStrokeCount > 9) {
      return 70.0;
    }
    return 105.0;
  }

  Widget get loadingScreen => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Loading...",
            style: TextStyle(fontSize: 20.0, color: Colors.blueGrey[300]),
          ),
        ),
      );
}
