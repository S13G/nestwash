import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/notifications_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/notifications_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotificationsScreen extends HookConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final filteredNotifications = ref.watch(filteredNotificationsProvider);
    final allUnreadNotifications = ref.watch(allUnreadNotificationsProvider);
    final showUnreadOnly = ref.watch(showUnreadOnlyProvider);

    final animations = useLaundryAnimations(null);

    return NestScaffold(
      padding: EdgeInsets.zero,
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          children: [
            // header
            _buildHeader(theme, ref),
            SizedBox(height: 2.h),

            // filter toggle
            _buildFilterToggle(
              theme,
              ref,
              showUnreadOnly,
              allUnreadNotifications,
            ),
            SizedBox(height: 2.h),

            // notifications list and empty state
            Expanded(
              child:
                  filteredNotifications.isEmpty
                      ? FadeTransition(
                        opacity: animations.fadeAnimation,
                        child: _buildEmptyState(theme, showUnreadOnly),
                      )
                      : SlideTransition(
                        position: animations.slideAnimation,
                        child: _buildNotificationsList(
                          filteredNotifications,
                          theme,
                          ref,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Text('Notifications', style: theme.textTheme.titleMedium),
        ),
        GestureDetector(
          onTap: () {
            ref.read(allNotificationsProvider.notifier).markAllAsRead();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Text(
              'Mark all read',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterToggle(
    ThemeData theme,
    WidgetRef ref,
    bool showUnreadOnly,
    List<NotificationItem> allUnreadNotifications,
  ) {
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(showUnreadOnlyProvider.notifier).state = false;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.w),
                decoration: BoxDecoration(
                  color:
                      !showUnreadOnly
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Text(
                  'All',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        !showUnreadOnly
                            ? Colors.white
                            : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(showUnreadOnlyProvider.notifier).state = true;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 3.w),
                decoration: BoxDecoration(
                  color:
                      showUnreadOnly
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Unread',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            showUnreadOnly
                                ? Colors.white
                                : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    if (allUnreadNotifications.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color:
                              showUnreadOnly
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Text(
                          '${allUnreadNotifications.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<NotificationItem> notifications,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 3.w),
          child: _buildNotificationCard(notifications[index], theme, ref),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    NotificationItem notification,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(allNotificationsProvider.notifier).markAsRead(notification.id);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(4.w),
          border:
              notification.isRead
                  ? null
                  : Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
          boxShadow: [
            BoxShadow(
              color:
                  notification.isRead
                      ? Colors.black.withValues(alpha: 0.05)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: notification.getColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Icon(
                    notification.getIcon(),
                    color: notification.getColor(),
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 2.5.w,
                              height: 2.5.w,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(1.25.w),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.w),
                      Text(
                        notification.getCategory(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: notification.getColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Text(
              notification.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                height: 1.4,
              ),
            ),
            SizedBox(height: 3.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                if (notification.orderId != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.w,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Text(
                      notification.orderId!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool showUnreadOnly) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Icon(
            Icons.notifications_none,
            size: 20.w,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          showUnreadOnly ? 'No Unread Notifications' : 'No Notifications Yet',
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Text(
          showUnreadOnly
              ? 'All caught up! You have no unread notifications.'
              : 'When you have notifications, they\'ll appear here.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
