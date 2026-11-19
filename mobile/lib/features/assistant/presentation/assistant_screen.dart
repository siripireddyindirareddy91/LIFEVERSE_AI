import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/providers.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/ai_orb.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});
  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _text = TextEditingController();
  String? _conversationId;
  String? _requestId;
  String? _signature;
  String? _error;
  bool _sending = false;
  bool _includeMemory = false;
  bool _includePlans = false;
  LifeQuery _messages = const LifeQuery();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    final includeMemory =
        _includeMemory &&
        (ref.read(profileProvider).value?.memoryConsent ?? false);
    if (_sending || text.isEmpty) return;
    final signature = jsonEncode([
      text,
      _conversationId,
      includeMemory,
      _includePlans,
    ]);
    if (_signature != signature) {
      _signature = signature;
      _requestId = const Uuid().v4();
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final repo = ref.read(lifeRepositoryProvider);
      final result = await repo.sendMessage(
        requestId: _requestId!,
        message: text,
        conversationId: _conversationId,
        includeMemory: includeMemory,
        includePlans: _includePlans,
      );
      if (!mounted) return;
      // A successful POST stays successful even if refreshing history then fails.
      setState(() {
        _conversationId = result.conversationId;
        _text.clear();
        _requestId = null;
        _signature = null;
      });
      ref.invalidate(conversationsProvider);
      ref.invalidate(messagesProvider);
      try {
        final page = await repo.messages(
          result.conversationId,
          const LifeQuery(),
        );
        if (mounted) {
          setState(
            () => _messages = LifeQuery(
              offset: page.total == 0
                  ? 0
                  : ((page.total - 1) ~/ page.limit) * page.limit,
            ),
          );
        }
      } catch (_) {
        /* The message provider shows its own recoverable read error. */
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final memoryAllowed =
        ref.watch(profileProvider).value?.memoryConsent ?? false;
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Row(
          children: [
            AIOrb(
              size: 80,
              state: _sending
                  ? OrbState.thinking
                  : _error != null
                  ? OrbState.error
                  : OrbState.idle,
              animate: !ref.watch(reduceMotionProvider),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Text(
                'Think it through,\ntogether.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.md),
        const Text(
          'A place for ideas, questions and plans. AI suggestions never change your records automatically.',
        ),
        const SizedBox(height: Space.md),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: _sending ? null : () => context.push('/agents'),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Plan with agents'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('New conversation'),
              onPressed: _sending
                  ? null
                  : () => setState(() {
                      _conversationId = null;
                      _messages = const LifeQuery();
                      _requestId = null;
                      _signature = null;
                      _error = null;
                    }),
            ),
            TextButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('History'),
              onPressed: _sending
                  ? null
                  : () async {
                      final thread = await showDialog<ConversationItem>(
                        context: context,
                        builder: (_) => const _ConversationPicker(),
                      );
                      if (thread != null && mounted) {
                        setState(() {
                          _conversationId = thread.id;
                          _messages = const LifeQuery();
                          _error = null;
                          _requestId = null;
                          _signature = null;
                        });
                      }
                    },
            ),
            if (_conversationId != null)
              IconButton(
                tooltip: 'Delete conversation',
                icon: const Icon(Icons.delete_outline),
                onPressed: _sending
                    ? null
                    : () async {
                        if (!await confirmAction(
                          context,
                          title: 'Delete this conversation?',
                          message:
                              'Its saved messages will be permanently removed. Saved memories are separate.',
                        )) {
                          return;
                        }
                        try {
                          await ref
                              .read(mutationProvider.notifier)
                              .run(
                                (repo) =>
                                    repo.deleteConversation(_conversationId!),
                              );
                          if (mounted) {
                            setState(() {
                              _conversationId = null;
                              _messages = const LifeQuery();
                            });
                          }
                        } catch (error) {
                          if (mounted) {
                            setState(() => _error = error.toString());
                          }
                        }
                      },
              ),
          ],
        ),
        const SizedBox(height: Space.md),
        if (_conversationId != null)
          RecordsView<MessageItem>(
            data: ref.watch(
              messagesProvider((id: _conversationId!, query: _messages)),
            ),
            onRetry: () => ref.invalidate(
              messagesProvider((id: _conversationId!, query: _messages)),
            ),
            onOffset: (offset) =>
                setState(() => _messages = _messages.copyWith(offset: offset)),
            emptyTitle: 'A quiet conversation',
            emptyMessage: 'No saved messages are available.',
            itemBuilder: (message) => Align(
              alignment: message.role == 'user'
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: UniverseSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.role == 'user' ? 'You' : 'LIFEVERSE',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: Space.sm),
                      SelectableText(message.content),
                      const SizedBox(height: Space.sm),
                      Text(
                        deviceDate(message.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (message.role == 'assistant')
                        Text(
                          'Context: ${message.memoryCount} matching memories • ${message.planCount} plan records',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ref
            .watch(assistantStatusProvider)
            .when(
              loading: () =>
                  const UniverseLoadingState(label: 'Checking your AI space…'),
              error: (error, stack) => UniverseErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(assistantStatusProvider),
              ),
              data: (status) {
                if (!status.configured || status.consentRequired) {
                  return UniverseEmptyState(
                    title: !status.configured
                        ? 'Your AI service needs a connection'
                        : 'Your permission comes first',
                    message: !status.configured
                        ? 'The AI service is not connected yet. Your other life spaces remain available, and saved conversations can still be managed here.'
                        : 'Review AI processing permissions in your profile before sending a message. No personal context is shared automatically.',
                    icon: Icons.shield_outlined,
                    action: LifeverseButton(
                      label: 'Review profile',
                      onPressed: () => context.push('/profile'),
                      secondary: true,
                    ),
                  );
                }
                return UniverseSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Chats expire after ${status.retentionDays} days. You can delete them sooner. Up to ${status.dailyLimit} successful AI requests per rolling day.',
                      ),
                      const SizedBox(height: Space.sm),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Include relevant memories'),
                        subtitle: Text(
                          memoryAllowed
                              ? 'Only unexpired memories marked for AI sharing are eligible.'
                              : 'Enable memory sharing in your profile first.',
                        ),
                        value: memoryAllowed && _includeMemory,
                        onChanged: _sending || !memoryAllowed
                            ? null
                            : (value) => setState(() => _includeMemory = value),
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Include my current plans'),
                        subtitle: const Text(
                          'Share a small snapshot of open tasks, active goals and habits.',
                        ),
                        value: _includePlans,
                        onChanged: _sending
                            ? null
                            : (value) => setState(() => _includePlans = value),
                      ),
                      TextField(
                        controller: _text,
                        enabled: !_sending,
                        minLines: 3,
                        maxLines: 8,
                        maxLength: 4000,
                        decoration: const InputDecoration(
                          labelText: 'Ask LIFEVERSE',
                          hintText: 'What would you like to think through?',
                        ),
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Semantics(
                            liveRegion: true,
                            child: Text(_error!),
                          ),
                        ),
                      const SizedBox(height: Space.md),
                      LifeverseButton(
                        label: _error == null
                            ? 'Send message'
                            : 'Retry message',
                        busy: _sending,
                        icon: Icons.arrow_upward_rounded,
                        onPressed: () {
                          if (_text.text.trim().isEmpty) {
                            setState(() => _error = 'Write a message first.');
                          } else {
                            _send();
                          }
                        },
                      ),
                      const SizedBox(height: Space.sm),
                      const Text(
                        'AI can make mistakes. Review important information before acting.',
                      ),
                    ],
                  ),
                );
              },
            ),
      ],
    );
  }
}

class _ConversationPicker extends ConsumerStatefulWidget {
  const _ConversationPicker();
  @override
  ConsumerState<_ConversationPicker> createState() =>
      _ConversationPickerState();
}

class _ConversationPickerState extends ConsumerState<_ConversationPicker> {
  LifeQuery _query = const LifeQuery();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Your conversations'),
    content: SizedBox(
      width: 440,
      height: 450,
      child: SingleChildScrollView(
        child: RecordsView<ConversationItem>(
          data: ref.watch(conversationsProvider(_query)),
          onRetry: () => ref.invalidate(conversationsProvider(_query)),
          onOffset: (offset) =>
              setState(() => _query = LifeQuery(offset: offset)),
          emptyTitle: 'No saved conversations',
          emptyMessage:
              'Your conversations appear here until their retention period ends.',
          itemBuilder: (thread) => ListTile(
            title: Text(
              thread.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Expires ${deviceDate(thread.expiresAt)}'),
            onTap: () => Navigator.pop(context, thread),
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}
