import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../domain/fasting_session.dart';
import '../../../../shared/services/storage_service.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/providers/notification_settings_provider.dart';
import 'package:flutter/foundation.dart';

part 'fasting_controller.g.dart';

class FastingState {
  final bool isFasting;
  final Duration elapsed;
  final Duration remaining;
  final double progress; // 0.0 to 1.0
  final FastingSession? session;

  const FastingState({
    this.isFasting = false,
    this.elapsed = Duration.zero,
    this.remaining = Duration.zero,
    this.progress = 0.0,
    this.session,
  });

  FastingState copyWith({
    bool? isFasting,
    Duration? elapsed,
    Duration? remaining,
    double? progress,
    FastingSession? session,
  }) {
    return FastingState(
      isFasting: isFasting ?? this.isFasting,
      elapsed: elapsed ?? this.elapsed,
      remaining: remaining ?? this.remaining,
      progress: progress ?? this.progress,
      session: session ?? this.session,
    );
  }
}

@riverpod
class FastingController extends _$FastingController {
  Timer? _timer;
  Timer? _notificationTimer;

  @override
  Future<FastingState> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);

    // Check for active session (where endTime is null)
    final activeSession = await isar.fastingSessions
        .filter()
        .endTimeIsNull()
        .findFirst();

    // Listen to notification settings changes
    ref.listen(notificationSettingsProvider, (previous, next) {
      if (!next.ongoingTimerEnabled) {
        _notificationTimer?.cancel();
        _notificationTimer = null;
        ref.read(notificationServiceProvider).cancel(1); // Cancel ongoing
      } else if (state.value?.isFasting == true && activeSession != null) {
        _startOngoingNotification(activeSession);
      }
    });

    if (activeSession != null && activeSession.startTime != null) {
      _startTimer(activeSession);
      _startOngoingNotification(activeSession);
      return _calculateState(activeSession);
    }

    return const FastingState();
  }

  void _startTimer(FastingSession session) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Recalculate state using the session's actual startTime from the object
      state = AsyncValue.data(_calculateState(session));
    });
  }

  void _startOngoingNotification(FastingSession session) {
    _notificationTimer?.cancel();
    // Update notification every minute
    _notificationTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateOngoingNotification(session);
    });
    // Also show immediately
    _updateOngoingNotification(session);
  }

  void _updateOngoingNotification(FastingSession session) {
    if (session.startTime == null) return;

    // Respect user settings
    final settings = ref.read(notificationSettingsProvider);
    if (!settings.ongoingTimerEnabled) return;

    final elapsed = DateTime.now().difference(session.startTime!);
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes % 60;

    final targetMinutes = session.targetDurationMinutes ?? 960;
    final remaining = Duration(minutes: targetMinutes) - elapsed;
    final remainingHours = remaining.inHours;
    final remainingMins = remaining.inMinutes % 60;

    String body;
    if (remaining.isNegative) {
      body = '🎉 Goal reached! You\'ve fasted ${hours}h ${minutes}m';
    } else {
      body = '${remainingHours}h ${remainingMins}m remaining to goal';
    }

    ref
        .read(notificationServiceProvider)
        .showOngoingNotification(
          id: 1,
          title: 'Fasting: ${hours}h ${minutes}m',
          body: body,
        );
  }

  FastingState _calculateState(FastingSession session) {
    final now = DateTime.now();
    final startTime = session.startTime!;
    final targetMinutes = session.targetDurationMinutes ?? 960; // Default 16h
    final targetDuration = Duration(minutes: targetMinutes);

    final elapsed = now.difference(startTime);
    final remaining = targetDuration - elapsed;

    // Progress 0.0 to 1.0
    double progress = 0.0;
    if (targetDuration.inSeconds > 0) {
      progress = elapsed.inSeconds / targetDuration.inSeconds;
      if (progress > 1.0) progress = 1.0;
    }

    return FastingState(
      isFasting: true,
      elapsed: elapsed,
      remaining: remaining.isNegative ? Duration.zero : remaining,
      progress: progress,
      session: session,
    );
  }

  Future<void> startFast({int hours = 16}) async {
    try {
      final isar = await ref.read(isarDatabaseProvider.future);
      final now = DateTime.now();

      final newSession = FastingSession()
        ..startTime = now
        ..targetDurationMinutes = hours * 60
        ..protocolLabel = "$hours:${24 - hours}";

      await isar.writeTxn(() async {
        await isar.fastingSessions.put(newSession);
      });

      _startTimer(newSession);
      _startOngoingNotification(newSession);

      // Schedule completion notification if enabled
      final settings = ref.read(notificationSettingsProvider);
      if (settings.fastCompletionEnabled) {
        final scheduledTime = now.add(Duration(hours: hours));
        ref
            .read(notificationServiceProvider)
            .scheduleNotification(
              id: 0,
              title: "Fasting Complete! 🎉",
              body: "You've successfully completed your $hours-hour fast.",
              scheduledTime: scheduledTime,
            );
      }

      state = AsyncValue.data(_calculateState(newSession));
    } catch (e, stackTrace) {
      debugPrint('Error starting fast: $e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> endFast() async {
    try {
      // Immediately cancel all timers
      _timer?.cancel();
      _timer = null;
      _notificationTimer?.cancel();
      _notificationTimer = null;

      final currentState = state.value;
      if (currentState?.session == null) {
        state = const AsyncValue.data(FastingState(isFasting: false));
        return;
      }

      final isar = await ref.read(isarDatabaseProvider.future);
      final session = currentState!.session!;
      session.endTime = DateTime.now();

      await isar.writeTxn(() async {
        await isar.fastingSessions.put(session);
      });

      // Cancel all notifications (ongoing + scheduled)
      await ref.read(notificationServiceProvider).cancelAll();

      // Immediately update state to not fasting
      state = const AsyncValue.data(FastingState(isFasting: false));
    } catch (e) {
      debugPrint('Error ending fast: $e');
      // Still try to reset state even on error
      state = const AsyncValue.data(FastingState(isFasting: false));
    }
  }

  // Allow manual adjustment of start time
  Future<void> updateStartTime(DateTime newStart) async {
    try {
      final currentState = state.value;
      if (currentState?.session == null || !currentState!.isFasting) return;

      final isar = await ref.read(isarDatabaseProvider.future);

      // Validate: new start time must be in the past
      if (newStart.isAfter(DateTime.now())) return;

      // Get fresh session from database to ensure we have the correct ID
      final sessionId = currentState.session!.id;
      final session = await isar.fastingSessions.get(sessionId);
      if (session == null) return;

      // Update the start time
      session.startTime = newStart;

      await isar.writeTxn(() async {
        await isar.fastingSessions.put(session);
      });

      // Cancel scheduled completion notification first (id: 0), but NOT the ongoing one (id: 1)
      await ref.read(notificationServiceProvider).cancel(0);

      // Restart timers with updated session
      _startTimer(session);
      _startOngoingNotification(session);

      // Reschedule notification based on new start time if enabled
      final targetMinutes = session.targetDurationMinutes ?? 960;
      final newEndTime = newStart.add(Duration(minutes: targetMinutes));

      final settings = ref.read(notificationSettingsProvider);
      if (settings.fastCompletionEnabled &&
          newEndTime.isAfter(DateTime.now())) {
        ref
            .read(notificationServiceProvider)
            .scheduleNotification(
              id: 0,
              title: "Fasting Complete! 🎉",
              body: "You've successfully completed your fast.",
              scheduledTime: newEndTime,
            );
      }

      // Update state with the fresh session from database
      state = AsyncValue.data(_calculateState(session));
    } catch (e) {
      debugPrint('Error updating start time: $e');
    }
  }
}
