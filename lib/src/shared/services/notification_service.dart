import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  final service = NotificationService();
  // Auto-initialize (fire and forget - don't await)
  service.init();
  return service;
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _notificationsPlugin.initialize(initializationSettings);

      // Request permissions for Android 13+
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      _initialized = true;
    } catch (e) {
      // Log error but don't crash - notifications are optional
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // Ensure initialized before scheduling
      if (!_initialized) await init();

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fasting_channel',
            'Fasting Alerts',
            channelDescription: 'Notifications for fasting milestones',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        // Use inexact mode to avoid permission issues on Android 12+
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      // Don't let notification failures block fasting functionality
      debugPrint('Notification scheduling error: $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Notification cancel error: $e');
    }
  }

  /// Shows an ongoing (persistent) notification for fasting timer.
  /// This notification is visible in the notification shade and updates periodically.
  Future<void> showOngoingNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      if (!_initialized) await init();

      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fasting_ongoing_channel',
            'Fasting Timer',
            channelDescription: 'Shows your current fasting progress',
            importance: Importance.low, // Low importance = no sound/vibration
            priority: Priority.low,
            ongoing: true, // Can't be swiped away
            autoCancel: false,
            showWhen: false, // Don't show timestamp
            playSound: false,
            enableVibration: false,
            category: AndroidNotificationCategory.progress,
            visibility: NotificationVisibility.public,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Ongoing notification error: $e');
    }
  }

  /// Cancel a specific notification by ID
  Future<void> cancel(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('Notification cancel error: $e');
    }
  }
}
