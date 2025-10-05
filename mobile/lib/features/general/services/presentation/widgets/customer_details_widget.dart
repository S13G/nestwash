import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsWidget extends HookConsumerWidget {
  final Order order;

  const CustomerDetailsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.user,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Customer Details',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Customer Profile Section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Customer Avatar
                    Icon(
                      LucideIcons.user,
                      color: theme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Sarah Johnson',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Action Buttons
                    Row(
                      children: [
                        _buildActionButton(
                          context,
                          theme,
                          LucideIcons.phone,
                          () => _makePhoneCall('+1234567890', context),
                        ),
                        SizedBox(width: 6.w),
                        _buildActionButton(
                          context,
                          theme,
                          LucideIcons.messageCircle,
                          () => _openChat(context),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Customer Information Grid
                Column(
                  children: [
                    _buildInfoRow(
                      theme,
                      'Phone',
                      '+1 (555) 123-4567',
                      LucideIcons.phone,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Special Instructions (if any)
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      color: Colors.blue,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Special Instructions',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Please handle delicate items with extra care. Ring doorbell twice for delivery.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Icon(icon, color: theme.colorScheme.primary, size: 5.w),
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
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 14),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ToastUtil.showErrorToast(context, 'Could not launch phone dialer');
    }
  }

  void _openChat(BuildContext context) {
    // Navigate to chat screen
    context.pushNamed('chat');
  }
}
