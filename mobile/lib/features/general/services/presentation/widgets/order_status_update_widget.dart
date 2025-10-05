import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderStatusUpdateWidget extends HookConsumerWidget {
  final Order order;
  final Function(OrderStatus) onStatusUpdate;

  const OrderStatusUpdateWidget({
    super.key,
    required this.order,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedStatus = useState<OrderStatus?>(null);
    final statusOptions = _getAvailableStatusOptions(order.status);

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
                  LucideIcons.settings,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Update Order Status',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Current Status Display
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Current Status: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Status Options
          Text(
            'Update to:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 1.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children:
                statusOptions.map((status) {
                  final isSelected = selectedStatus.value == status;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      selectedStatus.value = status;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.8,
                                    ),
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
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            color:
                                isSelected
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _getStatusText(status),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),

          SizedBox(height: 2.h),

          // Update Button
          NestButton(
            text: 'Update Status',
            onPressed:
                selectedStatus.value != null
                    ? () {
                      HapticFeedback.mediumImpact();
                      onStatusUpdate(selectedStatus.value!);
                    }
                    : null,
            color:
                selectedStatus.value != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  List<OrderStatus> _getAvailableStatusOptions(OrderStatus currentStatus) {
    switch (currentStatus) {
      case OrderStatus.pending:
        return [OrderStatus.readyForPickup, OrderStatus.active];
      case OrderStatus.readyForPickup:
        return [OrderStatus.active];
      case OrderStatus.active:
        return [OrderStatus.readyForDelivery];
      case OrderStatus.readyForDelivery:
        return [OrderStatus.completed];
      case OrderStatus.completed:
        return [OrderStatus.completed];
      default:
        return [OrderStatus.cancelled];
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return Colors.blue;
      case OrderStatus.active:
        return Colors.purple;
      case OrderStatus.readyForDelivery:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return LucideIcons.clock;
      case OrderStatus.readyForPickup:
        return LucideIcons.package;
      case OrderStatus.active:
        return LucideIcons.play;
      case OrderStatus.readyForDelivery:
        return LucideIcons.truck;
      case OrderStatus.completed:
        return LucideIcons.checkCheck;
      case OrderStatus.cancelled:
        return LucideIcons.triangleAlert;
      default:
        return LucideIcons.triangleAlert;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.active:
        return 'In Progress';
      case OrderStatus.readyForDelivery:
        return 'Ready for Delivery';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
