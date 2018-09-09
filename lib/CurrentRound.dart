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
    return Scaffold(
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
                    '${round.currentStrokeCount}',
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
                    fmtHoleNum(round.currentHoleNum),
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
