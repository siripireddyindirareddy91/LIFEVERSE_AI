import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/automation_models.dart';

class DeviceGateway {
  final plugin = FlutterLocalNotificationsPlugin();
  bool initialized = false, launchHandled = false;
  void Function(String route)? openHandler;
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  Future<void> initialize(void Function(String route)? onOpen) async {
    if (onOpen != null) openHandler = onOpen;
    if (initialized || !supported) return;
    tzdata.initializeTimeZones();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('notification_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) openHandler?.call(response.payload!);
      },
    );
    initialized = true;
  }

  Future<bool> requestPermission() async {
    if (!supported) return false;
    await initialize(null);
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  Future<void> clear() async {
    if (!supported) return;
    await initialize(null);
    await plugin.cancelAll();
  }

  Future<void> synchronize(
    List<InboxItem> items,
    SharedPreferences prefs,
    bool Function() current,
    void Function(String route) onOpen,
  ) async {
    if (!supported) return;
    await initialize(onOpen);
    if (!launchHandled && current()) {
      launchHandled = true;
      final launch = await plugin.getNotificationAppLaunchDetails();
      if (current() &&
          launch?.didNotificationLaunchApp == true &&
          launch?.notificationResponse?.payload != null) {
        onOpen(launch!.notificationResponse!.payload!);
      }
    }
    final ids = Map<String, dynamic>.from(
      jsonDecode(prefs.getString('notification_ids') ?? '{}') as Map,
    );
    final seen = (prefs.getStringList('notification_seen') ?? []).toSet();
    var next = prefs.getInt('notification_next_id') ?? 1;
    int id(String key) => (ids.putIfAbsent(key, () => next++) as num).toInt();
    final future = {
      for (final item in items.where((n) => n.dueAt.isAfter(DateTime.now())))
        id(item.id),
    };
    for (final pending in await plugin.pendingNotificationRequests()) {
      if (!future.contains(pending.id)) await plugin.cancel(pending.id);
    }
    var shown = 0;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'lifeverse_updates',
        'LIFEVERSE updates',
        channelDescription: 'Updates you chose to receive',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        visibility: NotificationVisibility.private,
      ),
      iOS: DarwinNotificationDetails(),
    );
    for (final item in items) {
      if (!current()) {
        await plugin.cancelAll();
        return;
      }
      final notificationId = id(item.id);
      if (item.dueAt.isAfter(DateTime.now())) {
        await plugin.zonedSchedule(
          notificationId,
          'LIFEVERSE update',
          'Open the app to view your update.',
          tz.TZDateTime.from(item.dueAt.toUtc(), tz.UTC),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: item.route,
        );
        seen.add(item.id);
      } else if (!seen.contains(item.id)) {
        if (shown < 3) {
          await plugin.show(
            notificationId,
            'LIFEVERSE update',
            'Open the app to view your update.',
            details,
            payload: item.route,
          );
          shown++;
        }
        seen.add(item.id);
      }
    }
    if (!current()) {
      await plugin.cancelAll();
      return;
    }
    final kept = items.map((n) => n.id).toSet();
    ids.removeWhere((key, value) => !kept.contains(key));
    await prefs.setString('notification_ids', jsonEncode(ids));
    await prefs.setInt('notification_next_id', next);
    await prefs.setStringList(
      'notification_seen',
      seen.toList().reversed.take(300).toList().reversed.toList(),
    );
  }

  Future<void> openOAuth(String url) async {
    final uri = Uri.parse(url);
    if (uri.scheme != 'https' ||
        ![
          'accounts.google.com',
          'login.microsoftonline.com',
        ].contains(uri.host)) {
      throw StateError('Unrecognized calendar authorization address.');
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Could not open the authorization browser.');
    }
  }
}

final deviceGatewayProvider = Provider<DeviceGateway>((ref) => DeviceGateway());
