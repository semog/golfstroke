import 'package:flutter/material.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/database/dbutils.dart';
import 'package:golfstroke/loadingPage.dart';
import 'package:golfstroke/model/Round.dart';
import 'package:intl/intl.dart';

class RoundsPage extends StatefulWidget {
  @override
  _RoundsPageState createState() => _RoundsPageState();
}

// TODO: Refactor the AmbientModeState base class.
// Change to encapsulated class that does optional
// event callbacks. By default pass in the State object
// so that it can call setState() by default.
class _RoundsPageState extends AmbientModeState<RoundsPage> {
  var _dateFormatter = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    if (!dbInitialized) {
      return loadingPage;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: roundsList,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var round;
          setState(() => round = appDb.createRound());

          // TODO: Navigate to CurrentRound
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add_circle_outline,
          color: Colors.blue[300],
          size: 50.0,
        ),
        backgroundColor: Colors.black,
        elevation: 2.0,
      ),
    );
  }

  Widget get roundsList {
    if (appDb.rounds.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No rounds. Press the \'+\' button below to add a new round.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: appDb.rounds.length,
      itemBuilder: (context, index) {
        Round round = appDb.rounds[index];
        return ListTile(
          leading: Icon(
            Icons.golf_course,
            color: Colors.blue[200],
          ),
          title: Text(
            "Round ${_dateFormatter.format(round.date)}",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "${round.currentScore} (${round.rating}/${round.slope})",
            style: TextStyle(color: Colors.blueGrey[300]),
          ),
          onTap: () {
            appDb.lastRound.value = round.id;
            // TODO: Navigate to CurrentRound
          },
          onLongPress: () {
            // TODO: Option to delete or edit (slope/rating) round
          },
        );
      },
    );
  }
}
