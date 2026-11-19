import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class FoundationPanel extends StatelessWidget {
  const FoundationPanel({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(padding: const EdgeInsets.all(Space.lg), child: child),
  );
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => FoundationPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 32),
        const SizedBox(height: Space.md),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Space.sm),
        Text(message),
        if (action != null) ...[const SizedBox(height: Space.md), action!],
      ],
    ),
  );
}
