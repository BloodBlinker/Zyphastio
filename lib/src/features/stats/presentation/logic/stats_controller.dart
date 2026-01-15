import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../../../features/fasting/domain/fasting_session.dart';
import '../../../../shared/services/storage_service.dart';

part 'stats_controller.g.dart';

class StatsState {
  final int totalFasts;
  final int currentStreak;
  final double averageDurationHours;
  final List<double> weeklyData; // 7 days, Mon-Sun
  final List<double> monthlyData; // Last 30 days aggregated by week
  final List<FastingSession> history; // Completed fasts for history display
  final double? longestFastHours; // Personal best
  final int longestStreak; // Best streak ever

  const StatsState({
    this.totalFasts = 0,
    this.currentStreak = 0,
    this.averageDurationHours = 0,
    this.weeklyData = const [0, 0, 0, 0, 0, 0, 0],
    this.monthlyData = const [0, 0, 0, 0], // 4 weeks
    this.history = const [],
    this.longestFastHours,
    this.longestStreak = 0,
  });
}

@riverpod
class StatsController extends _$StatsController {
  @override
  Future<StatsState> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);

    // Fetch completed sessions sorted by end time
    final sessions = await isar.fastingSessions
        .filter()
        .endTimeIsNotNull()
        .sortByEndTimeDesc()
        .findAll();

    if (sessions.isEmpty) {
      return const StatsState();
    }

    // 1. Total Fasts
    final totalFasts = sessions.length;

    // 2. Average Duration
    final totalDurationMinutes = sessions.fold<int>(0, (sum, session) {
      if (session.startTime != null && session.endTime != null) {
        return sum + session.endTime!.difference(session.startTime!).inMinutes;
      }
      return sum;
    });
    final avgHours = (totalDurationMinutes / totalFasts) / 60;

    // 3. Current Streak - Robust implementation
    int streak = _calculateStreak(sessions);

    // 4. Weekly Data (Last 7 Days)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    ); // Mon

    List<double> weekly = List.filled(7, 0.0);

    for (var session in sessions) {
      if (session.endTime == null) continue;
      final end = session.endTime!;

      if (end.isAfter(startOfWeek.subtract(const Duration(seconds: 1)))) {
        // It's in this week
        final dayIndex = end.weekday - 1; // Mon=0, Sun=6
        final hours =
            session.endTime!.difference(session.startTime!).inMinutes / 60.0;
        weekly[dayIndex] += hours;
      }
    }

    // 5. Monthly Data (Last 4 weeks)
    List<double> monthly = List.filled(4, 0.0);
    for (int w = 0; w < 4; w++) {
      final weekStart = today.subtract(
        Duration(days: 7 * w + today.weekday - 1),
      );
      final weekEnd = weekStart.add(const Duration(days: 7));

      for (var session in sessions) {
        if (session.endTime == null || session.startTime == null) continue;
        final end = session.endTime!;

        if (end.isAfter(weekStart) && end.isBefore(weekEnd)) {
          final hours = end.difference(session.startTime!).inMinutes / 60.0;
          monthly[3 - w] += hours; // Reverse order: oldest first
        }
      }
    }

    // 6. Personal Best (Longest Fast)
    double? longestFast;
    for (var session in sessions) {
      if (session.startTime != null && session.endTime != null) {
        final hours =
            session.endTime!.difference(session.startTime!).inMinutes / 60.0;
        if (longestFast == null || hours > longestFast) {
          longestFast = hours;
        }
      }
    }

    // 7. Calculate actual longest streak from history
    int longestStreak = _calculateLongestStreak(sessions);

    return StatsState(
      totalFasts: totalFasts,
      currentStreak: streak,
      averageDurationHours: avgHours,
      weeklyData: weekly,
      monthlyData: monthly,
      history: sessions,
      longestFastHours: longestFast,
      longestStreak: longestStreak,
    );
  }

  /// Calculates the current fasting streak.
  int _calculateStreak(List<FastingSession> sessions) {
    if (sessions.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fastingDays = _getUniqueFastingDays(sessions);

    if (fastingDays.isEmpty) return 0;

    // Check if we fasted today or yesterday
    final yesterday = today.subtract(const Duration(days: 1));
    bool hasTodayOrYesterday =
        fastingDays.contains(today) || fastingDays.contains(yesterday);

    if (!hasTodayOrYesterday) return 0;

    return _calculateStreakFrom(today, fastingDays);
  }

  /// Helper to get unique fasting dates (stripped of time)
  Set<DateTime> _getUniqueFastingDays(List<FastingSession> sessions) {
    final Set<DateTime> days = {};
    for (final session in sessions) {
      if (session.endTime != null) {
        final endDate = session.endTime!;
        days.add(DateTime(endDate.year, endDate.month, endDate.day));
      }
    }
    return days;
  }

  /// Calculates global longest streak in history
  int _calculateLongestStreak(List<FastingSession> sessions) {
    if (sessions.isEmpty) return 0;

    final fastingDays = _getUniqueFastingDays(sessions);
    if (fastingDays.isEmpty) return 0;

    // Convert to sorted list for iteration
    final sortedDays = fastingDays.toList()..sort();

    int maxStreak = 0;

    // We can't just iterate simply because of the "skip day" logic.
    // The most robust way is to treat every fasting day as a potential end of a streak
    // and calculate backwards. This is O(N^2) worst case but N is days (small: 365/year).
    // Given the app scale, this is perfectly fine and accurate.

    for (final day in sortedDays) {
      final streakEndingHere = _calculateStreakFrom(day, fastingDays);
      if (streakEndingHere > maxStreak) {
        maxStreak = streakEndingHere;
      }
    }

    return maxStreak;
  }

  /// Calculates streak ending on a specific reference day (counting backwards)
  int _calculateStreakFrom(DateTime referenceDay, Set<DateTime> fastingDays) {
    int streak = 0;
    int skipsUsed = 0;
    const int maxSkips = 1; // Allow one skip day

    DateTime checkDay = referenceDay;

    // If the reference day itself isn't a fasting day, we check if counting back from it is valid
    // strictly speaking, usually we count streaks ending on a fasting day (or today).
    // For this helper, we assume we start counting FROM a valid context.
    // But let's act robustly: if referenceDay is not in set, and yesterday isn't, it's 0.
    // However, this helper is called in 2 contexts:
    // 1. Current streak: reference is TODAY (might not be fasted yet)
    // 2. Longest streak: reference is a FASTED DAY.

    // Logic:
    while (true) {
      if (fastingDays.contains(checkDay)) {
        streak++;
        skipsUsed = 0; // Reset skip count on a hit
      } else {
        skipsUsed++;
        if (skipsUsed > maxSkips) {
          break; // Streak broken
        }
        // Grace period consumed
      }
      checkDay = checkDay.subtract(const Duration(days: 1));

      // Sanity break (e.g. 10 years)
      if (referenceDay.difference(checkDay).inDays > 3650) break;
    }
    return streak;
  }
}
