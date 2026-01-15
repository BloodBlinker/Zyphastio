import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/fasting/domain/fasting_session.dart';
import '../../features/profile/domain/weight_entry.dart';

part 'storage_service.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(IsarDatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();

  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [FastingSessionSchema, WeightEntrySchema],
      directory: dir.path,
      inspector: true,
    );
  }

  return Isar.getInstance()!;
}
