import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget get loadingPage => Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 20.0, color: Colors.blueGrey[300]),
        ),
      ),
    );
