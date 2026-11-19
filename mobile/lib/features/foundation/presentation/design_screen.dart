import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../shared/brand/lifeverse_brand.dart';
import '../../../shared/widgets/ai_orb.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/foundation_panel.dart';

class DesignScreen extends ConsumerStatefulWidget {
  const DesignScreen({super.key});
  @override
  ConsumerState<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends ConsumerState<DesignScreen> {
  OrbState _orbState = OrbState.idle;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      const Align(
        alignment: AlignmentDirectional.centerStart,
        child: LifeverseMark(size: 80),
      ),
      const SizedBox(height: Space.lg),
      Text('Aurora Nebula', style: Theme.of(context).textTheme.displaySmall),
      const SizedBox(height: Space.sm),
      const Text(
        'The LIFEVERSE Living Interface System. Depth, clarity and a little cosmic energy.',
      ),
      const SizedBox(height: Space.xl),
      const SectionHeading(
        title: 'Living intelligence',
        subtitle:
            'Animation preview only. These states do not activate a microphone, send AI requests or execute actions.',
      ),
      const SizedBox(height: Space.md),
      Center(
        child: AIOrb(
          state: _orbState,
          size: 180,
          animate: !ref.watch(reduceMotionProvider),
        ),
      ),
      Center(child: StatusPill('Preview: ${_orbState.label}')),
      const SizedBox(height: Space.lg),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final state in OrbState.values)
            ChoiceChip(
              label: Text(state.label),
              selected: _orbState == state,
              onSelected: (_) => setState(() => _orbState = state),
            ),
        ],
      ),
      const SizedBox(height: Space.xl),
      const SectionHeading(
        title: 'The visual language',
        subtitle:
            'Original orbit-and-spark identity, expressive accents and readable semantic colors.',
      ),
      const SizedBox(height: Space.lg),
      Wrap(
        spacing: Space.md,
        runSpacing: Space.md,
        children: [
          for (final entry in {
            'Electric Orchid': Aurora.orchid,
            'Aurora Teal': Aurora.teal,
            'Solar Amber': Aurora.amber,
            'Nebula Rose': Aurora.rose,
            'Glacier Mist': Aurora.mist,
            'Cosmic Plum': Aurora.plum,
          }.entries)
            SizedBox(
              width: 144,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: entry.value,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  Text(entry.key),
                ],
              ),
            ),
        ],
      ),
      const SizedBox(height: Space.xl),
      const UniverseEmptyState(
        title: 'Space for a fresh start',
        message: 'A reusable empty state gives the next step room to breathe.',
      ),
      const SizedBox(height: Space.lg),
      FoundationPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Space to think.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Space.md),
            const Text(
              'Readable type. Generous touch targets. Responsive surfaces. Light and dark modes share one visual language.',
            ),
            const SizedBox(height: Space.lg),
            OutlinedButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Designed for clarity'),
                  content: const Text(
                    'This is a design-system dialog preview. No account data is changed.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.layers_outlined),
              label: const Text('Preview dialog'),
            ),
          ],
        ),
      ),
    ],
  );
}
