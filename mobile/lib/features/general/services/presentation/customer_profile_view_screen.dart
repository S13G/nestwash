import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerProfileViewScreen extends ConsumerWidget {
  final String customerId;

  const CustomerProfileViewScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final customerName = 'John Doe';
    final customerEmail = 'john.doe@example.com';
    final customerPhone = '123-456-7890';
    final totalOrders = '47';
    final totalSpent = '\$127';
    final customerLocation = 'New York, NY';

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: "Customer Profile",
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    _buildProfilePicture(theme),
                    SizedBox(height: 2.h),
                    Text(
                      customerName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      customerLocation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // Contact Information Section
              _buildSectionHeader('Contact Information', theme),
              SizedBox(height: 2.h),
              _buildInfoCard(
                theme,
                children: [
                  _buildInfoRow(
                    theme,
                    'Email',
                    customerEmail,
                    Icons.email_outlined,
                  ),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                    theme,
                    'Phone',
                    customerPhone,
                    Icons.phone_outlined,
                  ),
                  SizedBox(height: 2.h),
                  _buildInfoRow(
                    theme,
                    'Location',
                    customerLocation,
                    Icons.location_on_outlined,
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              // Order Statistics
              _buildSectionHeader('Order Statistics', theme),
              SizedBox(height: 2.h),
              _buildInfoCard(
                theme,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Orders',
                          totalOrders,
                          Icons.receipt_long_outlined,
                          theme.colorScheme.primary,
                          theme,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatCard(
                          'Total Spent',
                          totalSpent,
                          Icons.savings_outlined,
                          theme.colorScheme.onPrimary,
                          theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(ThemeData theme) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.person, color: Colors.white, size: 12.w),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(ThemeData theme, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 5.w),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 6.w),
          SizedBox(height: 1.h),
          Text(value, style: theme.textTheme.titleSmall),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
