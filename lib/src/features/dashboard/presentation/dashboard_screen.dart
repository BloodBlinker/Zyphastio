import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../fasting/presentation/logic/fasting_controller.dart';
import '../../../shared/providers/notification_settings_provider.dart';
import 'dashboard_state.dart';
import 'widgets/protocol_selector.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _formatDuration(Duration d) {
    if (d.inDays > 0) {
      return '${d.inDays}:${(d.inHours % 24).toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}';
    }
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String _formatEndTime(DateTime? end) {
    if (end == null) return '--:--';
    return DateFormat.jm().format(end);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fastingStateAsync = ref.watch(fastingControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'ZYPHASTIO',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: Icon(
                          Icons.notifications_outlined,
                          color: colorScheme.primary,
                        ),
                        title: const Text('Notifications'),
                        subtitle: const Text('Manage fast completion alerts'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          _showNotificationSettings(context, colorScheme);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                        ),
                        title: const Text('About Zyphastio'),
                        subtitle: const Text('Version 1.0.0'),
                        onTap: () {
                          Navigator.pop(context);
                          showAboutDialog(
                            context: context,
                            applicationName: 'Zyphastio',
                            applicationVersion: '1.0.0',
                            applicationLegalese: '© 2026 Zyphastio',
                            children: [
                              const SizedBox(height: 16),
                              const Text(
                                'A modern intermittent fasting tracker designed to help you achieve your health goals.',
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: fastingStateAsync.when(
            data: (state) {
              final isFasting = state.isFasting;
              final progress = state.progress;
              final displayTime = _formatDuration(state.elapsed);
              final statusText = isFasting
                  ? 'FASTING • ${state.session?.protocolLabel ?? "16:8"}'
                  : 'READY TO FAST';

              // Calculate predicted end time if fasting
              DateTime? predictedEnd;
              if (isFasting && state.session != null) {
                predictedEnd = state.session!.startTime!.add(
                  state.session!.targetDuration,
                );
              }

              return Column(
                children: [
                  const Spacer(),
                  // Central Timer UI
                  Center(
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.surface,
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isFasting
                                ? colorScheme.primary.withValues(alpha: 0.2)
                                : Colors.transparent,
                            blurRadius: 40,
                            spreadRadius: -5,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress Indicator
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: isFasting ? progress : 0,
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                          // Text Content
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFasting ? Icons.bolt : Icons.restaurant_menu,
                                color: isFasting
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                size: 32,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isFasting ? displayTime : '00:00:00',
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isFasting
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        )
                                      : colorScheme.secondaryContainer
                                            .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: isFasting
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (isFasting)
                                Text(
                                  'Ends at ${_formatEndTime(predictedEnd)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              else
                                Text(
                                  'Next Goal: 16 Hours',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Action Buttons
                  if (!isFasting) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ProtocolSelector(
                        selectedProtocol: ref.watch(selectedProtocolProvider),
                        onProtocolChanged: (p) {
                          ref.read(selectedProtocolProvider.notifier).state = p;
                          // Show custom hours dialog if custom selected
                          if (p == FastingProtocol.custom) {
                            _showCustomHoursDialog(context, ref, colorScheme);
                          }
                        },
                      ),
                    ),
                    // Show custom hours indicator
                    if (ref.watch(selectedProtocolProvider) ==
                        FastingProtocol.custom)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () =>
                              _showCustomHoursDialog(context, ref, colorScheme),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${ref.watch(customFastingHoursProvider)} hours',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.edit,
                                  color: colorScheme.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        if (isFasting) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _showAdjustStartDialog(
                                context,
                                ref,
                                colorScheme,
                                state.session!.startTime!,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(color: colorScheme.outline),
                              ),
                              child: const Text('ADJUST START'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(fastingControllerProvider.notifier)
                                    .endFast();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.errorContainer,
                                foregroundColor: colorScheme.onErrorContainer,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('END FAST'),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final p = ref.read(selectedProtocolProvider);
                                final hours = p == FastingProtocol.custom
                                    ? ref.read(customFastingHoursProvider)
                                    : p.hours;
                                ref
                                    .read(fastingControllerProvider.notifier)
                                    .startFast(hours: hours);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(_getStartButtonLabel(ref)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }

  String _getStartButtonLabel(WidgetRef ref) {
    final p = ref.watch(selectedProtocolProvider);
    if (p == FastingProtocol.custom) {
      return 'START FASTING (${ref.watch(customFastingHoursProvider)}h)';
    }
    return 'START FASTING (${p.label})';
  }

  void _showCustomHoursDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    int currentHours = ref.read(customFastingHoursProvider);

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Custom Fasting Duration',
                    style: Theme.of(dialogContext).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$currentHours hours',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: currentHours.toDouble(),
                    min: 1,
                    max: 72,
                    divisions: 71,
                    label: '$currentHours hours',
                    onChanged: (val) {
                      setDialogState(() {
                        currentHours = val.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  // Quick select chips - using Wrap to prevent overflow
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [12, 14, 18, 24, 36, 48].map((h) {
                      return ChoiceChip(
                        label: Text('${h}h'),
                        selected: currentHours == h,
                        onSelected: (_) {
                          setDialogState(() {
                            currentHours = h;
                          });
                        },
                        selectedColor: colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(customFastingHoursProvider.notifier).state =
                            currentHours;
                        Navigator.pop(dialogContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('SET DURATION'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAdjustStartDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    DateTime currentStart,
  ) async {
    DateTime selectedDate = currentStart;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(currentStart);

    // Pick Date
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (date == null || !context.mounted) return;
    selectedDate = date;

    // Pick Time
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time == null || !context.mounted) return;
    selectedTime = time;

    // Combine date and time
    final newStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Validate: must be in the past
    if (newStart.isAfter(DateTime.now())) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Start time must be in the past')),
        );
      }
      return;
    }

    // Update start time
    await ref
        .read(fastingControllerProvider.notifier)
        .updateStartTime(newStart);
  }

  void _showNotificationSettings(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => Consumer(
        builder: (dialogContext, ref, child) {
          final settings = ref.watch(notificationSettingsProvider);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(dialogContext).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your notification preferences',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Fast Completion'),
                  subtitle: const Text(
                    'Notify when your fasting goal is reached',
                  ),
                  value: settings.fastCompletionEnabled,
                  onChanged: (val) {
                    ref
                        .read(notificationSettingsProvider.notifier)
                        .setFastCompletionEnabled(val);
                  },
                  secondary: Icon(
                    Icons.celebration,
                    color: colorScheme.primary,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Ongoing Timer'),
                  subtitle: const Text(
                    'Show fasting progress in notification shade',
                  ),
                  value: settings.ongoingTimerEnabled,
                  onChanged: (val) {
                    ref
                        .read(notificationSettingsProvider.notifier)
                        .setOngoingTimerEnabled(val);
                  },
                  secondary: Icon(Icons.timer, color: colorScheme.primary),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('DONE'),
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
