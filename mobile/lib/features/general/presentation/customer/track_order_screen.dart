import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrackOrderScreen extends HookConsumerWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Order orderToTrack = Order.sampleOrder()[0];
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: 'order #${orderToTrack.id}',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(opacity: animations.fadeAnimation, child: _buildOrderSummaryCard(theme, orderToTrack)),
            SizedBox(height: 3.h),
            SlideTransition(position: animations.slideAnimation, child: _buildTimelineSection(theme, orderToTrack)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(ThemeData theme, Order order) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Icon(Icons.local_laundry_service_outlined, color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.serviceType, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${order.items.length} items • \$${order.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Status:', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: OrderUtils.getOrderStatusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  OrderUtils.getOrderStatusText(order.status),
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: OrderUtils.getOrderStatusColor(order.status)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTimelineEvents(OrderStatus currentOrderStatus) {
    final now = DateTime.now();

    // Define the canonical order of statuses for the timeline progression.
    const List<OrderStatus> timelineProgression = [
      OrderStatus.pending,
      OrderStatus.readyForPickup,
      OrderStatus.active,
      OrderStatus.readyForDelivery,
      OrderStatus.completed,
    ];

    // Determine the index of the order's current status in the progression.
    final currentStatusIndex = timelineProgression.indexOf(currentOrderStatus);

    // Dummy timestamps for past events to make them look realistic
    final Map<OrderStatus, DateTime> dummyTimestamps = {
      OrderStatus.pending: now.subtract(const Duration(days: 1, hours: 5, minutes: 30)),
      OrderStatus.readyForPickup: now.subtract(const Duration(hours: 10, minutes: 0)),
      OrderStatus.active: now.subtract(const Duration(hours: 1, minutes: 15)),
      OrderStatus.readyForDelivery: now.add(const Duration(hours: 4)),
      OrderStatus.completed: now.add(const Duration(hours: 8)),
    };

    return timelineProgression.asMap().entries.map((entry) {
      final index = entry.key;
      final status = entry.value;

      // Determine if this timeline item is completed or active based on the current order status.
      final bool isCompleted = index < currentStatusIndex;
      final bool isActive = index == currentStatusIndex;

      // Get appropriate timestamp (dummy past for completed/active, dummy future for upcoming)
      final DateTime timestamp = dummyTimestamps[status] ?? now.add(Duration(hours: (index - currentStatusIndex) * 6));

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

  Widget _buildTimelineSection(ThemeData theme, Order order) {
    final timelineEvents = _getTimelineEvents(order.status);

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Timeline', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
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

  Widget _buildTimelineItem(ThemeData theme, Map<String, dynamic> event, bool isLast) {
    final String title = event['title'];
    final String description = event['description'];
    final DateTime timestamp = event['timestamp'];
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
                        : theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: isCompleted || isActive ? Colors.white : theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
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
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1.5.w)),
                        ),
                      )
                      : null,
            ),
            if (!isLast)
              Container(width: 2, height: 8.h, color: isCompleted ? AppColors.primary.withValues(alpha: 0.3) : AppColors.hint.withValues(alpha: 0.2)),
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
                    color: isCompleted || isActive ? theme.colorScheme.secondary : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                SizedBox(height: 1.h),
                Text(OrderUtils.formatDate(timestamp), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
