import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/customer_details_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/delivery_scheduling_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/enhanced_order_items_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/order_status_update_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/service_provider_timeline_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderOrderDetailsScreen extends HookConsumerWidget {
  final String orderId;

  const ServiceProviderOrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);

    final order = Order.sampleOrder()[1];

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: 'Order #${order.id}',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Acceptance Section (Only shown for pending orders)
            if (order.status == OrderStatus.pending)
              FadeTransition(
                opacity: animations.fadeAnimation,
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(5.w),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.bell,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'New Order Request',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'This order requires your attention. Would you like to accept or decline it?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _handleOrderResponse(
                                  context,
                                  order,
                                  accept: true,
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: theme.colorScheme.onPrimary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Accept'),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _handleOrderResponse(
                                  context,
                                  order,
                                  accept: false,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    theme.colorScheme.onPrimaryContainer,
                                side: BorderSide(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text('Decline'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (order.status == OrderStatus.pending) SizedBox(height: 3.h),

            // Order Status Update Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: OrderStatusUpdateWidget(
                order: order,
                onStatusUpdate: (OrderStatus status) {},
              ),
            ),
            SizedBox(height: 3.h),

            // Customer Details Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: CustomerDetailsWidget(order: order),
            ),
            SizedBox(height: 3.h),

            // Enhanced Order Items Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: EnhancedOrderItemsWidget(order: order),
            ),
            SizedBox(height: 3.h),

            // Service Provider Timeline Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: ServiceProviderTimelineWidget(order: order),
            ),
            SizedBox(height: 3.h),

            // Delivery Scheduling Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: DeliverySchedulingWidget(
                order: order,
                onScheduleUpdate: (date, timeRange, reason) {},
              ),
            ),
            SizedBox(height: 3.h),

            // Payment Summary Section
            FadeTransition(
              opacity: animations.fadeAnimation,
              child: _buildPaymentSummarySection(theme, order),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummarySection(ThemeData theme, Order order) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            'Payment Summary',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3.h),
          _buildPaymentRow(theme, 'Subtotal', order.totalPrice - 5.0),
          SizedBox(height: 1.h),
          _buildPaymentRow(theme, 'Delivery Fee', 5.0),
          SizedBox(height: 2.h),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${order.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 5.w),
                SizedBox(width: 2.w),
                Text(
                  'Payment Completed',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          NestButton(
            text: 'Request Payment',
            onPressed: () => _handleRequestPayment(order),
            prefixIcon: Icon(LucideIcons.creditCard),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(ThemeData theme, String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _handleRequestPayment(Order order) {}

  void _handleOrderResponse(
    BuildContext context,
    Order order, {
    required bool accept,
  }) {
    if (accept) {
      // Set to ready for pickup by default when accepting
      order.status = OrderStatus.readyForPickup;
      ToastUtil.showSuccessToast(
        context,
        'Order accepted and marked as ready for pickup',
      );
    } else {
      order.status = OrderStatus.cancelled;
      ToastUtil.showInfoToast(
        context,
        'Order declined and marked as cancelled',
      );
    }
  }
}
