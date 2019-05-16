import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:golfstroke/BaseRoundPage.dart';
import 'package:golfstroke/LoadingPage.dart';

class EditRoundPage extends StatefulWidget {
  @override
  _EditRoundPageState createState() => _EditRoundPageState();
}

class _EditRoundPageState extends BaseRoundPageState<EditRoundPage> {
  final double _incdecIconSize = 40.0;
  final double _slopeFontSize = 40.0;
  final double _ratingFontSize = 40.0;

  void _incrementSlope() => setState(() => round.slope++);
  void _decrementSlope() => setState(() => round.slope--);

  // Increment/decrement rating by tenths.
  void _incrementRating() => setState(() => round.rating += 0.1);
  void _decrementRating() => setState(() => round.rating -= 0.1);

  @override
  Widget build(BuildContext context) {
    if (!loadData()) {
      return loadingPage;
    }
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // TODO: Add ability to change Round Name from "Round <date>".
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "${round.name}",
                  style: TextStyle(color: Colors.blueGrey[300]),
                ),
              ),
              Divider(color: Colors.blueAccent),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: _incdecIconSize,
                      color: hideableColor(buttonColor),
                      onPressed: _decrementRating,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Rating',
                        style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.blueGrey[300]),
                      ),
                      Text(
                        '${round.rating.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: _ratingFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: _incdecIconSize,
                      color: hideableColor(buttonColor),
                      onPressed: _incrementRating,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: _incdecIconSize,
                      color: hideableColor(buttonColor),
                      onPressed: _decrementSlope,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Slope',
                        style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.blueGrey[300]),
                      ),
                      Text(
                        '${round.slope}',
                        style: TextStyle(fontSize: _slopeFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      iconSize: _incdecIconSize,
                      color: hideableColor(buttonColor),
                      onPressed: _incrementSlope,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
