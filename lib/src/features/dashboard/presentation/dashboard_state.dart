import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/protocol_selector.dart';

final selectedProtocolProvider = StateProvider<FastingProtocol>(
  (ref) => FastingProtocol.f16_8,
);

/// Custom fasting hours when user selects "Custom" protocol
final customFastingHoursProvider = StateProvider<int>((ref) => 12);
