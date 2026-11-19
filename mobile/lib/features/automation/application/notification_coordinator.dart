import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../core/models/automation_models.dart';
import '../../profile/application/account_providers.dart';
import '../data/device_gateway.dart';
import 'automation_providers.dart';

bool safeNotificationRoute(String route) =>
    route == '/notifications' ||
    route == '/automation' ||
    route == '/integrations' ||
    RegExp(r'^/(agents|automation/runs)/[a-zA-Z0-9-]+$').hasMatch(route);

final notificationCoordinatorProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(currentSessionProvider.select((s) => s?.user.id));
  final prefs = ref.read(preferencesProvider);
  final gateway = ref.read(deviceGatewayProvider);
  var stopped = false, running = false;
  Timer? timer;
  ref.onDispose(() {
    stopped = true;
    timer?.cancel();
  });
  final previous = prefs.getString('notification_owner');
  if (previous != null && previous != user) {
    await prefs.setBool('notification_enabled', false);
    await gateway.clear();
    await prefs.remove('notification_seen');
    await prefs.remove('notification_ids');
  }
  if (stopped) return;
  if (user == null) {
    await prefs.remove('notification_owner');
    return;
  }
  await prefs.setString('notification_owner', user);
  if (prefs.getBool('notification_enabled') != true) return;
  Future<void> sync() async {
    if (stopped || running) return;
    running = true;
    try {
      final page = await ref
          .read(automationRepositoryProvider)
          .inbox(pending: true);
      if (stopped) return;
      final items = (page['items'] as List)
          .map((e) => InboxItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      await gateway.synchronize(
        items,
        prefs,
        () =>
            !stopped &&
            prefs.getBool('notification_enabled') == true &&
            prefs.getString('notification_owner') == user,
        (route) {
          if (!stopped && safeNotificationRoute(route)) {
            ref.read(routerProvider).push(route);
          }
        },
      );
    } finally {
      running = false;
    }
  }

  await sync();
  if (!stopped) {
    timer = Timer.periodic(const Duration(seconds: 45), (_) async {
      try {
        await sync();
      } catch (_) {
        /* Inbox remains durable; foreground refresh retries. */
      }
    });
  }
});
