import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/config/app_theme.dart';

class ServiceProviderMenuScreen extends HookConsumerWidget {
  const ServiceProviderMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      showBackButton: true,
      title: "menu",
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              SizedBox(height: 4.h),

              _buildSectionHeader('Communication', theme),
              SizedBox(height: 2.h),
              _buildCommunicationSection(theme, context),
              SizedBox(height: 4.h),

              _buildSectionHeader('Services', theme),
              SizedBox(height: 2.h),
              _buildServicesSection(theme, context),
              SizedBox(height: 4.h),

              _buildSectionHeader('Account', theme),
              SizedBox(height: 2.h),
              _buildAccountSection(theme, context),
              SizedBox(height: 4.h),

              _buildSectionHeader('Help & Support', theme),
              SizedBox(height: 2.h),
              _buildHelpSection(theme, context),
              SizedBox(height: 4.h),

              _buildLogoutButton(theme, context),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() => ProfileCardWidget();

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
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
            'Chat with customers',
            Icons.chat_bubble_outline,
            theme.colorScheme.primary,
            theme,
            () => context.pushNamed('chat-list'),
            showBadge: true,
            badgeCount: '3',
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
            'Manage Services',
            'Add or remove services you offer',
            Icons.build_outlined,
            AppColors.onTertiary,
            theme,
            () => context.pushNamed('service_provider_manage_services'),
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
            'Transaction History',
            'View payment history',
            Icons.history_outlined,
            AppColors.accent,
            theme,
            () => context.pushNamed("transaction_history"),
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
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description_outlined,
            AppColors.hint,
            theme,
            () => context.pushNamed("terms"),
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
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: theme.colorScheme.onPrimaryContainer,
        size: 4.w,
      ),
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    thickness: 1,
    color: AppColors.background,
    indent: 4.w,
    endIndent: 4.w,
  );

  Widget _buildLogoutButton(ThemeData theme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToastUtil.showSuccessToast(context, "Logged out");
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
}
