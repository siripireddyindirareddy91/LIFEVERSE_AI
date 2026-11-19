import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../shared/theme/tokens.dart';
import '../../domain/life_space.dart';

class RadialNavigation extends StatelessWidget {
  const RadialNavigation({
    required this.center,
    required this.onSelected,
    super.key,
  });
  final Widget center;
  final ValueChanged<LifeSpace> onSelected;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final largeText = MediaQuery.textScalerOf(context).scale(14) > 18;
      if (constraints.maxWidth < 330 || largeText) {
        return Column(
          children: [
            center,
            const SizedBox(height: Space.lg),
            for (final space in LifeSpace.values)
              SpaceListTile(space: space, onTap: () => onSelected(space)),
          ],
        );
      }
      final dimension = math.min(constraints.maxWidth, 480.0);
      final radius = dimension / 2 - 40;
      return Align(
        child: SizedBox.square(
          dimension: dimension,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _OrbitGuide(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              center,
              for (var i = 0; i < LifeSpace.values.length; i++)
                Positioned(
                  left:
                      dimension / 2 +
                      math.cos(-math.pi / 2 + i * math.pi / 4) * radius -
                      38,
                  top:
                      dimension / 2 +
                      math.sin(-math.pi / 2 + i * math.pi / 4) * radius -
                      36,
                  child: _OrbitDestination(
                    space: LifeSpace.values[i],
                    onTap: () => onSelected(LifeSpace.values[i]),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _OrbitDestination extends StatelessWidget {
  const _OrbitDestination({required this.space, required this.onTap});
  final LifeSpace space;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Open ${space.label}',
    button: true,
    onTap: onTap,
    excludeSemantics: true,
    child: Tooltip(
      message: 'Open ${space.label}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('destination-${space.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: 76,
            height: 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: space.accent.withValues(alpha: .5),
                    ),
                  ),
                  child: Icon(
                    space.icon,
                    size: 21,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  space.shortLabel,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class SpaceListTile extends StatelessWidget {
  const SpaceListTile({required this.space, required this.onTap, super.key});
  final LifeSpace space;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      key: ValueKey('destination-${space.id}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
      leading: Icon(space.icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(space.label),
      subtitle: Text(space.headline),
      trailing: const Icon(Icons.arrow_outward_rounded, size: 18),
      onTap: onTap,
    ),
  );
}

class _OrbitGuide extends CustomPainter {
  const _OrbitGuide(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .7
      ..color = color.withValues(alpha: .18);
    canvas.drawCircle(center, size.width / 2 - 40, line);
    canvas.drawCircle(
      center,
      size.width * .28,
      line..color = color.withValues(alpha: .08),
    );
  }

  @override
  bool shouldRepaint(_OrbitGuide oldDelegate) => oldDelegate.color != color;
}
