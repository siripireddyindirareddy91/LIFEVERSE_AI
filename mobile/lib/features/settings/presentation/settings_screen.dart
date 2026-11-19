import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/foundation_panel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final config = ref.watch(configProvider);
    final mode = ref.watch(themeProvider);
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Text(strings.settings, style: Theme.of(context).textTheme.displaySmall),
        ListTile(
          leading: const Icon(Icons.auto_awesome_outlined),
          title: const Text('Agent center'),
          subtitle: const Text('Plans, approvals and execution history'),
          onTap: () => context.push('/agents'),
        ),
        const SizedBox(height: Space.lg),
        FoundationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.appearance,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Space.md),
              for (final entry in {
                ThemeMode.system: strings.system,
                ThemeMode.light: strings.light,
                ThemeMode.dark: strings.dark,
              }.entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.value),
                  leading: Icon(
                    mode == entry.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  selected: mode == entry.key,
                  onTap: () async {
                    try {
                      await ref.read(themeProvider.notifier).setMode(entry.key);
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not save appearance. Please retry.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        SwitchListTile.adaptive(
          title: const Text('Reduce motion'),
          subtitle: const Text(
            'Keep the AI orb still. Device accessibility settings always take priority.',
          ),
          value: ref.watch(reduceMotionProvider),
          onChanged: (value) async {
            try {
              await ref.read(reduceMotionProvider.notifier).setEnabled(value);
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Could not save motion preference. Please retry.',
                    ),
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: Space.lg),
        ListTile(
          title: const Text('Connection setup'),
          subtitle: const Text('Backend and identity configuration'),
          leading: const Icon(Icons.wifi_tethering),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/foundation'),
        ),
        ListTile(
          title: const Text('Your profile and permissions'),
          leading: const Icon(Icons.person_outline_rounded),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/profile'),
        ),
        ListTile(
          title: const Text('Interface Studio'),
          leading: const Icon(Icons.palette_outlined),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/design'),
        ),
        const SizedBox(height: Space.lg),
        FoundationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Environment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Space.md),
              Text('Mode: ${config.environment}'),
              const SizedBox(height: Space.sm),
              Text(
                config.authConfigured
                    ? 'Supabase: configured, connection unverified'
                    : 'Supabase: setup required',
              ),
              const SizedBox(height: Space.md),
              const Text(
                'Set your API URL, Supabase project URL and public key in the environment configuration file, then rebuild the app. Never include server secrets.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
