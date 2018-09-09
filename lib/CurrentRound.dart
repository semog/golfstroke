import 'package:flutter/material.dart';
import 'package:golfstroke/Hole.dart';
import 'package:golfstroke/Round.dart';
import 'package:golfstroke/constants.dart';
import 'package:golfstroke/dbutils.dart';
import 'package:golfstroke/utils.dart';

class CurrentRoundPage extends StatefulWidget {
  @override
  _CurrentRoundPageState createState() => _CurrentRoundPageState();
}

class _CurrentRoundPageState extends State<CurrentRoundPage> {
  bool _loadedData = false;
  Round round;
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
    currentHole = round?.holes[_currentHoleIndex];
  }

  Hole currentHole;
  bool get initialized => null != round;
  int get currentStrokeCount => currentHole?.strokes ?? 0;
  int get currentHoleNum => currentHole?.hole ?? 0;

  void _loadData() {
    if (!_loadedData && null != appDb) {
      _loadedData = true;
      appDb.getLastRound().then((roundArg) => setState(() {
            round = roundArg;
            currentHoleIndex = 0;
          }));
    }
  }

  void _incrementStrokes() {
    if (initialized) {
      setState(() {
        currentHole.strokes++;
        appDb.updateItem(currentHole);
      });
    }
  }

  void _decrementStrokes() {
    if (initialized) {
      setState(() {
        currentHole.strokes--;
        appDb.updateItem(currentHole);
      });
    }
  }

  void _nextHole() {
    if (initialized) {
      setState(() {
        currentHoleIndex++;
        appDb.updateItem(currentHole);
      });
    }
  }

  void _previousHole() {
    if (initialized) {
      setState(() {
        currentHoleIndex--;
        appDb.updateItem(currentHole);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return new Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    iconSize: 50.0,
                    color: Colors.green[200],
                    onPressed: _decrementStrokes,
                  ),
                  Text(
                    '$currentStrokeCount',
                    style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    iconSize: 50.0,
                    color: Colors.green,
                    onPressed: _incrementStrokes,
                  ),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: 50.0,
                color: Colors.blue[300],
                onPressed: _previousHole,
              ),
              Column(
                children: <Widget>[
                  Text(
                    fmtHoleNum(currentHoleNum),
                    style: TextStyle(fontSize: 25.0, color: Colors.blueGrey[300]),
                  ),
                  Text(
                    'Hole',
                    style: TextStyle(fontSize: 18.0, color: Colors.blueGrey[300]),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                iconSize: 50.0,
                color: Colors.blue,
                onPressed: _nextHole,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
