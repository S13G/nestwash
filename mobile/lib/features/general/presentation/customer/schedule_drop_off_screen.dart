// schedule_dropoff_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScheduleDropOffScreen extends ConsumerWidget {
  const ScheduleDropOffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeRange = ref.watch(selectedTimeRangeProvider);
    final preferredDay = ref.watch(selectedPreferredDayProvider);
    final theme = Theme.of(context);

    return NestScaffold(
      title: 'Schedule Drop-off',
      showBackButton: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose a time range', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 10,
            children:
                TimeRange.values.map((range) {
                  return ChoiceChip(
                    label: Text(_rangeLabel(range)),
                    selected: timeRange == range,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color:
                          timeRange == range
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                    ),
                    onSelected:
                        (_) =>
                            ref.read(selectedTimeRangeProvider.notifier).state =
                                range,
                  );
                }).toList(),
          ),
          SizedBox(height: 4.h),
          Text('Preferred delivery days', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          Column(
            children:
                PreferredDay.values.map((day) {
                  return RadioListTile<PreferredDay>(
                    title: Text(_dayLabel(day)),
                    value: day,
                    groupValue: preferredDay,
                    activeColor: theme.colorScheme.primary,
                    onChanged:
                        (val) =>
                            ref
                                .read(selectedPreferredDayProvider.notifier)
                                .state = val,
                  );
                }).toList(),
          ),
          const Spacer(),
          NestButton(
            text: 'Confirm',
            onPressed: () {
              if (timeRange == null || preferredDay == null) {
                ToastUtil.showErrorToast(
                  context,
                  'Please select time range and preferred day',
                );
                return;
              }
              context.pop(true);
            },
          ),
        ],
      ),
    );
  }

  String _rangeLabel(TimeRange range) {
    switch (range) {
      case TimeRange.morning:
        return 'Morning (8AM–12PM)';
      case TimeRange.afternoon:
        return 'Afternoon (12PM–4PM)';
      case TimeRange.evening:
        return 'Evening (4PM–7PM)';
    }
  }

  String _dayLabel(PreferredDay day) {
    switch (day) {
      case PreferredDay.anyDay:
        return 'Any day';
      case PreferredDay.weekendsOnly:
        return 'Weekends only';
      case PreferredDay.weekdaysOnly:
        return 'Weekdays only';
    }
  }
}
