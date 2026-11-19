import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/models/life_models.dart';
import '../../profile/application/account_providers.dart';
import '../data/life_repository.dart';

final lifeRepositoryProvider = Provider<LifeRepository>((ref) {
  ref.watch(currentSessionProvider.select((session) => session?.user.id));
  return LifeRepository(ref.watch(apiProvider));
});
final profileProvider = FutureProvider.autoDispose<ProfileData?>(
  (ref) => ref.watch(lifeRepositoryProvider).profile(),
);
final tasksProvider = FutureProvider.autoDispose
    .family<DataPage<TaskItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).tasks(query),
    );
final goalsProvider = FutureProvider.autoDispose
    .family<DataPage<GoalItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).goals(query),
    );
final habitsProvider = FutureProvider.autoDispose
    .family<DataPage<HabitItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).habits(query),
    );
final memoriesProvider = FutureProvider.autoDispose
    .family<DataPage<MemoryItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).memories(query),
    );
final eventsProvider = FutureProvider.autoDispose
    .family<DataPage<CalendarItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).events(query),
    );
final dashboardProvider = FutureProvider.autoDispose<DashboardData>(
  (ref) => ref.watch(lifeRepositoryProvider).dashboard(),
);
final assistantStatusProvider = FutureProvider.autoDispose<AssistantStatus>(
  (ref) => ref.watch(lifeRepositoryProvider).assistantStatus(),
);
final conversationsProvider = FutureProvider.autoDispose
    .family<DataPage<ConversationItem>, LifeQuery>(
      (ref, query) => ref.watch(lifeRepositoryProvider).conversations(query),
    );
final messagesProvider = FutureProvider.autoDispose
    .family<DataPage<MessageItem>, ({String id, LifeQuery query})>(
      (ref, args) =>
          ref.watch(lifeRepositoryProvider).messages(args.id, args.query),
    );

void refreshLife(Ref ref) {
  ref.invalidate(profileProvider);
  ref.invalidate(tasksProvider);
  ref.invalidate(goalsProvider);
  ref.invalidate(habitsProvider);
  ref.invalidate(memoriesProvider);
  ref.invalidate(eventsProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(assistantStatusProvider);
  ref.invalidate(conversationsProvider);
  ref.invalidate(messagesProvider);
}

final mutationProvider = AsyncNotifierProvider<LifeMutation, void>(
  LifeMutation.new,
);

class LifeMutation extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}
  Future<void> run(
    Future<void> Function(LifeRepository repository) action,
  ) async {
    state = const AsyncLoading();
    try {
      await action(ref.read(lifeRepositoryProvider));
      refreshLife(ref);
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }
}
