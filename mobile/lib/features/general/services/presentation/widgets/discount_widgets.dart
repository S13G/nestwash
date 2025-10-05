import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ConfirmRow extends StatelessWidget {
  final String label;
  final String value;

  const ConfirmRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onCreate;
  const EmptyState({super.key, required this.theme, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 12.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              LucideIcons.badgePercent,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No discounts yet',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          Text(
            'Create limited-time offers to attract more customers.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.5.h),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onCreate();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.5.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.onTertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'Create Discount',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final String? helper;
  final int maxLines;
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType,
    this.helper,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        SizedBox(height: 0.5.h),
        TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            helperText: helper,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.2.h,
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        SizedBox(height: 0.5.h),
        DropdownButtonFormField<String>(
          initialValue: value.isEmpty ? null : value,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e, style: theme.textTheme.bodyLarge),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.2.h,
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleRow extends StatelessWidget {
  final String label;
  final bool isAmountBased;
  final ValueChanged<bool> onChanged;
  const ToggleRow({
    super.key,
    required this.label,
    required this.isAmountBased,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        const Spacer(),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              icon: Icon(LucideIcons.percent),
              label: Text('Percent'),
            ),
            ButtonSegment<bool>(
              value: true,
              icon: Icon(LucideIcons.banknote),
              label: Text('Amount'),
            ),
          ],
          selected: {isAmountBased},
          onSelectionChanged: (v) => onChanged(v.first),
        ),
      ],
    );
  }
}

class ExpiryPickerRow extends StatelessWidget {
  final ThemeData theme;
  final DateTime expiry;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  const ExpiryPickerRow({
    super.key,
    required this.theme,
    required this.expiry,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final td = TimeOfDay.fromDateTime(expiry);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(LucideIcons.calendar),
            label: Text(
              '${expiry.year}-${expiry.month.toString().padLeft(2, '0')}-${expiry.day.toString().padLeft(2, '0')}',
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPickTime,
            icon: const Icon(LucideIcons.clock),
            label: Text(td.format(context)),
          ),
        ),
      ],
    );
  }
}
