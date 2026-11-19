import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/models/agent_models.dart';
import '../../../core/models/life_models.dart';
import '../../profile/application/account_providers.dart';
import '../data/agent_repository.dart';

final agentRepositoryProvider = Provider<AgentRepository>((ref) {
  ref.watch(currentSessionProvider.select((session) => session?.user.id));
  return AgentRepository(ref.watch(apiProvider));
});
final agentStatusProvider = FutureProvider.autoDispose<AgentStatus>(
  (ref) => ref.watch(agentRepositoryProvider).status(),
);
final agentRunsProvider = FutureProvider.autoDispose
    .family<DataPage<AgentRun>, int>(
      (ref, offset) => ref.watch(agentRepositoryProvider).runs(offset),
    );
final agentRunProvider = FutureProvider.autoDispose.family<AgentRun, String>(
  (ref, id) => ref.watch(agentRepositoryProvider).run(id),
);
final knowledgeProvider = FutureProvider.autoDispose
    .family<DataPage<KnowledgeItem>, int>(
      (ref, offset) => ref.watch(agentRepositoryProvider).knowledge(offset),
    );
