import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_form_fields.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderOrderDetailsScreen extends ConsumerWidget {
  const ServiceProviderOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Order order = Order.sampleOrder();
    final theme = Theme.of(context);

    return NestScaffold(
      showBackButton: true,
      backButtonOnPressed: () {
        context.pop();
      },
      title: 'Order details',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(
                        "assets/images/delivery_man_image.png",
                      ),
                    ),
                    SizedBox(width: 2.w),

                    // Order info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                ),
                              ),
                              _buildStatusChip(order.status, theme),
                            ],
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
              ),
            ),

            SizedBox(height: 3.h),

            // Action buttons
            _buildActionButtons(context, order),
            SizedBox(height: 3.h),

            // Update status section
            _buildStatusUpdateSection(order, theme),
            SizedBox(height: 3.h),

            // Delivery Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Delivery Details",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
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
                          onTap: () => _showUpdateDeliveryDateDialog(context),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    if (order.deliveryDelayReason!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                "Delay reason: ${order.deliveryDelayReason}",
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
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
            ),

            SizedBox(height: 3.h),

            // Item list
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue.shade50.withValues(alpha: 0.9),
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Order Items",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ...order.items.map(
                      (item) => _buildOrderItemCard(context, item),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case "in progress":
        color = Colors.blue;
        icon = Icons.sync;
        break;
      case "pickup arranged":
        color = theme.colorScheme.onPrimary;
        icon = Icons.local_shipping_outlined;
        break;
      case "laundry in process":
        color = theme.colorScheme.primary;
        icon = Icons.local_laundry_service_outlined;
        break;
      case "laundry complete":
        color = Colors.blue;
        icon = Icons.local_laundry_service_outlined;
        break;
      case "ready for delivery":
        color = Colors.purple;
        icon = Icons.local_shipping_outlined;
        break;
      case "out for delivery/picked up":
        color = Colors.indigo;
        icon = Icons.local_shipping;
        break;
      case "delivered":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "cancelled":
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info_outline;
    }

    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                status,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildActionButtons(BuildContext context, Order order) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showDeclineDialog(context, order),
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            label: const Text("Decline"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _acceptOrder(context, order),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Accept"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _acceptOrder(BuildContext context, Order order) {
    order.status = "In Progress";
    ToastUtil.showSuccessToast(context, "Order accepted successfully");
  }

  void _showDeclineDialog(BuildContext context, Order order) {
    final TextEditingController reasonController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Decline Order"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Please provide a reason for declining this order:"),
              SizedBox(height: 4.h),
              NestFormField(
                controller: reasonController,
                hintText: "Enter reason",
                maxLines: 3,
                belowSpacing: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text("Cancel", style: theme.textTheme.bodyMedium),
            ),
            ElevatedButton(
              onPressed: () {
                if (reasonController.text.trim().isNotEmpty) {
                  context.pop();
                  _declineOrder(context, order);
                } else {
                  ToastUtil.showErrorToast(
                    context,
                    "Please provide a reason for declining this order.",
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                "Decline",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _declineOrder(BuildContext context, Order order) {
    order.status = "Cancelled";

    ToastUtil.showSuccessToast(context, "Order declined successfully");
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

  Widget _buildStatusUpdateSection(Order order, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.update, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "Update Status",
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusButton(
                    "In Progress",
                    Icons.sync,
                    Colors.blue,
                    order.status == "In Progress",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Pickup arranged",
                    Icons.local_shipping_outlined,
                    theme.colorScheme.onPrimary,
                    order.status == "Pickup arranged",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Laundry in process",
                    Icons.local_laundry_service_outlined,
                    theme.colorScheme.primary,
                    order.status == "Laundry in process",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Laundry complete",
                    Icons.local_laundry_service_outlined,
                    Colors.blue,
                    order.status == "Laundry in process",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Ready for Delivery",
                    Icons.local_shipping_outlined,
                    Colors.purple,
                    order.status == "Ready for Delivery",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Out for Delivery/Picked up",
                    Icons.local_shipping,
                    Colors.indigo,
                    order.status == "Out for Delivery",
                  ),
                  const SizedBox(width: 8),
                  _buildStatusButton(
                    "Delivered",
                    Icons.check_circle,
                    Colors.green,
                    order.status == "Delivered",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(
    String status,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              status,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDeliveryDateDialog(BuildContext context) {
    final Order order = Order.sampleOrder();
    final theme = Theme.of(context);

    DateTime selectedDate = order.deliveryDate;
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Delivery Date"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select new delivery date:"),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(DateFormat.yMMMd().format(selectedDate)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  const Text("Reason for changing delivery date:"),
                  SizedBox(height: 1.h),
                  NestFormField(
                    controller: reasonController,
                    hintText: "Enter reason",
                    maxLines: 3,
                    belowSpacing: false,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text("Cancel", style: theme.textTheme.bodyMedium),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (selectedDate == order.deliveryDate) {
                      ToastUtil.showErrorToast(
                        context,
                        "Delivery date cannot be the same as the current date",
                      );
                      return;
                    } else if (reasonController.text.trim().isEmpty) {
                      ToastUtil.showErrorToast(
                        context,
                        "Please enter a reason for changing the delivery date",
                      );
                      return;
                    }
                    context.pop();
                    ToastUtil.showSuccessToast(
                      context,
                      "Delivery date updated to ${DateFormat.yMMMd().format(selectedDate)}",
                    );
                  },
                  child: Text(
                    "Update",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
