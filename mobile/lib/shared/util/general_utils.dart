import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nestcare/core/config/app_theme.dart';

enum FilterType { all, active, past }

enum DiscountFilter { all, active, expired, completed }

enum OrderStatus {
  active,
  completed,
  cancelled,
  pending,
  readyForPickup,
  readyForDelivery,
  outForDelivery,
}

enum ReviewFilterType { all, fiveStar, fourStar, threeStar, twoStar, oneStar }

enum ReviewSortType { newest, oldest, highestRated, lowestRated }

class OrderUtils {
  static Color getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.active:
        return AppColors.onPrimary;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.pending:
        return AppColors.accent;
      case OrderStatus.readyForPickup:
        return Colors.amber;
      case OrderStatus.readyForDelivery:
        return Colors.orange;
      case OrderStatus.outForDelivery:
        return Colors.blue;
    }
  }

  static String getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.active:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.readyForPickup:
        return 'Ready for pickup';
      case OrderStatus.readyForDelivery:
        return 'Ready for delivery';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
    }
  }

  static double getOrderStatusProgressBarValue(OrderStatus status) {
    switch (status) {
      case OrderStatus.active:
        return 0.5;
      case OrderStatus.completed:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
      case OrderStatus.pending:
        return 0.25;
      case OrderStatus.readyForPickup:
        return 0.3;
      case OrderStatus.readyForDelivery:
        return 0.75;
      case OrderStatus.outForDelivery:
        return 0.85;
    }
  }

  static IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.active:
        return Icons.local_laundry_service;
      case OrderStatus.readyForDelivery:
        return Icons.local_shipping;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.readyForPickup:
        return Icons.local_shipping;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  static IconData getItemIcon(String itemName) {
    switch (itemName.toLowerCase()) {
      case 'shirt':
      case 'shirts':
        return Icons.checkroom;
      case 'jeans':
      case 'trousers':
        return Icons.accessibility;
      case 'outer wear':
        return Icons.sports;
      default:
        return Icons.shopping_bag;
    }
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today, ${DateFormat('hh:mm a').format(date)}';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return DateFormat('dd/MM/yyyy, hh:mm a').format(date);
    }
  }

  static String getTimelineTitleForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.active:
        return 'In Processing';
      case OrderStatus.readyForDelivery:
        return 'Out for Delivery';
      case OrderStatus.completed:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Order Cancelled';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
    }
  }

  static String getTimelineDescriptionForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Your order has been successfully placed and is awaiting confirmation.';
      case OrderStatus.readyForPickup:
        return 'Your order is ready. A driver is assigned and on their way for pickup.';
      case OrderStatus.active:
        return 'Your items are currently being handled at the facility.';
      case OrderStatus.readyForDelivery:
        return 'Your freshly cleaned clothes are on their way back to you!';
      case OrderStatus.completed:
        return 'Your order has been successfully delivered and confirmed.';
      case OrderStatus.cancelled:
        return 'This order was cancelled by you or the service provider.';
      case OrderStatus.outForDelivery:
        return 'Your order is out for delivery. Please wait for the driver to arrive.';
    }
  }
}
