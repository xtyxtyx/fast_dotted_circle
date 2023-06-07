import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

late final FragmentProgram dottedCircleProgram;

void main() async {
  dottedCircleProgram = await FragmentProgram.fromAsset(
    'shaders/dotted_circle.frag',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var radius = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Slider(
            value: radius,
            min: 10,
            max: 2000,
            onChanged: (value) {
              setState(() => radius = value);
            },
          ),
          CustomPaint(
            painter: DemoPainter(
              dottedCircleProgram,
              radius: radius,
              dashSize: 1,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class DemoPainter extends CustomPainter {
  DemoPainter(
    this.program, {
    required this.radius,
    required this.dashSize,
    required this.color,
  });

  final FragmentProgram program;

  final double radius;

  final double dashSize;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();

    // uniform float uRadius;
    shader.setFloat(0, radius);
    
    // uniform float uDashAngle;
    final dashAngle = 2 * pi / (radius / dashSize);
    shader.setFloat(1, dashAngle);

    // uniform vec3 uColor;
    shader.setFloat(2, color.red / 255 * color.opacity);
    shader.setFloat(3, color.green / 255 * color.opacity);
    shader.setFloat(4, color.blue / 255 * color.opacity);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
