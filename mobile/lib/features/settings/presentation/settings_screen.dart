import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
