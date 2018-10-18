import 'package:flutter/material.dart';
import 'package:golfstroke/RoundsPage.dart';
import 'package:golfstroke/database/DbProvider.dart';
import 'package:golfstroke/database/DbUtils.dart';
import 'package:golfstroke/model/IStateUpdate.dart';

void main() => runApp(GolfStrokeApp());

class GolfStrokeApp extends StatefulWidget {
  @override
  _GolfStrokeAppState createState() => _GolfStrokeAppState();
}

class _GolfStrokeAppState extends State<GolfStrokeApp> implements IStateUpdate {
  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  @override
  void dispose() {
    _closeDatabase();
    super.dispose();
  }

  DbProvider dbLoader;

  void _openDatabase() async {
    dbLoader = await DbProvider.open(this);
  }

  void _closeDatabase() => appDb?.close();

  @override
  void updateState() {
    if (dbLoader?.allHolesLoaded ?? false) {
      setState(() => appDb = dbLoader);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Strokes',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: RoundsPage(),
    );
  }
}
