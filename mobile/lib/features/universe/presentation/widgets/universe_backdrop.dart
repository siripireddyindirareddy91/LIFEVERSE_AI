import 'package:flutter/material.dart';
import '../../../../shared/theme/tokens.dart';

class UniverseBackdrop extends StatelessWidget {
  const UniverseBackdrop({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(.6, -.7),
          radius: 1.3,
          colors: dark
              ? [const Color(0xFF22152F), Aurora.voidColor]
              : [const Color(0xFFEFE8F5), Aurora.light],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _Starfield(dark))),
          ),
          child,
        ],
      ),
    );
  }
}

class _Starfield extends CustomPainter {
  const _Starfield(this.dark);
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 36; i++) {
      final x = ((i * 73 + 11) % 997) / 997 * size.width;
      final y = ((i * 137 + 43) % 991) / 991 * size.height;
      canvas.drawCircle(
        Offset(x, y),
        i % 5 == 0 ? 1.4 : .7,
        Paint()
          ..color = (dark ? Aurora.mist : Aurora.plum).withValues(
            alpha: dark ? .22 : .1,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(_Starfield oldDelegate) => oldDelegate.dark != dark;
}
