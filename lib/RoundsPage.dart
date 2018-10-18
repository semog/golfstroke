import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/Constants.dart';
import 'package:golfstroke/LoadingPage.dart';
import 'package:golfstroke/database/DbUtils.dart';
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
  var _listViewController = ScrollController();
  bool _showFAB = true;

  @override
  void initState() {
    super.initState();
    _listViewController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _listViewController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    _showFAB = (_listViewController.position.userScrollDirection == ScrollDirection.forward);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!dbInitialized) {
      return loadingPage;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: _roundsList,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildFAB(BuildContext context) {
    if (!_showFAB) {
      return Container();
    }
    return FloatingActionButton(
      onPressed: () {
        appDb.lastRound.value = appDb.createRound().id;
        Navigator.of(context).pushNamed(currentRoundPageRoute);
      },
      tooltip: 'Add New Round',
      child: Icon(
        Icons.add_circle_outline,
        color: Colors.blue[300],
        size: 50.0,
      ),
      backgroundColor: Colors.black,
      elevation: 2.0,
    );
  }

  Widget get _roundsList {
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
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 30.0),
      controller: _listViewController,
      itemCount: appDb.rounds.length,
      itemBuilder: (context, index) {
        Round round = appDb.rounds[index];
        return ListTile(
          contentPadding: EdgeInsets.all(0.0),
          leading: Icon(
            Icons.golf_course,
            size: 35.0,
            color: Colors.blue[200],
          ),
          title: Text(
            "Round ${_dateFormatter.format(round.date)}",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Score: ${round.currentScore} (${round.rating}/${round.slope})",
            style: TextStyle(color: Colors.blueGrey[300]),
          ),
          onTap: () {
            appDb.lastRound.value = round.id;
            Navigator.of(context).pushNamed(currentRoundPageRoute);
          },
          onLongPress: () {
            // TODO: Option to delete or edit (slope/rating) round
          },
        );
      },
    );
  }
}
