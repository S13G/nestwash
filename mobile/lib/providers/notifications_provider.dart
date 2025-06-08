// notifications_provider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/notifications_model.dart'; // Import your model

// Define a Notifier for your list of notifications
class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super(_initialNotifications); // Initialize with your dummy data

  // Initial dummy data (can be moved out to a separate constant if preferred)
  static final List<NotificationItem> _initialNotifications = [
    NotificationItem(
      id: '1',
      title: 'Order Completed! 🎉',
      description: 'Your laundry order #1234 has been completed and is ready for delivery.',
      type: NotificationType.completion,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      orderId: '#1234',
    ),
    NotificationItem(
      id: '2',
      title: '20% Off Your Next Order',
      description: 'Limited time offer! Get 20% off on your next wash & fold service.',
      type: NotificationType.discount,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: '3',
      title: 'Order In Progress',
      description: 'Your items are currently being washed. Estimated completion in 2 hours.',
      type: NotificationType.orderUpdate,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
      orderId: '#1235',
    ),
    NotificationItem(
      id: '4',
      title: 'Pickup Reminder',
      description: 'Don\'t forget! Your scheduled pickup is tomorrow at 10:00 AM.',
      type: NotificationType.reminder,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'New Service Available!',
      description: 'We now offer premium dry cleaning services. Try it today!',
      type: NotificationType.promotion,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  // controller method
  void markAsRead(String notificationId) {
    state = [
      for (final notification in state)
        if (notification.id == notificationId)
          notification.copyWith(isRead: true) // Create a new instance
        else
          notification,
    ];
  }

  // controller method
  void markAllAsRead() {
    state = [for (final notification in state) notification.copyWith(isRead: true)];
  }
}

final allNotificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
      (ref) => NotificationsNotifier(),
    );

final showUnreadOnlyProvider = StateProvider<bool>((ref) => false);

final filteredNotificationsProvider = StateProvider<List<NotificationItem>>((ref) {
  final allNotifications = ref.watch(allNotificationsProvider);
  final showUnreadOnly = ref.watch(showUnreadOnlyProvider);

  return showUnreadOnly ? allNotifications.where((n) => !n.isRead).toList() : allNotifications;
});

final allUnreadNotificationsProvider = StateProvider<List<NotificationItem>>((ref) {
  final allNotifications = ref.watch(allNotificationsProvider);
  return allNotifications.where((n) => !n.isRead).toList();
});
