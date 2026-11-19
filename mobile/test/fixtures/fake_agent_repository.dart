// Test-only fixtures. Production always uses the authenticated API repository.
import 'package:lifeverse_ai/core/models/agent_models.dart';
import 'package:lifeverse_ai/core/models/life_models.dart';
import 'package:lifeverse_ai/core/network/api_client.dart';
import 'package:lifeverse_ai/features/agents/data/agent_repository.dart';

class FakeAgentRepository extends AgentRepository {
  FakeAgentRepository() : super(ApiClient('https://test.invalid', null));
  final decisions = <Map<String, dynamic>>[];
  final requests = <Map<String, dynamic>>[];
  bool fail = false;
  Map<String, dynamic>? savedSource;
  static final timestamp = DateTime.utc(2026, 11, 19);
  AgentRun current = AgentRun(
    id: 'test-run',
    prompt: 'Help me build a calmer study week',
    status: 'awaiting_approval',
    plan: 'Prepare a learning goal and a small first task.',
    summary: 'Prepared 2 changes. No life records have been changed.',
    agents: ['goals', 'planner'],
    scopes: ['goals', 'planner'],
    allowProposals: true,
    modelCalls: 5,
    toolCalls: 2,
    approvalDigest: 'test-digest',
    reviewNonce: 'test-nonce',
    reviewExpiresAt: DateTime.utc(2099),
    createdAt: timestamp,
    expiresAt: DateTime.utc(2099),
    actions: const [
      AgentAction(
        id: 'goal-action',
        label: 'Create a goal',
        agent: 'goals',
        tool: 'create_goal',
        status: 'pending',
        position: 1,
        recordId: 'new-goal',
        preview: [
          PreviewField(name: 'Title', after: 'Learn Flutter'),
          PreviewField(name: 'Progress', after: '0'),
        ],
      ),
      AgentAction(
        id: 'task-action',
        label: 'Create a linked task',
        agent: 'planner',
        tool: 'create_task',
        status: 'pending',
        position: 2,
        recordId: 'new-task',
        dependencies: ['goal-action'],
        preview: [
          PreviewField(name: 'Title', after: 'Build one small screen'),
          PreviewField(name: 'Goal', after: 'Learn Flutter'),
        ],
      ),
    ],
    steps: [
      AgentStep(
        id: 'step',
        sequence: 1,
        kind: 'supervisor',
        agent: 'supervisor',
        status: 'succeeded',
        summary: 'Selected authorized specialists',
        createdAt: timestamp,
      ),
    ],
  );
  @override
  Future<AgentStatus> status() async => const AgentStatus(
    configured: true,
    consentRequired: false,
    workerOnline: true,
    embeddingsConfigured: false,
    dailyLimit: 10,
    historyDays: 30,
    maxModelCalls: 10,
    maxToolCalls: 12,
  );
  @override
  Future<DataPage<AgentRun>> runs(int offset) async =>
      DataPage(items: [current], total: 1, offset: offset, limit: 30);
  @override
  Future<AgentRun> run(String id) async => current;
  @override
  Future<AgentRun> create(Map<String, dynamic> payload) async {
    requests.add(payload);
    if (fail) throw const ApiFailure('Test-only connection failure');
    current = current.copyWith(
      status: 'completed',
      actions: [],
      summary: 'Read-only test result.',
    );
    return current;
  }

  @override
  Future<AgentRun> decide(String id, Map<String, dynamic> payload) async {
    decisions.add(payload);
    if (fail) throw const ApiFailure('Test-only connection failure');
    current = current.copyWith(
      status: payload['decision'] == 'approve' ? 'completed' : 'rejected',
    );
    return current;
  }

  @override
  Future<DataPage<KnowledgeItem>> knowledge(int offset) async => DataPage(
    items: [
      KnowledgeItem(
        id: 'source',
        title: 'How I learn',
        content: 'Short practice sessions, followed by a practical example.',
        allowAi: false,
        createdAt: timestamp,
        chunkCount: 1,
        indexedChunks: 0,
      ),
    ],
    total: 1,
    offset: offset,
    limit: 30,
  );
  @override
  Future<void> saveKnowledge(Map<String, dynamic> payload, {String? id}) async {
    savedSource = payload;
  }
}
