import 'package:flutter/material.dart';

enum FastingProtocol {
  f16_8("16:8", 16, "Traditional Lean Gains"),
  f18_6("18:6", 18, "Intermediate"),
  f20_4("20:4", 20, "Warrior Diet"),
  omad("OMAD", 23, "One Meal A Day"),
  adf("ADF", 36, "Alternate Day Fast"),
  custom("Custom", 0, "Set Your Own Duration");

  final String label;
  final int hours;
  final String description;

  const FastingProtocol(this.label, this.hours, this.description);
}

class ProtocolSelector extends StatelessWidget {
  final FastingProtocol selectedProtocol;
  final ValueChanged<FastingProtocol> onProtocolChanged;

  const ProtocolSelector({
    super.key,
    required this.selectedProtocol,
    required this.onProtocolChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: FastingProtocol.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final protocol = FastingProtocol.values[index];
          final isSelected = protocol == selectedProtocol;
          final colorScheme = Theme.of(context).colorScheme;

          return GestureDetector(
            onTap: () => onProtocolChanged(protocol),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    protocol.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    protocol.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.8,
                            )
                          : colorScheme.onSurfaceVariant,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
