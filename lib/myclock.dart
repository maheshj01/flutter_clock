import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class MyFlutterClock extends StatefulWidget {
  @override
  _MyFlutterClockState createState() => _MyFlutterClockState();
}

class _MyFlutterClockState extends State<MyFlutterClock>
    with TickerProviderStateMixin {
  late DateTime dateTime;
  late String hour;
  late String minute;
  late String second;
  late String millisecond;
  late String day;
  late String month;
  late Animation<Color?> animation;
  late AnimationController _backgroundController;
  Color endColor = Color(0xfff5af19);
  Color beginColor = Color(0xfff12711);

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blue[50],
      end: Colors.orange,
    ).animate(_backgroundController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _backgroundController.reverse().whenComplete(() {
            _backgroundController.reset();
            _backgroundController.forward();
          });
        }
      });
    _backgroundController.forward();
    _updateTimer();
  }

//
  void _updateTimer() {
    setState(() {
      dateTime = DateTime.now();
      hour = dateTime.hour.toString();
      minute = dateTime.minute.toString();
      second = dateTime.second.toString();
      millisecond = dateTime.millisecond.toString();
      day = dateTime.day.toString();
    });
    Timer(Duration(milliseconds: 100), _updateTimer);
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffff4B2B), Color(0xffff4B2B)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // print(size.height);
    return Scaffold(
      body: Center(
        child: AspectRatio(
          child: Stack(children: <Widget>[
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  height: size.width > 400 ? 40 : 30,
                  width: size.width > 400 ? 40 : 30,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                        beginColor,
                        endColor,
                        Colors.blue,
                        Colors.white
                      ]),
                      borderRadius: BorderRadius.circular(
                        size.width > 400 ? 40 : 30,
                      )),
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: DrawnHand(
                color: animation.value!,
                size: 0.65,
                thickness: size.width < 400 ? 6 : 10,
                angleRadians: (math.pi / 30) * double.parse(second),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: size.width > 600 ? EdgeInsets.all(20) : null,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: size.width < 400 ? 10 : 30,
                      color: animation.value!),
                  borderRadius:
                      BorderRadius.circular(size.width < 400 ? 40 : 80)),
            ),
            Container(
              alignment: Alignment.center,
              child: FlareActor(
                "assets/waterdrop.flr",
                color: Colors.white,
                alignment: Alignment.center,
                fit: BoxFit.cover,
                isPaused: false,
                animation: "water_drop",
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: hour,
                        style: TextStyle(
                          fontSize:
                              size.width > 600 ? size.width / 4 * 0.18 : 40,
                          fontFamily: 'Rajdhani',
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          // foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      TextSpan(
                        text: ' : ',
                        style: TextStyle(
                          fontSize:
                              size.width > 600 ? size.width / 4 * 0.18 : 40,
                          fontFamily: 'Rajdhani',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      TextSpan(
                        text: minute,
                        style: TextStyle(
                          fontSize:
                              size.width > 600 ? size.width / 4 * 0.18 : 40,
                          fontFamily: 'Rajdhani',
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          // foreground: Paint()..shader = linearGradient,
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("$second",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                size.width > 600 ? size.width / 4 * 0.3 : 60,
                            color: Colors.white,
                            fontFamily: 'Rajdhani',
                            letterSpacing: 5,
                            shadows: [])),
                  ),
                  SizedBox(height: 20),
                  Text(
                    DateFormat(
                      'EE, d MMM, yyyy',
                    ).format(dateTime),
                    style: TextStyle(
                        color: Colors.blue[200],
                        fontSize: 18,
                        fontFamily: 'Rajdhani',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ]),
          aspectRatio: 5 / 3,
        ),
      ),
    );
  }
}

class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    required Color color,
    required this.thickness,
    required double size,
    required double angleRadians,
  })  : super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    required this.handSize,
    required this.lineWidth,
    required this.angleRadians,
    required this.color,
  })  : assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    var rect = Offset.zero & size;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;
    // linePaint.shader = LinearGradient(
    //     begin: Alignment.centerLeft,
    //     end: Alignment.centerRight,
    //     colors: [
    //       Colors.greenAccent,
    //       Colors.orange,
    //     ]).createShader(rect);
    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}

abstract class Hand extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const Hand({
    required this.color,
    required this.size,
    required this.angleRadians,
  });

  /// Hand color.
  final Color color;

  /// Hand length, as a percentage of the smaller side of the clock's parent
  /// container.
  final double size;

  /// The angle, in radians, at which the hand is drawn.
  ///
  /// This angle is measured from the 12 o'clock position.
  final double angleRadians;
}
