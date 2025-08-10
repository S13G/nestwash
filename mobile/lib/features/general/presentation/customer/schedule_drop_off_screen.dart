import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ScheduleDropOffScreen extends ConsumerWidget {
  const ScheduleDropOffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeRange = ref.watch(selectedTimeRangeProvider);
    final theme = Theme.of(context);

    return NestScaffold(
      title: 'Schedule Drop-off',
      showBackButton: true,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 2.h),
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
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
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
                                    'Schedule Your Drop-off',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Choose when you want your clean laundry delivered',
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

                  // Time Range Selection Section
                  Text(
                    'Delivery Time Range',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  Column(
                    children:
                        TimeRange.values.map((range) {
                          final isSelected = timeRange == range;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: _ModernSelectionCard(
                              label: _rangeLabel(range),
                              icon: LucideIcons.clock,
                              isSelected: isSelected,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                ref
                                    .read(selectedTimeRangeProvider.notifier)
                                    .state = range;
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom button
          Column(
            children: [
              SizedBox(height: 1.5.h),
              NestButton(
                text: 'Confirm Drop-off Schedule',
                onPressed:
                    timeRange != null
                        ? () {
                          HapticFeedback.mediumImpact();
                          _completeDropoffStep(ref);
                          context.pop(true);
                        }
                        : null,
                color:
                    timeRange != null
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ],
      ),
    );
  }

  void _completeDropoffStep(WidgetRef ref) {
    // Mark step 3 (schedule dropoff) as completed
    final completed = [...ref.read(completedStepsProvider)];
    completed[3] = true;
    ref.read(completedStepsProvider.notifier).state = completed;

    // Update progress
    final newProgress =
        completed.where((step) => step).length / completed.length;
    ref.read(orderProgressProvider.notifier).state = newProgress;

    // Move to next step
    ref.read(currentStepProvider.notifier).state = 4;
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
}

class _ModernSelectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernSelectionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
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
