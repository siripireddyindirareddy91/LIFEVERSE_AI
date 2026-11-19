import '../features/modules/presentation/module_screen.dart';
import '../features/modules/presentation/vault_screen.dart';
import '../features/modules/presentation/knowledge_universe_screen.dart';
import '../features/modules/domain/module_spec.dart';
import '../features/agents/presentation/agent_screens.dart';
import '../features/agents/presentation/knowledge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/foundation/presentation/foundation_screen.dart';
import '../features/foundation/presentation/design_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../l10n/app_localizations.dart';
import '../features/universe/domain/life_space.dart';
import '../features/universe/presentation/home_universe_screen.dart';
import '../shared/brand/lifeverse_brand.dart';
import '../features/profile/presentation/account_gate.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/planner/presentation/planner_screen.dart';
import '../features/goals/presentation/goals_screen.dart';
import '../features/habits/presentation/habits_screen.dart';
import '../features/memory/presentation/memory_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/assistant/presentation/assistant_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            FoundationShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/modules/:module',
            builder: (context, state) {
              final id = state.pathParameters['module']!;
              return advancedModules.containsKey(id)
                  ? AccountGate(
                      child: AdvancedModuleScreen(
                        key: ValueKey(id),
                        module: id,
                      ),
                    )
                  : const ExploreUniverseScreen();
            },
          ),
          GoRoute(
            path: '/vault',
            builder: (context, state) =>
                const AccountGate(child: VaultScreen()),
          ),
          GoRoute(
            path: '/knowledge-universe',
            builder: (context, state) =>
                const AccountGate(child: KnowledgeUniverseScreen()),
          ),
          GoRoute(
            path: '/agents',
            builder: (context, state) =>
                const AccountGate(child: AgentCenterScreen()),
          ),
          GoRoute(
            path: '/agents/new',
            builder: (context, state) => AccountGate(
              child: NewAgentRunScreen(
                initialScope: state.uri.queryParameters['scope'],
              ),
            ),
          ),
          GoRoute(
            path: '/agents/:id',
            builder: (context, state) => AccountGate(
              child: AgentRunScreen(id: state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: '/knowledge',
            builder: (context, state) =>
                const AccountGate(child: KnowledgeScreen()),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) =>
                const AccountGate(child: ProfileScreen()),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => AccountGate(
              child: PlannerScreen(
                goalId: state.uri.queryParameters['goal'],
                goalTitle: state.uri.queryParameters['label'],
              ),
            ),
          ),
          GoRoute(
            path: '/goals',
            builder: (context, state) =>
                const AccountGate(child: GoalsScreen()),
          ),
          GoRoute(
            path: '/habits',
            builder: (context, state) =>
                const AccountGate(child: HabitsScreen()),
          ),
          GoRoute(
            path: '/memory',
            builder: (context, state) =>
                const AccountGate(child: MemoryScreen()),
          ),
          GoRoute(
            path: '/insights',
            builder: (context, state) =>
                const AccountGate(child: InsightsScreen()),
          ),
          GoRoute(
            path: '/assistant',
            builder: (context, state) =>
                const AccountGate(child: AssistantScreen()),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeUniverseScreen(),
          ),
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExploreUniverseScreen(),
          ),
          GoRoute(
            path: '/foundation',
            builder: (context, state) => const FoundationScreen(),
          ),
          GoRoute(
            path: '/universe/:space',
            redirect: (context, state) {
              final matches = LifeSpace.values.where(
                (space) => space.id == state.pathParameters['space'],
              );
              if (matches.isNotEmpty &&
                  matches.single.route != state.uri.path) {
                return matches.single.route;
              }
              return null;
            },
            builder: (context, state) {
              final matches = LifeSpace.values.where(
                (space) => space.id == state.pathParameters['space'],
              );
              if (matches.isEmpty) return const ExploreUniverseScreen();
              return LifeSpaceScreen(space: matches.single);
            },
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
      '/planner' => 1,
      '/insights' => 2,
      '/settings' || '/foundation' || '/design' || '/profile' => 3,
      _ => 0,
    };
    final labels = [strings.home, 'Planner', 'Insights', strings.settings];
    const icons = [
      Icons.blur_on_rounded,
      Icons.calendar_month_outlined,
      Icons.insights_outlined,
      Icons.tune_rounded,
    ];
    void navigate(int index) =>
        context.go(['/', '/planner', '/insights', '/settings'][index]);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        return Scaffold(
          appBar: AppBar(
            title: const BrandLockup(),
            toolbarHeight: 72,
            actions: [
              IconButton(
                tooltip: 'Agent center',
                onPressed: () => context.push('/agents'),
                icon: const Icon(Icons.auto_awesome_outlined),
              ),
              IconButton(
                tooltip: 'Explore spaces',
                onPressed: () => context.go('/explore'),
                icon: const Icon(Icons.apps_rounded),
              ),
              IconButton(
                tooltip: 'My profile',
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.person_outline_rounded),
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
