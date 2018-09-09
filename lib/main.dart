import 'package:flutter/material.dart';
import 'package:golfstroke/CurrentRound.dart';
import 'package:golfstroke/DbProvider.dart';
import 'package:golfstroke/dbutils.dart';

void main() => runApp(StrokeCountApp());

class StrokeCountApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _StrokeCountAppState createState() => _StrokeCountAppState();
}

class _StrokeCountAppState extends State<StrokeCountApp> {
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
