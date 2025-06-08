// notifications_model.dart
import 'package:flutter/material.dart';
import 'package:nestcare/core/config/app_theme.dart';

enum NotificationType { orderUpdate, discount, promotion, reminder, completion }

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? orderId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.orderId,
  });

  Color getColor() {
    switch (type) {
      case NotificationType.orderUpdate:
        return AppColors.primary;
      case NotificationType.discount:
        return AppColors.onTertiary;
      case NotificationType.promotion:
        return AppColors.accent;
      case NotificationType.reminder:
        return AppColors.onPrimary;
      case NotificationType.completion:
        return AppColors.onPrimary;
    }
  }

  IconData getIcon() {
    switch (type) {
      case NotificationType.orderUpdate:
        return Icons.local_laundry_service;
      case NotificationType.discount:
        return Icons.local_offer;
      case NotificationType.promotion:
        return Icons.campaign;
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.completion:
        return Icons.check_circle;
    }
  }

  String getCategory() {
    switch (type) {
      case NotificationType.orderUpdate:
        return 'ORDER UPDATE';
      case NotificationType.discount:
        return 'DISCOUNT';
      case NotificationType.promotion:
        return 'PROMOTION';
      case NotificationType.reminder:
        return 'REMINDER';
      case NotificationType.completion:
        return 'COMPLETED';
    }
  }

  // Method to create a new instance with isRead set to true
  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? orderId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
    );
  }
}
