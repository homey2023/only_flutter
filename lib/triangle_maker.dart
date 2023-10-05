import 'package:flutter/material.dart';

class Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}



class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width / 2, 0),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LinePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.1;

    canvas.drawLine(
      Offset(size.width / 2, size.height * (2 / 3)),
      Offset(size.width / 2, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, size.height * (2 / 3)),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, size.height * (2 / 3)),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
