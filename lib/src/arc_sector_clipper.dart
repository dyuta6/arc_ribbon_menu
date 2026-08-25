import 'dart:math' as math;
import 'package:flutter/material.dart';

class ArcSectorClipper extends CustomClipper<Path> {
  final double rIn;
  final double rOut;
  final double dTheta;
  final double cxLocal;
  final double cyLocal;

  ArcSectorClipper({
    required this.rIn,
    required this.rOut,
    required this.dTheta,
    required this.cxLocal,
    required this.cyLocal,
  });

  @override
  Path getClip(Size size) {
    final tlX = cxLocal + rIn * math.cos(dTheta / 2);
    final tlY = cyLocal - rIn * math.sin(dTheta / 2);

    final trX = cxLocal + rOut * math.cos(dTheta / 2);
    final trY = cyLocal - rOut * math.sin(dTheta / 2);

    final brX = cxLocal + rOut * math.cos(dTheta / 2);
    final brY = cyLocal + rOut * math.sin(dTheta / 2);

    final blX = cxLocal + rIn * math.cos(dTheta / 2);
    final blY = cyLocal + rIn * math.sin(dTheta / 2);

    final path = Path();
    path.moveTo(tlX, tlY);
    path.lineTo(trX, trY);
    path.arcToPoint(
      Offset(brX, brY),
      radius: Radius.circular(rOut),
      clockwise: true,
    );
    path.lineTo(blX, blY);
    path.arcToPoint(
      Offset(tlX, tlY),
      radius: Radius.circular(rIn),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant ArcSectorClipper oldClipper) {
    return oldClipper.rIn != rIn ||
        oldClipper.rOut != rOut ||
        oldClipper.dTheta != dTheta ||
        oldClipper.cxLocal != cxLocal ||
        oldClipper.cyLocal != cyLocal;
  }
}
