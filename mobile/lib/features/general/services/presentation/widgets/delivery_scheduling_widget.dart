import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeliverySchedulingWidget extends HookConsumerWidget {
  final Order order;
  final Function(DateTime, TimeRange, String?) onScheduleUpdate;

  const DeliverySchedulingWidget({
    super.key,
    required this.order,
    required this.onScheduleUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = useState(DateTime.now().add(const Duration(days: 1)));
    final selectedTimeRange = useState<TimeRange?>(null);
    final reasonController = useTextEditingController();
    final showReasonField = useState(false);

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.calendar,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Update Delivery Schedule',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Current Schedule Display
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Schedule:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      DateFormat(
                        'EEEE, MMM d, yyyy',
                      ).format(DateTime.now().add(const Duration(days: 2))),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Afternoon (12PM–4PM)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Date Selection
          Text(
            'New Delivery Date:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.h),

          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate.value,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 14)),
              );
              if (date != null) {
                selectedDate.value = date;
                showReasonField.value = true;
              }
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(selectedDate.value),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    LucideIcons.calendar,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Time Range Selection
          Text(
            'Delivery Time Range:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.h),

          Column(
            children:
                TimeRange.values.map((range) {
                  final isSelected = selectedTimeRange.value == range;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        selectedTimeRange.value = range;
                        showReasonField.value = true;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  )
                                  : theme.colorScheme.onTertiaryContainer,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color:
                                isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                gradient:
                                    isSelected
                                        ? LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.primary
                                                .withValues(alpha: 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                        : null,
                                color:
                                    isSelected
                                        ? null
                                        : theme.colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                borderRadius: BorderRadius.circular(1.5.w),
                              ),
                              child: Icon(
                                LucideIcons.clock,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              _rangeLabel(range),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          // Reason Field
          if (showReasonField.value) ...[
            SizedBox(height: 2.h),
            Text(
              'Reason for schedule change (visible to customer):',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'e.g., Earlier completion, customer request, weather conditions...',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],

          SizedBox(height: 3.h),

          // Update Button
          NestButton(
            text: 'Update Schedule',
            onPressed:
                selectedTimeRange.value != null
                    ? () {
                      HapticFeedback.mediumImpact();
                      onScheduleUpdate(
                        selectedDate.value,
                        selectedTimeRange.value!,
                        reasonController.text.isNotEmpty
                            ? reasonController.text
                            : null,
                      );
                      selectedTimeRange.value = null;
                      reasonController.clear();
                      showReasonField.value = false;
                      ToastUtil.showSuccessToast(
                        context,
                        'Delivery schedule updated successfully',
                      );
                    }
                    : null,
            color:
                selectedTimeRange.value != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.3),
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
}
