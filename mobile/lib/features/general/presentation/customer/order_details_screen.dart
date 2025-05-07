import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Order order = Order.sampleOrder();
    final theme = Theme.of(context);

    return NestScaffold(
      showBackButton: true,
      backButtonOnPressed: () {
        ref.read(bottomNavigationProvider.notifier).state = 1;
        context.goNamed('bottom_nav');
      },
      title: 'Order details',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NestButton(
              text: 'Check status',
              onPressed: () => context.pushNamed("track_order"),
            ),
            SizedBox(height: 3.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/delivery_image.png"),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: 25.w,
                  height: 25.w,
                ),
                SizedBox(width: 4.w),

                // Order info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      _buildInfoRow(
                        theme,
                        'Status',
                        order.status,
                        textColor: _getStatusColor(order.status, context),
                      ),
                      _buildInfoRow(
                        theme,
                        'Ordered on',
                        DateFormat('MMM d, yyyy').format(order.orderDate),
                      ),
                      _buildInfoRow(
                        theme,
                        'Total',
                        '\$${order.total.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Delivery section
            _buildSectionTitle(theme, 'Delivery Details'),
            SizedBox(height: 2.h),

            // Delivery Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Date',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => _showDatePicker(context, order.deliveryDate),
                        child: Text(
                          'Change',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        DateFormat(
                          'EEEE, MMM d, yyyy',
                        ).format(order.deliveryDate),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Delivery Address',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          order.address,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Order items section
            _buildSectionTitle(theme, 'Order Items'),
            SizedBox(height: 1.h),

            // Item list
            ...order.items.map((item) => _buildOrderItemCard(context, item)),

            SizedBox(height: 4.h),

            // Order actions
            order.status != "Completed"
                ? NestButton(
                  text: 'Confirm Completion',
                  onPressed: () => _showCompletionDialog(context, ref),
                  color: theme.colorScheme.onPrimary,
                )
                : Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.onPrimary),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 2.w),
                      Text(
                        'Order completed',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

            SizedBox(height: 2.h),

            NestButton(
              text: 'Need Help?',
              onPressed: () => _showHelpOptions(context),
              color: theme.colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value, {
    Color? textColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(BuildContext context, OrderItem item) {
    final theme = Theme.of(context);

    String getItemIcon() {
      switch (item.name.toLowerCase()) {
        case 'outer wear':
          return 'jacket_icon';
        case 'shirt':
          return 'tshirt_icon';
        case 'dress':
          return 'dress_icon';
        case 'bottom':
          return 'jeans_icon';
        case 'underwear':
          return 'bra_icon';
        default:
          return 'tshirt_icon';
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Item icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconImageWidget(
              iconName: getItemIcon(),
              color: Colors.blue.shade700,
              width: 1.w,
              height: 1.h,
            ),
          ),
          SizedBox(width: 3.w),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${item.category} • \$${item.price.toStringAsFixed(2)} each',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Quantity and price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${item.quantity}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    final theme = Theme.of(context);
    switch (status.toLowerCase()) {
      case 'completed':
        return theme.colorScheme.onPrimary;
      case 'in progress':
        return theme.colorScheme.primary;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
      default:
        return theme.colorScheme.primaryContainer.withValues(alpha: 0.5);
    }
  }

  void _showDatePicker(BuildContext context, DateTime initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      ToastUtil.showSuccessToast(
        context,
        'Delivery date updated to ${DateFormat('MMM d, yyyy').format(pickedDate)}',
      );
    }
  }

  void _showCompletionDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Order Completion'),
            titleTextStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            content: Text(
              'Are you sure you want to mark this order as completed?',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text('Cancel', style: theme.textTheme.bodyMedium),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update order status in state management
                  ToastUtil.showSuccessToast(
                    context,
                    'Order marked as completed!',
                  );
                  ref.read(bottomNavigationProvider.notifier).state = 1;
                  context.goNamed("bottom_nav");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text(
                  'Confirm',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showHelpOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How can we help?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                _buildHelpOption(context, Icons.message, 'Chat with support'),
                _buildHelpOption(context, Icons.phone, 'Call customer service'),
                _buildHelpOption(context, Icons.email, 'Email us'),
              ],
            ),
          ),
    );
  }

  Widget _buildHelpOption(BuildContext context, IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () {
        context.pop();
      },
    );
  }
}
