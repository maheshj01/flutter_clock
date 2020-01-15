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
  DateTime dateTime;
  String hour;
  String minute;
  String second;
  String millisecond;
  String day;
  String month;
  Color red = Color(0xffdb3236);
  Color blue = Color(0xff4885ed);
  Color green = Color(0xff3cba54);
  Animation<Color> animation;
  AnimationController _backgroundController;
  AnimationController _turnController;
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.black,
      end: Colors.blueGrey[300],
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

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // print(size.width);
    return Scaffold(
      body: Center(
        child: AspectRatio(
          child: Stack(children: <Widget>[
            Container(
              color: animation.value,
              child: DrawnHand(
                color: Colors.green,
                size: 0.65,
                thickness: 4,
                angleRadians: (math.pi / 30) * double.parse(second),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: size.width > 600 ? EdgeInsets.all(20) : null,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: size.width < 400 ? 10 : 40, color: Colors.white),
                  borderRadius: BorderRadius.circular(40)),
            ),
            // size.width < 400
            //     ? Container()
            //     : Container(
            //         margin: EdgeInsets.only(bottom: 5),
            //         alignment: Alignment.bottomCenter,
            //         child: FlutterLogo(
            //           size: 30,
            //         ),
            //       ),
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
                  Text("$hour : $minute",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 50, fontFamily: 'Rajdhani', color: blue)),
                  Text("$second",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 100,
                        color: red,
                        fontFamily: 'Rajdhani',
                      )),
                  Text(DateFormat('EE, d MMM, yyyy').format(dateTime))
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
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
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
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;

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
    @required this.color,
    @required this.size,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null);

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
