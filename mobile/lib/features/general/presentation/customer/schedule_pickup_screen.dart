import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class SchedulePickupScreen extends HookConsumerWidget {
  const SchedulePickupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      title: 'Schedule Pickup',
      showBackButton: true,
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
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
              onTap: () => _selectDateWithCalendar(context, ref, selectedDate),
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
              onTap: () => _selectTimeWithDayNight(context, ref, selectedTime),
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

  Future<void> _selectDateWithCalendar(
    BuildContext context,
    WidgetRef ref,
    DateTime? currentDate,
  ) async {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: theme.colorScheme.primary,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: TextStyle(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: TextStyle(
        color: theme.colorScheme.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: TextStyle(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      disabledDayTextStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      selectableDayPredicate: (day) => !day.isBefore(now),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      // Action buttons configuration
      cancelButtonTextStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        fontWeight: FontWeight.w500,
      ),
      okButtonTextStyle: TextStyle(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );

    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: Size(85.w, 60.h),
      borderRadius: BorderRadius.circular(20),
      value: currentDate != null ? [currentDate] : [],
      dialogBackgroundColor: theme.colorScheme.surface,
    );

    if (values != null && values.isNotEmpty && values.first != null) {
      ref.read(selectedDateProvider.notifier).state = values.first!;
    }
  }

  Future<void> _selectTimeWithDayNight(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay? currentTime,
  ) async {
    final theme = Theme.of(context);

    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(
          hour: currentTime?.hour ?? TimeOfDay.now().hour,
          minute: currentTime?.minute ?? TimeOfDay.now().minute,
        ),
        onChange: (Time newTime) {
          ref.read(selectedTimeProvider.notifier).state = TimeOfDay(
            hour: newTime.hour,
            minute: newTime.minute,
          );
        },
        minuteInterval: TimePickerInterval.ONE,
        iosStylePicker: true,
        minHour: 7, // 7 AM
        maxHour: 19, // 7 PM
        is24HrFormat: true,
        accentColor: theme.colorScheme.primary,
        unselectedColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        cancelText: 'Cancel',
        okText: 'Confirm',
        blurredBackground: true,
        borderRadius: 20,
        elevation: 8,
      ),
    );
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
