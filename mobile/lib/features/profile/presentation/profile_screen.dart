import '../../agents/application/agent_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/account_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(profileProvider)
      .when(
        loading: () => const Center(child: UniverseLoadingState()),
        error: (error, stack) => SingleChildScrollView(
          padding: const EdgeInsets.all(Space.lg),
          child: UniverseErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(profileProvider),
          ),
        ),
        data: (profile) =>
            _ProfileForm(key: ValueKey(profile), initial: profile),
      );
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.initial, super.key});
  final ProfileData? initial;
  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: widget.initial?.displayName ?? '',
  );
  late final _zone = TextEditingController(
    text: widget.initial?.timezone ?? 'UTC',
  );
  late bool _ai = widget.initial?.aiConsent ?? false;
  late bool _memory = widget.initial?.memoryConsent ?? false;
  late bool _knowledge = widget.initial?.knowledgeConsent ?? false;
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    _zone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      Text(
        widget.initial == null ? 'Make this universe yours.' : 'Your profile',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: Space.md),
      const Text(
        'Your name and time zone keep your life spaces personal and your daily totals consistent.',
      ),
      const SizedBox(height: Space.lg),
      Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              maxLength: 80,
              decoration: const InputDecoration(labelText: 'Display name'),
              validator: (value) =>
                  value?.trim().isNotEmpty == true ? null : 'Enter your name',
            ),
            const SizedBox(height: Space.md),
            TextFormField(
              controller: _zone,
              maxLength: 64,
              decoration: const InputDecoration(
                labelText: 'Time zone',
                helperText: 'IANA name, e.g. Asia/Kolkata or Europe/London',
              ),
              validator: (value) =>
                  value?.trim().isNotEmpty == true ? null : 'Enter a time zone',
            ),
            const SizedBox(height: Space.lg),
            UniverseSurface(
              child: Column(
                children: [
                  const SectionHeading(title: 'Your AI, your permission'),
                  const SizedBox(height: Space.md),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow AI processing'),
                    subtitle: const Text(
                      'Send messages, recent chat and context you choose to the configured AI provider. Agent changes require your separate approval.',
                    ),
                    value: _ai,
                    onChanged: _saving
                        ? null
                        : (value) => setState(() {
                            _ai = value;
                            if (!value) {
                              _memory = false;
                              _knowledge = false;
                            }
                          }),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow memory context'),
                    subtitle: const Text(
                      'Only memories individually marked for AI sharing can be retrieved. You still choose whether to include memory for each message.',
                    ),
                    value: _memory,
                    onChanged: !_ai || _saving
                        ? null
                        : (value) => setState(() => _memory = value),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow knowledge context'),
                    subtitle: const Text(
                      'Allow shared knowledge sources to be indexed and retrieved by agents. Choose sources and scopes separately.',
                    ),
                    value: _knowledge,
                    onChanged: !_ai || _saving
                        ? null
                        : (value) => setState(() => _knowledge = value),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Semantics(liveRegion: true, child: Text(_error!)),
              ),
            const SizedBox(height: Space.lg),
            LifeverseButton(
              label: 'Save profile',
              busy: _saving,
              onPressed: () async {
                if (!_form.currentState!.validate()) return;
                setState(() {
                  _saving = true;
                  _error = null;
                });
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ref
                      .read(mutationProvider.notifier)
                      .run(
                        (repo) => repo.saveProfile({
                          'display_name': _name.text.trim(),
                          'timezone': _zone.text.trim(),
                          'locale': 'en',
                          'ai_consent': _ai,
                          'memory_consent': _memory,
                          'knowledge_consent': _knowledge,
                        }),
                      );
                  ref.invalidate(agentStatusProvider);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Profile saved')),
                  );
                } catch (error) {
                  if (mounted) setState(() => _error = error.toString());
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: Space.xl),
      TextButton.icon(
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign out'),
        onPressed: _saving
            ? null
            : () async {
                if (!await confirmAction(
                  context,
                  title: 'Sign out?',
                  message: 'Your saved records will remain in your account.',
                  action: 'Sign out',
                )) {
                  return;
                }
                try {
                  await ref.read(accountActionProvider.notifier).signOut();
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not sign out. Please retry.'),
                      ),
                    );
                  }
                }
              },
      ),
    ],
  );
}
