/*
 * File: digital_clock.dart
 * Project: Flutter Clock Challenge
 * File Created: Saturday, 30th November 2019 2:48:56 pm
 * Author: Mahesh Jamdade
 * -----
 * Last Modified: Saturday, 30th November 2019 7:11:04 pm
 * -----
 */

import 'package:flutter/material.dart';

import 'myclock.dart';

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
        home: MyFlutterClock());
  }
}
