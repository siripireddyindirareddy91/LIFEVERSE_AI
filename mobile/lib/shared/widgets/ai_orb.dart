import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tokens.dart';

enum OrbState {
  idle('Idle'),
  listening('Listening'),
  understanding('Understanding'),
  thinking('Thinking'),
  planning('Planning'),
  executing('Executing'),
  awaitingApproval('Awaiting approval'),
  completed('Completed'),
  error('Error');

  const OrbState(this.label);
  final String label;
}

class AIOrb extends StatefulWidget {
  const AIOrb({
    this.state = OrbState.idle,
    this.size = 160,
    this.animate = true,
    this.onPressed,
    super.key,
  });
  final OrbState state;
  final double size;
  final bool animate;
  final VoidCallback? onPressed;
  @override
  State<AIOrb> createState() => _AIOrbState();
}

class _AIOrbState extends State<AIOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );

  void _syncMotion() {
    final reduced =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final shouldAnimate = widget.animate && !reduced && TickerMode.of(context);
    _controller.duration = Duration(
      seconds: widget.state == OrbState.idle ? 8 : 4,
    );
    if (shouldAnimate) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = .125;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(AIOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) _controller.stop();
    _syncMotion();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orb = SizedBox.square(
      dimension: widget.size,
      child: CustomPaint(
        painter: _OrbPainter(
          phase: _controller,
          state: widget.state,
          error: Theme.of(context).colorScheme.error,
        ),
        child: Center(
          child: switch (widget.state) {
            OrbState.awaitingApproval => const Icon(
              Icons.pause_rounded,
              color: Aurora.light,
              size: 28,
            ),
            OrbState.completed => const Icon(
              Icons.check_rounded,
              color: Aurora.light,
              size: 28,
            ),
            OrbState.error => const Icon(
              Icons.close_rounded,
              color: Aurora.light,
              size: 28,
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
    return Semantics(
      label: 'LIFEVERSE AI orb. ${widget.state.label}',
      hint: widget.onPressed == null ? null : 'Open AI space information',
      button: widget.onPressed != null,
      image: widget.onPressed == null,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: widget.onPressed == null
          ? orb
          : Tooltip(
              message: 'Open AI space',
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  child: orb,
                ),
              ),
            ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({required this.phase, required this.state, required this.error})
    : super(repaint: phase);
  final Animation<double> phase;
  final OrbState state;
  final Color error;

  Color get accent => switch (state) {
    OrbState.listening || OrbState.completed => Aurora.teal,
    OrbState.awaitingApproval || OrbState.planning => Aurora.amber,
    OrbState.error => error,
    OrbState.understanding => Aurora.rose,
    _ => Aurora.orchid,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final angle = phase.value * math.pi * 2;
    final breath = 1 + math.sin(angle) * .035;
    final coreRadius = radius * .62 * breath;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent.withValues(alpha: .32),
            accent.withValues(alpha: .08),
            accent.withValues(alpha: 0),
          ],
          stops: const [0, .65, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.4, -.5),
          radius: 1.3,
          colors: [Aurora.mist, accent, Aurora.plum, Aurora.voidColor],
          stops: const [0, .22, .68, 1],
        ).createShader(Rect.fromCircle(center: center, radius: coreRadius)),
    );
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8
        ..color = Aurora.light.withValues(alpha: .45),
    );
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle * .25 + i * math.pi / 3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: radius * 1.7,
          height: radius * .7,
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = (i == 1 ? Aurora.teal : accent).withValues(alpha: .6),
      );
      canvas.restore();
    }
    final outer = Rect.fromCircle(center: center, radius: radius * .87);
    final line = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    switch (state) {
      case OrbState.listening:
        for (var i = 0; i < 20; i++) {
          final a = i * math.pi / 10;
          final length = radius * (.04 + .09 * (1 + math.sin(angle * 2 + i)));
          final direction = Offset(math.cos(a), math.sin(a));
          canvas.drawLine(
            center + direction * radius * .76,
            center + direction * (radius * .76 + length),
            line,
          );
        }
      case OrbState.planning:
        final points = [
          for (var i = 0; i < 5; i++)
            center +
                Offset(
                      math.cos(i * math.pi * .4 - angle * .2),
                      math.sin(i * math.pi * .4 - angle * .2),
                    ) *
                    radius *
                    .84,
        ];
        for (var i = 0; i < points.length; i++) {
          canvas.drawLine(
            points[i],
            points[(i + 2) % points.length],
            line..color = accent.withValues(alpha: .4),
          );
          canvas.drawCircle(points[i], 3, Paint()..color = accent);
        }
      case OrbState.awaitingApproval:
        for (var i = 0; i < 12; i++) {
          canvas.drawArc(outer, i * math.pi / 6, math.pi / 12, false, line);
        }
      case OrbState.executing:
        canvas.drawArc(
          outer,
          angle,
          math.pi * 1.5,
          false,
          line..strokeWidth = 3,
        );
      case OrbState.thinking || OrbState.understanding:
        for (var i = 0; i < 3; i++) {
          final a = angle + i * math.pi * 2 / 3;
          canvas.drawCircle(
            center + Offset(math.cos(a), math.sin(a)) * radius * .87,
            3,
            Paint()..color = i == 1 ? Aurora.teal : accent,
          );
        }
      case OrbState.completed || OrbState.error:
        canvas.drawCircle(center, radius * .85, line);
      case OrbState.idle:
        final point =
            center + Offset(math.cos(angle), math.sin(angle)) * radius * .85;
        canvas.drawCircle(point, 2.5, Paint()..color = Aurora.teal);
    }
    if (![
      OrbState.awaitingApproval,
      OrbState.completed,
      OrbState.error,
    ].contains(state)) {
      final shine = center + Offset(-coreRadius * .3, -coreRadius * .4);
      canvas.drawCircle(
        shine,
        radius * .06,
        Paint()..color = Aurora.light.withValues(alpha: .75),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) =>
      state != oldDelegate.state ||
      phase != oldDelegate.phase ||
      error != oldDelegate.error;
}
