// schedule_pickup_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
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
          Text('Choose a pickup date', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          InkWell(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? now,
                firstDate: now,
                lastDate: now.add(const Duration(days: 365)),
                builder:
                    (context, child) => Theme(
                      data: theme.copyWith(
                        colorScheme: ColorScheme.light(
                          primary: theme.colorScheme.primary,
                          onPrimary: Colors.white,
                          onSurface: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).state = picked;
              }
            },
            child: _ScheduleBox(
              label:
                  selectedDate != null
                      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : 'Select Date',
              icon: Icons.calendar_month,
            ),
          ),
          SizedBox(height: 4.h),
          Text('Choose a pickup time', style: theme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          InkWell(
            onTap: () async {
              final now = TimeOfDay.now();
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? now,
                builder:
                    (context, child) => Theme(
                      data: theme.copyWith(
                        colorScheme: ColorScheme.light(
                          primary: theme.colorScheme.primary,
                          onPrimary: Colors.white,
                          onSurface: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                ref.read(selectedTimeProvider.notifier).state = picked;
              }
            },
            child: _ScheduleBox(
              label:
                  selectedTime != null
                      ? selectedTime.format(context)
                      : 'Select Time',
              icon: Icons.access_time,
            ),
          ),
          const Spacer(),
          NestButton(
            text: 'Confirm',
            onPressed: () {
              if (selectedDate == null || selectedTime == null) {
                ToastUtil.showErrorToast(
                  context,
                  'Please select date and time',
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
}

class _ScheduleBox extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ScheduleBox({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.h),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          SizedBox(width: 2.h),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
