import 'package:flutter/material.dart';
import 'package:golfstroke/CurrentRoundPage.dart';
import 'package:golfstroke/database/DbProvider.dart';
import 'package:golfstroke/database/dbutils.dart';

void main() => runApp(GolfStrokeApp());

class GolfStrokeApp extends StatefulWidget {
  @override
  _GolfStrokeAppState createState() => _GolfStrokeAppState();
}

class _GolfStrokeAppState extends State<GolfStrokeApp> {
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

  void _openDatabase() {
    DbProvider().open().then((dbArg) => setState(() {
          appDb = dbArg;
        }));
  }

  void _closeDatabase() => appDb?.close();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Strokes',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: CurrentRoundPage(),
    );
  }
}
