import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification settings provider
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((
      ref,
    ) {
      return NotificationSettingsNotifier();
    });

class NotificationSettings {
  final bool fastCompletionEnabled;
  final bool ongoingTimerEnabled;

  const NotificationSettings({
    this.fastCompletionEnabled = true,
    this.ongoingTimerEnabled = true,
  });

  NotificationSettings copyWith({
    bool? fastCompletionEnabled,
    bool? ongoingTimerEnabled,
  }) {
    return NotificationSettings(
      fastCompletionEnabled:
          fastCompletionEnabled ?? this.fastCompletionEnabled,
      ongoingTimerEnabled: ongoingTimerEnabled ?? this.ongoingTimerEnabled,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      fastCompletionEnabled: prefs.getBool('notif_fastComplete') ?? true,
      ongoingTimerEnabled: prefs.getBool('notif_ongoingTimer') ?? true,
    );
  }

  Future<void> setFastCompletionEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_fastComplete', enabled);
    state = state.copyWith(fastCompletionEnabled: enabled);
  }

  Future<void> setOngoingTimerEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_ongoingTimer', enabled);
    state = state.copyWith(ongoingTimerEnabled: enabled);
  }
}
