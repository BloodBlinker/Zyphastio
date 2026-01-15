import 'package:isar/isar.dart';

part 'fasting_session.g.dart';

@collection
class FastingSession {
  Id id = Isar.autoIncrement;

  DateTime? startTime;

  DateTime? endTime;

  int? targetDurationMinutes;

  String? protocolLabel;

  @ignore
  bool get isActive => endTime == null;

  @ignore
  Duration get targetDuration => Duration(minutes: targetDurationMinutes ?? 0);
}
