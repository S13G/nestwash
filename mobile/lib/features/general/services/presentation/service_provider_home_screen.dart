import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/widgets/menu_options_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderHomeScreen extends HookConsumerWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);
    final allActiveOrders = ref.watch(allActiveOrdersProvider);

    final animatedListKey = useRef(GlobalKey<AnimatedListState>()).value;
    final newOrderIds = useState<List<String>>([
      'LN2024001',
      'LN2024002',
      'LN2024003',
    ]);

    return NestScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: theme.colorScheme.surface,
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Header Section with Metrics
              _buildEnhancedHeader(theme),
              SizedBox(height: 3.h),

              // Earnings Dashboard
              _buildEarningsDashboard(theme, ref),
              SizedBox(height: 3.h),

              // Quick Actions Section
              _buildQuickActions(context, theme, ref),
              SizedBox(height: 3.h),

              // Upcoming Appointments
              _buildAppointmentsSection(theme, ref, allActiveOrders),
              SizedBox(height: 3.h),

              // New Orders Section
              _buildNewOrdersSection(
                context,
                theme,
                ref,
                animatedListKey,
                newOrderIds,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15.w,
                height: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.onTertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.userCheck,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, William👋',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Ready to serve your customers today?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 1.w),
              MenuOptionsWidget(),
            ],
          ),
          SizedBox(height: 3.h),
          // Key Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard(
                'Today\'s Orders',
                '12',
                LucideIcons.package,
                theme,
              ),
              _buildMetricCard(
                'Earnings',
                '\$245',
                LucideIcons.dollarSign,
                theme,
              ),
              _buildMetricCard('Rating', '4.8', LucideIcons.star, theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      width: 22.w,
      height: 12.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsDashboard(ThemeData theme, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Earnings Overview', style: theme.textTheme.titleSmall),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to detailed earnings
              },
              child: Text(
                'View details',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.5.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.onSurface,
                theme.colorScheme.onTertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This Week',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const Text(
                        '\$1,245.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+12% from last week',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green[300],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      LucideIcons.trendingUp,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEarningsMetric('Today', '\$245', Colors.white),
                  _buildEarningsMetric('This Month', '\$4,890', Colors.white),
                  _buildEarningsMetric('Pending', '\$125', Colors.white70),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsMetric(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    final isAvailable = ref.watch(serviceProviderAvailabilityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.textTheme.titleSmall),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAvailabilityActionButton(
              LucideIcons.clock1,
              theme.colorScheme.primary,
              isAvailable,
              () {
                HapticFeedback.lightImpact();
                ref.read(serviceProviderAvailabilityProvider.notifier).state =
                    !isAvailable;
              },
              theme,
            ),
            _buildActionButton(
              'Add Service',
              LucideIcons.plus,
              theme.colorScheme.onTertiary,
              () {
                HapticFeedback.lightImpact();
                context.pushNamed('service_provider_manage_services');
              },
              theme,
            ),
            _buildActionButton(
              'Support',
              LucideIcons.headphones,
              Colors.purple,
              () {
                HapticFeedback.lightImpact();
                // Navigate to analytics dashboard
              },
              theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityActionButton(
    IconData icon,
    Color color,
    bool isAvailable,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color:
              isAvailable
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isAvailable
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  color: isAvailable ? Colors.green : Colors.grey,
                  size: 24,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvailable ? Colors.green : Colors.grey,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: (isAvailable ? Colors.green : Colors.grey).withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isAvailable ? 'Active' : 'Busy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isAvailable ? Colors.green[700] : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 1.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(
    ThemeData theme,
    WidgetRef ref,
    dynamic allActiveOrders,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ongoing Orders', style: theme.textTheme.titleSmall),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(bottomNavigationProvider.notifier).state = 1;
              },
              child: Text(
                'View all',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        if (!(allActiveOrders is List && allActiveOrders.isNotEmpty))
          _buildEmptyState(
            theme: theme,
            title: 'No ongoing orders',
            subtitle: 'You have no ongoing orders currently.',
            icon: LucideIcons.calendarX,
          )
        else ...[
          _buildAppointmentCard(theme),
          SizedBox(height: 1.h),
          _buildAppointmentCard(theme),
        ],
      ],
    );
  }

  Widget _buildAppointmentCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.calendar,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery - Sarah Johnson',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Today, 2:00 PM - 3:00 PM',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Wash & Fold Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Confirmed',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrdersSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    GlobalKey<AnimatedListState> animatedListKey,
    ValueNotifier<List<String>> newOrderIds,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New Orders', style: theme.textTheme.titleSmall),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(bottomNavigationProvider.notifier).state = 1;
                ref.read(selectedOrderTabProvider.notifier).state = 2;
              },
              child: Text(
                'See all',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        if (newOrderIds.value.isEmpty)
          _buildEmptyState(
            theme: theme,
            title: 'No new orders',
            subtitle: 'New customer orders will appear here.',
            icon: LucideIcons.package,
          )
        else
          AnimatedList(
            key: animatedListKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            initialItemCount: newOrderIds.value.length,
            itemBuilder: (context, index, animation) {
              final orderId = newOrderIds.value[index];
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: _buildEnhancedOrderCard(
                  context,
                  theme,
                  orderId,
                  onAccept: () {
                    HapticFeedback.lightImpact();
                    ToastUtil.showSuccessToast(
                      context,
                      'Order accepted successfully!',
                    );
                    final removeIndex = newOrderIds.value.indexOf(orderId);
                    newOrderIds.value.removeAt(removeIndex);
                    animatedListKey.currentState?.removeItem(
                      removeIndex,
                      (context, animation) => SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: _buildEnhancedOrderCard(
                          context,
                          theme,
                          orderId,
                          onAccept:
                              () => _handleOrderAction(context, 'accepted'),
                          onDecline:
                              () => _handleOrderAction(context, 'declined'),
                        ),
                      ),
                    );
                  },
                  onDecline: () {
                    HapticFeedback.lightImpact();
                    ToastUtil.showErrorToast(context, 'Order declined.');
                    final removeIndex = newOrderIds.value.indexOf(orderId);
                    newOrderIds.value.removeAt(removeIndex);
                    animatedListKey.currentState?.removeItem(
                      removeIndex,
                      (context, animation) => SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: _buildEnhancedOrderCard(
                          context,
                          theme,
                          orderId,
                          onAccept:
                              () => _handleOrderAction(context, 'accepted'),
                          onDecline:
                              () => _handleOrderAction(context, 'declined'),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEnhancedOrderCard(
    BuildContext context,
    ThemeData theme,
    String orderId, {
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) {
    // ... existing code ...
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed("service_provider_order_details");
      },
      child: Container(
        padding: EdgeInsets.all(4.5.w),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #$orderId',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 2.h,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    LucideIcons.user,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
                SizedBox(width: 2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sarah Johnson',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pickup: Today, 2:00 PM',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '\$25.20',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Wash and Fold',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Accept'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
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
    );
  }

  Widget _buildEmptyState({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          SizedBox(
            width: 14.w,
            height: 6.h,
            child: Image.asset(
              'assets/images/empty_orders.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  void _handleOrderAction(BuildContext context, String action) {
    // Show toast notification
    if (action == 'accepted') {
      ToastUtil.showSuccessToast(context, 'Order accepted successfully!');
    } else {
      ToastUtil.showErrorToast(context, 'Order declined');
    }
  }
}
