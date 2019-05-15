import 'package:flutter/material.dart';
import 'package:golfstroke/BaseRoundPage.dart';
import 'package:golfstroke/LoadingPage.dart';

class EditRoundPage extends StatefulWidget {
  @override
  _EditRoundPageState createState() => _EditRoundPageState();
}

class _EditRoundPageState extends BaseRoundPageState<EditRoundPage> {
  @override
  Widget build(BuildContext context) {
    if (!loadData()) {
      return loadingPage;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // TODO: Add ability to change Round Name from "Round <date>".
              // TODO: Add simple plus/minus controls for increment/decrement
              // rating and slope numbers. Rating will increment in tenths.
              // Slope will increment in whole numbers.
              Text(
                "Edit ${round.name}\nRating (${round.rating}) and\nSlope (${round.slope})",
                style: TextStyle(color: Colors.blueGrey[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
