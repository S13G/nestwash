import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends HookConsumerWidget {
  final Order order = Order.sampleOrder()[2];

  OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: 'order details',
      body: Column(
        children: [
          // Content
          Expanded(
            child: SlideTransition(
              position: animations.slideAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Status Card
                      _buildOrderStatusCard(theme),
                      SizedBox(height: 3.h),

                      // Order Items Section
                      _buildOrderItemsSection(theme),
                      SizedBox(height: 3.h),

                      // Service Provider Section
                      _buildServiceProviderSection(theme, context),
                      SizedBox(height: 3.h),

                      // Delivery Information
                      _buildDeliverySection(theme),
                      SizedBox(height: 3.h),

                      // Payment Summary
                      _buildPaymentSummarySection(theme),
                      SizedBox(height: 3.h),

                      // Action Buttons
                      _buildActionButtons(theme, context),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [OrderUtils.getOrderStatusColor(order.status), OrderUtils.getOrderStatusColor(order.status).withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(color: OrderUtils.getOrderStatusColor(order.status).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2.w)),
                child: Icon(OrderUtils.getStatusIcon(order.status), color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(OrderUtils.getOrderStatusText(order.status), style: theme.textTheme.titleSmall?.copyWith(color: Colors.white)),
                    Text(
                      order.serviceType,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Order Date: ${OrderUtils.formatDate(order.orderDate)}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 1.h),
          Text(
            order.status == OrderStatus.completed
                ? 'Expected Delivery: Order delivered'
                : 'Expected Delivery: ${OrderUtils.formatDate(order.deliveryDate)}',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
          ),
          if (order.deliveryDelayReason != null) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3.w)),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 4.w),
                  SizedBox(width: 2.w),
                  Expanded(child: Text(order.deliveryDelayReason!, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items (${order.items.length})', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 3.h),
          ...order.items.map((item) => _buildOrderItem(item, theme)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3.w)),
            child: Icon(OrderUtils.getItemIcon(item.name), color: theme.colorScheme.primary, size: 6.w),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '${item.category} • Qty: ${item.quantity}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildServiceProviderSection(ThemeData theme, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Provider', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 3.h),
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(7.5.w),
                ),
                child: Icon(Icons.store, color: Colors.white, size: 7.w),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CleanPro Laundry', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 4.w),
                        SizedBox(width: 1.w),
                        Text('4.8 (1,234 reviews)', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '2.5 km away • Est. pickup in 30 mins',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),

              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2.w)),
                      child: Icon(Icons.phone, color: theme.colorScheme.primary, size: 5.w),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () => context.pushNamed("chat"),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2.w)),
                      child: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.onSurface, size: 5.w),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Information', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 3.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(color: theme.colorScheme.onPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3.w)),
                child: Icon(Icons.location_on, color: theme.colorScheme.onPrimary, size: 6.w),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Address', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 1.h),
                    Text(order.address, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummarySection(ThemeData theme) {
    final subtotal = order.totalPrice * 0.85;
    final tax = order.totalPrice * 0.08;
    final deliveryFee = order.totalPrice * 0.07;
    final serviceCharge = order.totalPrice * 0.03;

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
          Text('Payment Summary', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 3.h),
          _buildPaymentRow(theme, 'Subtotal', subtotal),
          _buildPaymentRow(theme, 'Tax', tax),
          _buildPaymentRow(theme, 'Delivery Fee', deliveryFee),
          _buildPaymentRow(theme, 'Service Charge', serviceCharge),
          SizedBox(height: 2.h),
          Container(height: 1, color: theme.colorScheme.surface),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                '\$${order.totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(ThemeData theme, String label, double amount) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
          Text('\$${amount.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        if (order.status != OrderStatus.completed &&
            order.status != OrderStatus.cancelled &&
            order.status != OrderStatus.pending &&
            order.status != OrderStatus.readyForPickup)
          SizedBox(
            width: double.infinity,
            height: 10.h,
            child: NestButton(
              onPressed: () => _showOrderCompletionCodeDialog(context, theme),
              text: 'Complete Order',
              color: theme.colorScheme.onPrimary,
            ),
          ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(height: 10.h, child: NestOutlinedButton(onPressed: () => contactSupport(context), text: 'Get Help', mediumText: true)),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: SizedBox(
                height: 10.h,
                child: NestButton(onPressed: () => context.pushNamed("track_order"), text: 'Track Order', mediumText: true),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showOrderCompletionCodeDialog(BuildContext context, ThemeData theme) {
    final random = Random();
    final completionCode = List.generate(6, (index) => random.nextInt(10)).join(); // Generates a 6-digit code

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.circular(6.w),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9.w),
                  ),
                  child: Icon(Icons.check_circle_outline, color: Colors.white, size: 9.w),
                ),
                SizedBox(height: 4.h),

                // Title
                Text('Order Completed!', style: theme.textTheme.titleSmall, textAlign: TextAlign.center),
                SizedBox(height: 2.h),

                // Message
                Text(
                  'Please provide this 6-digit code to the delivery person to confirm your order completion.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),

                // Completion Code
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 1.5),
                  ),
                  child: Text(
                    completionCode,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 8, color: theme.colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5.h),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  height: 8.h,
                  child: NestButton(
                    onPressed: () {
                      dialogContext.pop();
                      ToastUtil.showSuccessToast(context, "Your order is completed");
                    },
                    text: 'Got It!',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void contactSupport(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'siliconsynergy2024@gmail.com',
      queryParameters: {'subject': 'Order Support Request', 'body': 'Please provide more details about your order.'},
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (!context.mounted) return;
        ToastUtil.showErrorToast(context, "Could not launch email client.");
      }
    } catch (e) {
      if (!context.mounted) return;
      ToastUtil.showErrorToast(context, "An error occurred: ${e.toString()}");
    }
  }
}
