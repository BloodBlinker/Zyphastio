import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../../domain/weight_entry.dart';
import '../../../../shared/services/storage_service.dart';

part 'weight_controller.g.dart';

class WeightState {
  final List<WeightEntry> history;
  final double? currentWeight;
  final double? startingWeight;
  final double? changeFromStart;

  const WeightState({
    this.history = const [],
    this.currentWeight,
    this.startingWeight,
    this.changeFromStart,
  });
}

@riverpod
class WeightController extends _$WeightController {
  @override
  Future<WeightState> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);

    // Fetch all weight entries sorted by date descending
    final entries = await isar.weightEntrys
        .filter()
        .dateIsNotNull()
        .sortByDateDesc()
        .findAll();

    if (entries.isEmpty) {
      return const WeightState();
    }

    final current = entries.first.weightKg;
    final starting = entries.last.weightKg;
    final change = (current != null && starting != null)
        ? current - starting
        : null;

    return WeightState(
      history: entries,
      currentWeight: current,
      startingWeight: starting,
      changeFromStart: change,
    );
  }

  Future<void> addWeightEntry(double weightKg, {String? note}) async {
    final isar = await ref.read(isarDatabaseProvider.future);

    final entry = WeightEntry()
      ..date = DateTime.now()
      ..weightKg = weightKg
      ..note = note;

    await isar.writeTxn(() async {
      await isar.weightEntrys.put(entry);
    });

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> deleteEntry(int id) async {
    final isar = await ref.read(isarDatabaseProvider.future);

    await isar.writeTxn(() async {
      await isar.weightEntrys.delete(id);
    });

    ref.invalidateSelf();
  }
}
