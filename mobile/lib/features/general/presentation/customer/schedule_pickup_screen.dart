import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchedulePickupScreen extends ConsumerWidget {
  const SchedulePickupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final theme = Theme.of(context);

    return NestScaffold(
      title: 'Schedule Pickup',
      showBackButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.08),
                  theme.colorScheme.primary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedule Your Pickup',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Choose when our rider should collect your laundry',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Date Selection Section
          Text(
            'Pickup Date',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.5.h),

          _ModernScheduleCard(
            label:
                selectedDate != null
                    ? _formatDate(selectedDate)
                    : 'Select pickup date',
            icon: LucideIcons.calendar,
            isSelected: selectedDate != null,
            onTap: () => _selectDate(context, ref, selectedDate),
          ),

          SizedBox(height: 2.h),

          // Time Selection Section
          Text(
            'Pickup Time',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.5.h),

          _ModernScheduleCard(
            label:
                selectedTime != null
                    ? selectedTime.format(context)
                    : 'Select pickup time',
            icon: LucideIcons.clock,
            isSelected: selectedTime != null,
            onTap: () => _selectTime(context, ref, selectedTime),
          ),

          const Spacer(),

          // Bottom Action
          NestButton(
            text: 'Confirm Schedule',
            onPressed:
                selectedDate != null && selectedTime != null
                    ? () {
                      HapticFeedback.mediumImpact();
                      _completeScheduleStep(ref);
                      context.pop(true);
                    }
                    : null,
            color:
                selectedDate != null && selectedTime != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  void _completeScheduleStep(WidgetRef ref) {
    // Mark step 1 (schedule pickup) as completed
    final completed = [...ref.read(completedStepsProvider)];
    completed[1] = true;
    ref.read(completedStepsProvider.notifier).state = completed;

    // Update progress
    final newProgress =
        completed.where((step) => step).length / completed.length;
    ref.read(orderProgressProvider.notifier).state = newProgress;

    // Move to next step
    ref.read(currentStepProvider.notifier).state = 2;
  }

  Future<void> _selectDate(
    BuildContext context,
    WidgetRef ref,
    DateTime? currentDate,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                // onSurface: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay? currentTime,
  ) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime ?? now,
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                // onSurface: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      ref.read(selectedTimeProvider.notifier).state = picked;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

class _ModernScheduleCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernScheduleCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.all(4.5.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.06)
                  : theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.08),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isSelected
                          ? [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                          ]
                          : [
                            theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.1,
                            ),
                            theme.colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.05,
                            ),
                          ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color:
                    isSelected
                        ? Colors.white
                        : theme.colorScheme.onPrimaryContainer,
                size: 6.w,
              ),
            ),

            SizedBox(width: 4.w),

            // Label
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
