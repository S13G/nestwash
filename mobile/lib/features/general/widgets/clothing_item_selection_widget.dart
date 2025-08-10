
import 'package:flutter/material.dart';
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 4.w,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        underline: const SizedBox(),
        isDense: true,
        borderRadius: BorderRadius.circular(12),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface,
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
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
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
            padding: EdgeInsets.symmetric(vertical: 1.h),
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
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
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: enabled 
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 4.w,
        ),
      ),
    );
  }
}
