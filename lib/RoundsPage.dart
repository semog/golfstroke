import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:golfstroke/AmbientModeState.dart';
import 'package:golfstroke/Constants.dart';
import 'package:golfstroke/LoadingPage.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/Round.dart';

class RoundsPage extends StatefulWidget {
  @override
  _RoundsPageState createState() => _RoundsPageState();
}

// TODO: Refactor the AmbientModeState base class.
// Change to encapsulated class that does optional
// event callbacks. By default pass in the State object
// so that it can call setState() by default.
class _RoundsPageState extends AmbientModeState<RoundsPage> {
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
    var direction = _listViewController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      setState(() => _showFAB = true);
    } else if (direction == ScrollDirection.reverse) {
      setState(() => _showFAB = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!dbInitialized) {
      return loadingPage;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildRoundsList(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: _showFAB,
        child: FloatingActionButton(
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
        ),
      ),
    );
  }

  Map<DismissDirection, double> _dismissThresholds() {
    Map<DismissDirection, double> map = new Map<DismissDirection, double>();
    map.putIfAbsent(DismissDirection.horizontal, () => 0.3);
    return map;
  }

  Widget _buildRoundsList(BuildContext context) {
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
        return Dismissible(
          key: Key(round.id.toString()),
          direction: DismissDirection.horizontal,
          dismissThresholds: _dismissThresholds(),
          onDismissed: (direction) {
            // Remove the item
            setState(() {
              _showFAB = true;
              appDb.deleteRound(round);
            });
            // Show a snackbar.
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    "${round.name} deleted",
                    textAlign: TextAlign.center,
                  ),
                ),
                duration: Duration(seconds: 1),
              ),
            );
          },
          // Show a red background with trash can icon as the item is swiped away
          background: Container(
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.delete,
                    size: 50.0,
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.only(right: 45.0),
                ),
              ],
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            leading: Icon(
              Icons.golf_course,
              size: 35.0,
              color: Colors.blue[200],
            ),
            title: Text(
              round.name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Score: ${round.currentScore} (${round.rating.toStringAsFixed(1)}/${round.slope})",
              style: TextStyle(color: Colors.blueGrey[300]),
            ),
            onTap: () {
              appDb.lastRound.value = round.id;
              Navigator.of(context).pushNamed(currentRoundPageRoute);
            },
            onLongPress: () {
              appDb.lastRound.value = round.id;
              Navigator.of(context).pushNamed(editRoundPageRoute);
            },
          ),
        );
      },
    );
  }
}
