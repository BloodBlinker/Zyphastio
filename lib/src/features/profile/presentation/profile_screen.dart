import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logic/profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: profileAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrics Cards
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'BMI',
                      value: state.bmi.toStringAsFixed(1),
                      unit: 'kg/m²',
                      color: _getBmiColor(state.bmi, colorScheme),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      label: 'BMR',
                      value: state.bmr.toStringAsFixed(0),
                      unit: 'kcal/day',
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // BMI Contextual Tip Card
              _HealthInsightCard(
                icon: _getBmiIcon(state.bmi),
                iconColor: _getBmiColor(state.bmi, colorScheme),
                title: _getBmiCategory(state.bmi),
                description: _getBmiTip(state.bmi),
              ),
              const SizedBox(height: 12),

              // Calorie Budget & Fasting Suggestion Card
              _HealthInsightCard(
                icon: Icons.local_fire_department,
                iconColor: colorScheme.tertiary,
                title: 'Daily Calorie Budget',
                description: _getCalorieSuggestion(state.bmr, state.bmi),
              ),
              const SizedBox(height: 12),

              // Fasting Recommendation Card
              _HealthInsightCard(
                icon: Icons.schedule,
                iconColor: colorScheme.primary,
                title: 'Recommended Fasting Protocol',
                description: _getFastingRecommendation(state.bmi, state.bmr),
              ),
              const SizedBox(height: 32),

              Text(
                'YOUR DETAILS',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),

              // Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    _SliderRow(
                      label: 'Height (cm)',
                      value: state.heightCm,
                      min: 100,
                      max: 250,
                      onChanged: (val) => ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(heightCm: val),
                    ),
                    const Divider(height: 32),
                    _SliderRow(
                      label: 'Weight (kg)',
                      value: state.weightKg,
                      min: 40,
                      max: 150,
                      onChanged: (val) => ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(weightKg: val),
                    ),
                    const Divider(height: 32),
                    _SliderRow(
                      label: 'Age',
                      value: state.age.toDouble(),
                      min: 10,
                      max: 100,
                      divisions: 90,
                      onChanged: (val) => ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(age: val.toInt()),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gender', style: theme.textTheme.bodyLarge),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: true, label: Text('Male')),
                            ButtonSegment(value: false, label: Text('Female')),
                          ],
                          selected: {state.isMale},
                          onSelectionChanged: (Set<bool> newSelection) {
                            ref
                                .read(profileControllerProvider.notifier)
                                .updateProfile(isMale: newSelection.first);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Weight Tracking Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEIGHT TRACKING',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddWeightDialog(
                      context,
                      ref,
                      colorScheme,
                      state.weightKg,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('LOG'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Track your weight over time',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap LOG to record your current weight',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddWeightDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    double currentWeight,
  ) {
    double weight = currentWeight;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log Weight',
                  style: Theme.of(dialogContext).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Text(
                  '${weight.toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Slider(
                  value: weight,
                  min: 30,
                  max: 200,
                  divisions: 170,
                  label: '${weight.toStringAsFixed(1)} kg',
                  onChanged: (val) {
                    setDialogState(() => weight = val);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Update profile weight
                      ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(weightKg: weight);
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Weight logged: ${weight.toStringAsFixed(1)} kg',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('SAVE WEIGHT'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions ?? (max - min).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _HealthInsightCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _HealthInsightCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper functions for BMI and health insights
Color _getBmiColor(double bmi, ColorScheme colorScheme) {
  if (bmi < 18.5) return colorScheme.tertiary; // Underweight - blue/info
  if (bmi < 25) return colorScheme.primary; // Normal - green/primary
  if (bmi < 30) return Colors.orange; // Overweight - warning
  return colorScheme.error; // Obese - error/red
}

IconData _getBmiIcon(double bmi) {
  if (bmi < 18.5) return Icons.trending_down;
  if (bmi < 25) return Icons.check_circle_outline;
  if (bmi < 30) return Icons.warning_amber_outlined;
  return Icons.error_outline;
}

String _getBmiCategory(double bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Healthy Weight';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}

String _getBmiTip(double bmi) {
  if (bmi < 18.5) {
    return 'Consider shorter fasting windows (12-14h) and focus on nutrient-dense meals during eating windows. Consult a healthcare provider if concerned.';
  }
  if (bmi < 25) {
    return 'Great job! Your weight is in a healthy range. Intermittent fasting can help maintain this and provide metabolic benefits.';
  }
  if (bmi < 30) {
    return 'Intermittent fasting (16:8 or 18:6) can be very effective for weight management. Combined with moderate exercise, you can achieve excellent results.';
  }
  return 'Extended fasting protocols (18:6 or 20:4) may accelerate weight loss. Start gradually and consult a healthcare provider for personalized advice.';
}

String _getCalorieSuggestion(double bmr, double bmi) {
  // TDEE estimate (BMR * activity factor) - assuming light activity (1.375)
  final tdee = (bmr * 1.375).round();

  if (bmi < 18.5) {
    final surplus = (tdee * 1.1).round(); // 10% surplus
    return 'Your estimated daily burn is ~$tdee kcal. For healthy weight gain, aim for ~$surplus kcal during eating windows.';
  }
  if (bmi < 25) {
    return 'Your estimated daily burn is ~$tdee kcal. Eating around this amount during your eating window maintains your healthy weight.';
  }
  if (bmi < 30) {
    final deficit = (tdee * 0.85).round(); // 15% deficit
    return 'Your estimated daily burn is ~$tdee kcal. A moderate deficit of ~$deficit kcal during eating windows supports gradual weight loss.';
  }
  final deficit = (tdee * 0.75).round(); // 25% deficit
  return 'Your estimated daily burn is ~$tdee kcal. Combined with extended fasting, consuming ~$deficit kcal can accelerate fat loss.';
}

String _getFastingRecommendation(double bmi, double bmr) {
  if (bmi < 18.5) {
    return '12:12 or 14:10 — Shorter fasts preserve muscle mass while still providing metabolic benefits. Focus on protein-rich meals.';
  }
  if (bmi < 25) {
    return '16:8 — The classic intermittent fasting protocol. Balances fat burning with sustainability for long-term health maintenance.';
  }
  if (bmi < 30) {
    return '18:6 — Extended fasting window maximizes fat burning. Consider 2-3 satisfying meals in your 6-hour eating window.';
  }
  return '20:4 or OMAD — Aggressive protocols that maximize autophagy and fat oxidation. Start with 16:8 and progress gradually.';
}
