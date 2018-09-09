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
    return Dismissible(
      key: Key(round.currentHole.hashCode.toString()),
      direction: DismissDirection.vertical,
      onDismissed: (direction) {
        if (DismissDirection.up == direction) {
          _nextHole();
        } else if (DismissDirection.down == direction) {
          _previousHole();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
              ]),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.expand_more),
                      iconSize: 40.0,
                      color: Colors.green[200],
                      onPressed: _decrementStrokes,
                    ),
                    Text(
                      '${round.currentStrokeCount}',
                      style: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.expand_less),
                      iconSize: 60.0,
                      color: Colors.green,
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
