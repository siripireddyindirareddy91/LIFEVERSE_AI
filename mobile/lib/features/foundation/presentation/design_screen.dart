import 'package:flutter/material.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/foundation_panel.dart';

class DesignScreen extends StatelessWidget {
  const DesignScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      Text('Aurora Nebula', style: Theme.of(context).textTheme.displaySmall),
      const SizedBox(height: Space.sm),
      const Text(
        'The LIFEVERSE Living Interface System. Depth, clarity and a little cosmic energy.',
      ),
      const SizedBox(height: Space.xl),
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
