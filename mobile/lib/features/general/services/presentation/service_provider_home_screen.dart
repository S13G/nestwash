import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/widgets/menu_options_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/providers/reviews_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderHomeScreen extends HookConsumerWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);
    final allActiveOrders = ref.watch(allActiveOrdersProvider);
    final reviewsStats = ref.watch(reviewsStatsProvider);

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
              _buildQuickActions(theme, ref),
              SizedBox(height: 3.h),

              // Upcoming Appointments
              _buildAppointmentsSection(theme, ref),
              SizedBox(height: 3.h),

              // New Orders Section
              _buildNewOrdersSection(theme, ref, allActiveOrders),
              SizedBox(height: 3.h),

              // Performance Metrics
              _buildPerformanceMetrics(theme, reviewsStats),
              SizedBox(height: 3.h),

              // Service Management
              _buildServiceManagement(theme, ref),
              SizedBox(height: 3.h),

              // Customer Interaction Hub
              _buildCustomerInteractionHub(theme, ref),
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
                width: 12.w,
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
                      'Good morning, William👋',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Ready to serve your customers today',
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
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
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
            Text('Earnings Overview 💰', style: theme.textTheme.titleSmall),
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

  Widget _buildQuickActions(ThemeData theme, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions ⚡', style: theme.textTheme.titleSmall),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(
              'Set Availability',
              LucideIcons.clock,
              theme.colorScheme.primary,
              () {
                HapticFeedback.lightImpact();
                // Navigate to availability settings
              },
              theme,
            ),
            _buildActionButton(
              'Add Service',
              LucideIcons.plus,
              theme.colorScheme.onTertiary,
              () {
                HapticFeedback.lightImpact();
                // Navigate to add service
              },
              theme,
            ),
            _buildActionButton(
              'View Analytics',
              LucideIcons.chartBar,
              theme.colorScheme.onSurface,
              () {
                HapticFeedback.lightImpact();
                // Navigate to analytics
              },
              theme,
            ),
          ],
        ),
      ],
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

  Widget _buildAppointmentsSection(ThemeData theme, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Appointments 📅', style: theme.textTheme.titleSmall),
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
        _buildAppointmentCard(theme),
        SizedBox(height: 1.h),
        _buildAppointmentCard(theme),
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
                  'Pickup - Sarah Johnson',
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
    ThemeData theme,
    WidgetRef ref,
    List allActiveOrders,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New Orders 🧺', style: theme.textTheme.titleSmall),
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
        _buildEnhancedOrderCard(theme),
        SizedBox(height: 1.h),
        _buildEnhancedOrderCard(theme),
      ],
    );
  }

  Widget _buildEnhancedOrderCard(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to order details
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #LN2024001',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'New',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Accept order
                    },
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
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Decline order
                    },
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

  Widget _buildPerformanceMetrics(
    ThemeData theme,
    Map<String, dynamic> reviewsStats,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Performance Metrics 📊', style: theme.textTheme.titleSmall),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPerformanceItem(
                    'Average Rating',
                    '${reviewsStats['averageRating']?.toStringAsFixed(1) ?? '0.0'}',
                    LucideIcons.star,
                    theme,
                  ),
                  _buildPerformanceItem(
                    'Total Reviews',
                    '${reviewsStats['totalReviews'] ?? 0}',
                    LucideIcons.messageSquare,
                    theme,
                  ),
                  _buildPerformanceItem(
                    'Completion Rate',
                    '98%',
                    LucideIcons.checkCheck,
                    theme,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPerformanceItem(
                    'Response Time',
                    '< 10 min',
                    LucideIcons.clock,
                    theme,
                  ),
                  _buildPerformanceItem(
                    'Orders Completed',
                    '156',
                    LucideIcons.package,
                    theme,
                  ),
                  _buildPerformanceItem(
                    'Customer Retention',
                    '85%',
                    LucideIcons.users,
                    theme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceManagement(ThemeData theme, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Management 🛠️', style: theme.textTheme.titleSmall),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
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
          child: Column(
            children: [
              _buildServiceItem(
                'Wash & Fold',
                'Active • \$15/load',
                true,
                theme,
                ref,
              ),
              Divider(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              _buildServiceItem(
                'Dry Cleaning',
                'Active • \$25/item',
                true,
                theme,
                ref,
              ),
              Divider(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              _buildServiceItem(
                'Express Service',
                'Inactive • \$30/load',
                false,
                theme,
                ref,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(
    String serviceName,
    String details,
    bool isActive,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: (isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimaryContainer)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              LucideIcons.washingMachine,
              color:
                  isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  details,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              // Toggle service availability
            },
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInteractionHub(ThemeData theme, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Interaction 💬', style: theme.textTheme.titleSmall),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildInteractionCard(
                'Messages',
                '3 unread',
                LucideIcons.messageCircle,
                theme.colorScheme.primary,
                () {
                  HapticFeedback.lightImpact();
                  ref.read(bottomNavigationProvider.notifier).state = 2;
                },
                theme,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildInteractionCard(
                'Notifications',
                '5 new',
                LucideIcons.bell,
                theme.colorScheme.onTertiary,
                () {
                  HapticFeedback.lightImpact();
                  // Navigate to notifications
                },
                theme,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildInteractionCard(
                'Reviews',
                'View latest',
                LucideIcons.star,
                theme.colorScheme.onSurface,
                () {
                  HapticFeedback.lightImpact();
                  // Navigate to reviews
                },
                theme,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildInteractionCard(
                'Support',
                'Get help',
                LucideIcons.lifeBuoy,
                Colors.purple,
                () {
                  HapticFeedback.lightImpact();
                  // Navigate to support
                },
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                if (title == 'Messages' || title == 'Notifications')
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
