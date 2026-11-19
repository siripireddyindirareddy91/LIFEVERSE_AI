import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/foundation/presentation/foundation_screen.dart';
import '../features/foundation/presentation/design_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../l10n/app_localizations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            FoundationShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const FoundationScreen(),
          ),
          GoRoute(
            path: '/design',
            builder: (context, state) => const DesignScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This destination does not exist.'),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Return to foundation'),
            ),
          ],
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

class FoundationShell extends StatelessWidget {
  const FoundationShell({
    required this.location,
    required this.child,
    super.key,
  });
  final String location;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final index = switch (location) {
      '/design' => 1,
      '/settings' => 2,
      _ => 0,
    };
    final labels = [strings.foundation, strings.designSystem, strings.settings];
    const icons = [
      Icons.blur_on_rounded,
      Icons.palette_outlined,
      Icons.tune_rounded,
    ];
    void navigate(int index) =>
        context.go(['/', '/design', '/settings'][index]);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          appBar: AppBar(
            title: Text(strings.appTitle),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: Center(child: Text('PHASE 01')),
              ),
            ],
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: navigate,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (var i = 0; i < labels.length; i++)
                        NavigationRailDestination(
                          icon: Icon(icons[i]),
                          label: Text(labels[i]),
                        ),
                    ],
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: navigate,
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationDestination(
                        icon: Icon(icons[i]),
                        label: labels[i],
                      ),
                  ],
                ),
        );
      },
    );
  }
}
