import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

Color _getColor(double rating) {
  if (rating < 33) {
    return Colors.red;
  } else if (rating > 66) {
    return Colors.green;
  }
  return const Color(0xFFFEA900);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _rating = 70;

  String _rateText() {
    if (_rating < 33) {
      return 'Bad';
    } else if (_rating > 66) {
      return 'Excellent';
    }
    return 'Good';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How was your experience?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Text(
                _rateText(),
                key: ValueKey(_rateText()),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 300,
              width: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleEyeWidget(rating: _rating),
                        SingleEyeWidget(rating: _rating),
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: CirclePainter(rating: _rating),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Slider(
              min: 0,
              max: 100,
              value: _rating,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 8),
                foregroundColor: _getColor(_rating),
              ),
              onPressed: () {},
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SingleEyeWidget extends StatelessWidget {
  final double rating;

  const SingleEyeWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: SingleEyePainter(eyeColor: _getColor(rating)),
          ),
          RotatedBox(
            quarterTurns: 2,
            child: CustomPaint(
              painter:
                  SingleEyePainter(rating: rating, eyeColor: _getColor(rating)),
            ),
          ),
          Positioned(
            left: 30 * (rating / 100 + 1),
            child: Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _getColor(rating),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleEyePainter extends CustomPainter {
  final double? rating;
  final Color eyeColor;

  SingleEyePainter({this.rating, required this.eyeColor});

  @override
  void paint(Canvas canvas, Size size) {
    var eyeCenter = Offset(size.width / 2, size.height / 2);
    var eyeDownRadius = rating == null ? 40 : 40 * (rating! / 100);
    var path = Path()
      ..moveTo(eyeCenter.dx - 30, eyeCenter.dy)
      ..cubicTo(
        eyeCenter.dx - 30,
        eyeCenter.dy,
        eyeCenter.dx - 30,
        eyeCenter.dy + eyeDownRadius,
        eyeCenter.dx,
        eyeCenter.dy + eyeDownRadius,
      )
      ..cubicTo(
        eyeCenter.dx + 30,
        eyeCenter.dy + eyeDownRadius,
        eyeCenter.dx + 30,
        eyeCenter.dy,
        eyeCenter.dx + 30,
        eyeCenter.dy,
      );
    var eyePaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CirclePainter extends CustomPainter {
  final double rating;

  CirclePainter({required this.rating});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 16
      ..color = _getColor(rating)
      ..style = PaintingStyle.stroke;
    var backgroundPaint = Paint()
      ..strokeWidth = 16
      ..color = Colors.black12
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(0, 0), 142, backgroundPaint);
    Rect rect = Rect.fromCircle(center: const Offset(0, 0), radius: 142);
    double rad = (2 * pi * rating) / (2 * 100);
    double startRad = pi / 2;
    canvas.drawArc(rect, startRad, rad, false, paint);
    canvas.drawArc(rect, startRad, -rad, false, paint);

    var mouthCenter = const Offset(0, 50);
    var mouthDownRadius = 50 * rating / 100 - 25;
    var mouthPath = Path()
      ..moveTo(mouthCenter.dx - 60, mouthCenter.dy)
      ..cubicTo(
        mouthCenter.dx - 60,
        mouthCenter.dy,
        mouthCenter.dx - 60,
        mouthCenter.dy + mouthDownRadius,
        mouthCenter.dx,
        mouthCenter.dy + mouthDownRadius,
      )
      ..cubicTo(
        mouthCenter.dx + 60,
        mouthCenter.dy + mouthDownRadius,
        mouthCenter.dx + 60,
        mouthCenter.dy,
        mouthCenter.dx + 60,
        mouthCenter.dy,
      );
    var mouthPaint = Paint()
      ..color = _getColor(rating)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
