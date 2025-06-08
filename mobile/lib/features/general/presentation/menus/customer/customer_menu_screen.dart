import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/config/app_theme.dart';

class CustomerMenuScreen extends HookConsumerWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return NestScaffold(
      showBackButton: true,
      title: "menu",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _buildProfileCard(),
            SizedBox(height: 4.h),

            // Communication Section
            _buildSectionHeader('Communication', theme),
            SizedBox(height: 2.h),
            _buildCommunicationSection(theme, context),
            SizedBox(height: 4.h),

            // Services Section
            _buildSectionHeader('Services', theme),
            SizedBox(height: 2.h),
            _buildServicesSection(theme, context),
            SizedBox(height: 4.h),

            // Account Settings Section
            _buildSectionHeader('Account Settings', theme),
            SizedBox(height: 2.h),
            _buildAccountSection(theme, context),
            SizedBox(height: 4.h),

            // Preferences Section
            _buildSectionHeader('Preferences', theme),
            SizedBox(height: 2.h),
            _buildPreferencesSection(theme, context),
            SizedBox(height: 4.h),

            // Help & Support Section
            _buildSectionHeader('Help & Support', theme),
            SizedBox(height: 2.h),
            _buildHelpSection(theme, context),
            SizedBox(height: 4.h),

            // Logout Button
            _buildLogoutButton(theme, context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return ProfileCardWidget();
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildCommunicationSection(ThemeData theme, BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMenuItem(
            'Messages & Chat',
            'Chat with service providers',
            Icons.chat_bubble_outline,
            theme.colorScheme.primary,
            theme,
            () {},
            showBadge: true,
            badgeCount: '3',
          ),
          _buildDivider(),
          _buildMenuItem(
            'Notifications',
            'Manage your notifications',
            Icons.notifications_outlined,
            theme.colorScheme.onSurface,
            theme,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(ThemeData theme, BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMenuItem(
            'My Orders',
            'View all your orders',
            Icons.receipt_long_outlined,
            AppColors.onTertiary,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Favorite Providers',
            'Your trusted service providers',
            Icons.favorite_outline,
            Colors.red.shade400,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Service Schedule',
            'Manage recurring pickups',
            Icons.schedule_outlined,
            AppColors.onPrimary,
            theme,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(ThemeData theme, BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMenuItem(
            'Personal Details',
            'Update your profile information',
            Icons.person_outline,
            AppColors.secondary,
            theme,
            () => context.goNamed('customer_profile'),
          ),
          _buildDivider(),
          _buildMenuItem(
            'Payment Methods',
            'Manage cards and payment options',
            Icons.payment_outlined,
            AppColors.primary,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Transaction History',
            'View payment history',
            Icons.history_outlined,
            AppColors.accent,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Delivery Addresses',
            'Manage pickup and delivery locations',
            Icons.location_on_outlined,
            AppColors.onPrimary,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Invite Friends',
            'Share and earn rewards',
            Icons.share_outlined,
            Colors.orange.shade400,
            theme,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(ThemeData theme, BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMenuItem(
            'Laundry Preferences',
            'Set washing and drying preferences',
            Icons.tune_outlined,
            AppColors.onTertiary,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Language & Region',
            'Change app language and location',
            Icons.language_outlined,
            AppColors.primaryContainer,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Dark Mode',
            'Toggle dark/light theme',
            Icons.dark_mode_outlined,
            AppColors.tertiary,
            theme,
            () {},
            hasSwitch: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(ThemeData theme, BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          _buildMenuItem(
            'Help Center',
            'Get help and support',
            Icons.help_outline,
            AppColors.primary,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Contact Support',
            '24/7 customer support',
            Icons.support_agent_outlined,
            AppColors.accent,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description_outlined,
            AppColors.hint,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Privacy Policy',
            'Learn about data protection',
            Icons.privacy_tip_outlined,
            AppColors.secondaryContainer,
            theme,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            'Rate Our App',
            'Share your feedback',
            Icons.star_outline,
            Colors.amber.shade600,
            theme,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    ThemeData theme,
    VoidCallback onTap, {
    bool showBadge = false,
    String badgeCount = '',
    bool hasSwitch = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Stack(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Icon(icon, color: iconColor, size: 6.w),
          ),
          if (showBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(0.5.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                constraints: BoxConstraints(minWidth: 4.w, minHeight: 4.w),
                child: Text(
                  badgeCount,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      ),
      trailing:
          hasSwitch
              ? Switch(
                value: false, // You'll need to manage this state
                onChanged: (value) {
                  // Handle switch toggle
                },
                activeColor: theme.colorScheme.primary,
              )
              : Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onPrimaryContainer,
                size: 4.w,
              ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.background,
      indent: 4.w,
      endIndent: 4.w,
    );
  }

  Widget _buildLogoutButton(ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show logout confirmation dialog
        _showLogoutDialog();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(color: Colors.red.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_outlined, color: Colors.red.shade600, size: 6.w),
            SizedBox(width: 3.w),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    // Implement logout confirmation dialog
  }
}
