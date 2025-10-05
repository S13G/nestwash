import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderTimelineWidget extends HookConsumerWidget {
  final Order order;

  const ServiceProviderTimelineWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timelineEvents = _getTimelineEvents(order.status);

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timelineEvents.length,
            itemBuilder: (context, index) {
              final event = timelineEvents[index];
              final isLast = index == timelineEvents.length - 1;
              return _buildTimelineItem(theme, event, isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    ThemeData theme,
    Map<String, dynamic> event,
    bool isLast,
  ) {
    final String title = event['title'];
    final String description = event['description'];
    final DateTime? timestamp = event['timestamp'];
    final bool isCompleted = event['isCompleted'];
    final bool isActive = event['isActive'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color:
                    isCompleted
                        ? theme.colorScheme.primary
                        : isActive
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.3,
                        ),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color:
                      isCompleted || isActive
                          ? Colors.white
                          : theme.colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.5,
                          ),
                  width: 2,
                ),
              ),
              child:
                  isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 4.w)
                      : isActive
                      ? Center(
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.5.w),
                          ),
                        ),
                      )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 8.h,
                color:
                    isCompleted
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.hint.withValues(alpha: 0.2),
              ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isCompleted || isActive
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                if (timestamp != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    OrderUtils.formatDate(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getTimelineEvents(
    OrderStatus currentOrderStatus,
  ) {
    final now = DateTime.now();

    const List<OrderStatus> timelineProgression = [
      OrderStatus.pending,
      OrderStatus.readyForPickup,
      OrderStatus.active,
      OrderStatus.readyForDelivery,
      OrderStatus.completed,
    ];

    final currentStatusIndex = timelineProgression.indexOf(currentOrderStatus);

    final Map<OrderStatus, DateTime> dummyTimestamps = {
      OrderStatus.pending: now.subtract(
        const Duration(days: 1, hours: 5, minutes: 30),
      ),
      OrderStatus.readyForPickup: now.subtract(
        const Duration(hours: 10, minutes: 0),
      ),
      OrderStatus.active: now.subtract(const Duration(hours: 1, minutes: 15)),
      OrderStatus.readyForDelivery: now.add(const Duration(hours: 4)),
      OrderStatus.completed: now.add(const Duration(hours: 8)),
    };

    return timelineProgression.asMap().entries.map((entry) {
      final index = entry.key;
      final status = entry.value;

      final bool isCompleted = index < currentStatusIndex;
      final bool isActive = index == currentStatusIndex;

      final DateTime timestamp =
          dummyTimestamps[status] ??
          now.add(Duration(hours: (index - currentStatusIndex) * 6));

      return {
        'title': OrderUtils.getTimelineTitleForStatus(status),
        'description': OrderUtils.getTimelineDescriptionForStatus(status),
        'timestamp': timestamp,
        'correspondingStatus': status,
        'isCompleted': isCompleted,
        'isActive': isActive,
      };
    }).toList();
  }
}
