import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ModernGenderDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const ModernGenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: Icon(
            LucideIcons.play,
            color: theme.colorScheme.secondary,
            size: 3.5.w,
          ),
        ),
        SizedBox(width: 1.2.w),
        DropdownButton<String>(
          value: value,
          icon: null,
          iconSize: 0,
          underline: const SizedBox(),
          isDense: true,
          borderRadius: BorderRadius.circular(12),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
          items: const [
            DropdownMenuItem(value: 'Men', child: Text('Men')),
            DropdownMenuItem(value: 'Women', child: Text('Women')),
            DropdownMenuItem(value: 'Both', child: Text('Both')),
          ],
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}

class ModernQuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;

  const ModernQuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            context,
            Icons.remove_rounded,
            () => quantity > 0 ? onChanged(-1) : null,
            quantity > 0,
          ),
          Container(
            width: 12.w,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          _buildQuantityButton(
            context,
            Icons.add_rounded,
            () => onChanged(1),
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context,
    IconData icon,
    VoidCallback? onTap,
    bool enabled,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 4.w,
        height: 4.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Icon(
          icon,
          color: theme.colorScheme.secondary,
          size: 4.w,
          weight: 4,
        ),
      ),
    );
  }
}
