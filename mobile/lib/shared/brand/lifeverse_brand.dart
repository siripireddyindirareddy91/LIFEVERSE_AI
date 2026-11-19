import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tokens.dart';

/// An open orbit, a rising path and a north star: an original code-native mark.
class LifeverseMark extends StatelessWidget {
  const LifeverseMark({this.size = 40, this.monochrome = false, super.key});
  final double size;
  final bool monochrome;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'LIFEVERSE AI',
    image: true,
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: BrandMarkPainter(
          monochrome ? Theme.of(context).colorScheme.onSurface : Aurora.orchid,
          monochrome ? Theme.of(context).colorScheme.onSurface : Aurora.teal,
        ),
      ),
    ),
  );
}

class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter(this.orbit, this.spark);
  final Color orbit;
  final Color spark;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    final stroke = Paint()
      ..color = orbit
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      const Rect.fromLTWH(14, 18, 66, 66),
      -.15 * math.pi,
      1.68 * math.pi,
      false,
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(37, 37)
        ..lineTo(37, 65)
        ..quadraticBezierTo(37, 69, 42, 69)
        ..lineTo(62, 69),
      stroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(77, 12)
        ..quadraticBezierTo(79, 27, 92, 30)
        ..quadraticBezierTo(79, 32, 77, 46)
        ..quadraticBezierTo(75, 32, 62, 30)
        ..quadraticBezierTo(75, 27, 77, 12)
        ..close(),
      Paint()..color = spark,
    );
    canvas.drawCircle(const Offset(19, 76), 4, Paint()..color = spark);
    canvas.restore();
  }

  @override
  bool shouldRepaint(BrandMarkPainter oldDelegate) =>
      oldDelegate.orbit != orbit || oldDelegate.spark != spark;
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const ExcludeSemantics(child: LifeverseMark(size: 36)),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          'LIFEVERSE AI',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
    ],
  );
}
