import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class UniverseSurface extends StatelessWidget {
  const UniverseSurface({
    required this.child,
    this.accent,
    this.padding = const EdgeInsets.all(Space.lg),
    super.key,
  });
  final Widget child;
  final Color? accent;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(ShapeTokens.radius),
        border: Border.all(
          color: (accent ?? scheme.outlineVariant).withValues(alpha: .3),
        ),
      ),
      padding: padding,
      child: child,
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.subtitle,
    this.action,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          ?action,
        ],
      ),
      if (subtitle != null) ...[
        const SizedBox(height: Space.sm),
        Text(
          subtitle!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ],
  );
}

class LifeverseButton extends StatelessWidget {
  const LifeverseButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    this.secondary = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;
  final bool secondary;
  @override
  Widget build(BuildContext context) {
    final content = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        if (busy)
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (icon != null)
          Icon(icon, size: 20),
        Text(label, textAlign: TextAlign.center),
      ],
    );
    return Semantics(
      liveRegion: busy,
      child: secondary
          ? OutlinedButton(
              onPressed: busy ? null : onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: content,
              ),
            )
          : FilledButton(
              onPressed: busy ? null : onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: content,
              ),
            ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class UniverseEmptyState extends StatelessWidget {
  const UniverseEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.nights_stay_outlined,
    this.action,
    super.key,
  });
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => UniverseSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: Space.md),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Space.sm),
        Text(message, style: Theme.of(context).textTheme.bodyLarge),
        if (action != null) ...[const SizedBox(height: Space.md), action!],
      ],
    ),
  );
}

class UniverseErrorState extends StatelessWidget {
  const UniverseErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: UniverseEmptyState(
      icon: Icons.cloud_off_outlined,
      title: 'Let’s try that again',
      message: message,
      action: LifeverseButton(
        label: 'Retry',
        onPressed: onRetry,
        secondary: true,
      ),
    ),
  );
}

class UniverseLoadingState extends StatelessWidget {
  const UniverseLoadingState({this.label = 'Loading your space…', super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: Space.md),
          Text(label),
        ],
      ),
    ),
  );
}

Future<void> showUniverseSheet(
  BuildContext context, {
  required String title,
  required String message,
  Widget? child,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * .85,
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Space.md),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          if (child != null) ...[const SizedBox(height: Space.lg), child],
        ],
      ),
    ),
  ),
);
