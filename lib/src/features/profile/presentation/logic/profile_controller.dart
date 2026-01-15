import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

class ProfileState {
  final double heightCm;
  final double weightKg;
  final int age;
  final bool isMale;

  const ProfileState({
    this.heightCm = 170,
    this.weightKg = 70,
    this.age = 25,
    this.isMale = true,
  });

  double get bmi {
    if (heightCm == 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  // Mifflin-St Jeor Equation
  double get bmr {
    // Men: (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) + 5
    // Women: (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) - 161
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return isMale ? base + 5 : base - 161;
  }

  ProfileState copyWith({
    double? heightCm,
    double? weightKg,
    int? age,
    bool? isMale,
  }) {
    return ProfileState(
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
    );
  }
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<ProfileState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return ProfileState(
      heightCm: prefs.getDouble('heightCm') ?? 170,
      weightKg: prefs.getDouble('weightKg') ?? 70,
      age: prefs.getInt('age') ?? 30,
      isMale: prefs.getBool('isMale') ?? true,
    );
  }

  Future<void> updateProfile({
    double? heightCm,
    double? weightKg,
    int? age,
    bool? isMale,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (heightCm != null) await prefs.setDouble('heightCm', heightCm);
    if (weightKg != null) await prefs.setDouble('weightKg', weightKg);
    if (age != null) await prefs.setInt('age', age);
    if (isMale != null) await prefs.setBool('isMale', isMale);

    state = AsyncValue.data(
      state.value!.copyWith(
        heightCm: heightCm,
        weightKg: weightKg,
        age: age,
        isMale: isMale,
      ),
    );
  }
}
