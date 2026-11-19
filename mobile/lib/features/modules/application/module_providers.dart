import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/models/module_models.dart';
import '../../../core/models/life_models.dart';
import '../../profile/application/account_providers.dart';
import '../data/module_repository.dart';

final moduleRepositoryProvider = Provider<ModuleRepository>((ref) {
  ref.watch(currentSessionProvider.select((s) => s?.user.id));
  return ModuleRepository(ref.watch(apiProvider));
});
final moduleCatalogProvider = FutureProvider.autoDispose<ModuleCatalog>(
  (ref) => ref.watch(moduleRepositoryProvider).catalog(),
);
typedef ModuleQuery = ({String module, String kind, int offset, String search});
final moduleRecordsProvider = FutureProvider.autoDispose
    .family<DataPage<ModuleRecord>, ModuleQuery>(
      (ref, q) => ref
          .watch(moduleRepositoryProvider)
          .records(q.module, kind: q.kind, offset: q.offset, search: q.search),
    );
final moduleReportProvider = FutureProvider.autoDispose
    .family<ModuleReport, ({String module, String? month})>(
      (ref, q) =>
          ref.watch(moduleRepositoryProvider).overview(q.module, q.month),
    );
final knowledgeGraphProvider = FutureProvider.autoDispose
    .family<KnowledgeGraph, String>(
      (ref, q) => ref.watch(moduleRepositoryProvider).graph(q),
    );
final vaultStatusProvider = FutureProvider.autoDispose<VaultStatus>(
  (ref) => ref.watch(moduleRepositoryProvider).vaultStatus(),
);
final vaultFilesProvider = FutureProvider.autoDispose
    .family<DataPage<VaultItem>, ({int offset, String search})>(
      (ref, q) => ref.watch(moduleRepositoryProvider).files(q.offset, q.search),
    );
