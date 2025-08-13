import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TermsScreen extends HookWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NestScaffold(
      padding: EdgeInsets.zero,
      showBackButton: true,
      title: "terms of service",
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Hero Section
                    _buildHeroSection(theme),
                    SizedBox(height: 4.h),

                    // Terms Content
                    _buildTermsContent(theme),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 10.w,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Terms & Conditions',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Text(
              'Please read these terms carefully before using our service',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(5.w),
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
          _buildTermsSection(
            theme,
            '1. Acceptance of Terms',
            'By accessing and using NestWash laundry services, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            Icons.check_circle_outline,
            theme.colorScheme.primary,
          ),

          _buildTermsSection(
            theme,
            '2. Service Description',
            'NestWash provides on-demand laundry and dry cleaning services including pickup, cleaning, and delivery. We connect customers with professional service providers in their area to ensure quality cleaning services.',
            Icons.local_laundry_service_outlined,
            theme.colorScheme.onSurface,
          ),

          _buildTermsSection(
            theme,
            '3. User Responsibilities',
            'Users must provide accurate pickup and delivery information, ensure items are suitable for cleaning, and be available during scheduled pickup/delivery times. Users are responsible for checking pockets and removing valuable items before service.',
            Icons.person_outline,
            theme.colorScheme.onTertiary,
          ),

          _buildTermsSection(
            theme,
            '4. Payment Terms',
            'Payment is processed through the app using your selected payment method. Pricing is transparent and shown before confirming orders. Refunds are processed according to our satisfaction guarantee policy.',
            Icons.payment_outlined,
            theme.colorScheme.onPrimary,
          ),

          _buildTermsSection(
            theme,
            '5. Liability & Insurance',
            'While we take utmost care of your items, NestWash and service providers maintain insurance coverage for lost or damaged items. Claims must be reported within 24 hours of delivery with photographic evidence.',
            Icons.security_outlined,
            theme.colorScheme.secondaryContainer,
          ),

          _buildTermsSection(
            theme,
            '6. Privacy Policy',
            'We respect your privacy and protect your personal information. Location data is used only for service delivery. We do not share personal information with third parties except service providers for order fulfillment.',
            Icons.privacy_tip_outlined,
            theme.colorScheme.tertiary,
          ),

          _buildTermsSection(
            theme,
            '7. Service Availability',
            'Services are subject to availability in your area. We reserve the right to decline service for items that are heavily soiled, damaged, or unsuitable for cleaning. Special care items may incur additional charges.',
            Icons.location_on_outlined,
            Colors.orange.shade400,
          ),

          _buildTermsSection(
            theme,
            '8. Cancellation Policy',
            'Orders can be cancelled up to 1 hour before scheduled pickup without charge. Late cancellations may incur a fee. Recurring services can be paused or cancelled anytime through the app.',
            Icons.cancel_outlined,
            Colors.red.shade400,
          ),

          _buildTermsSection(
            theme,
            '9. Quality Guarantee',
            'We guarantee satisfaction with our cleaning services. If you\'re not satisfied, report issues within 24 hours for re-cleaning or refund. Our quality team investigates all complaints promptly.',
            Icons.star_outline,
            Colors.amber.shade600,
          ),

          _buildTermsSection(
            theme,
            '10. Changes to Terms',
            'NestWash reserves the right to modify these terms at any time. Users will be notified of significant changes through the app. Continued use of the service constitutes acceptance of modified terms.',
            Icons.update_outlined,
            theme.colorScheme.onPrimaryContainer,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(
    ThemeData theme,
    String title,
    String content,
    IconData icon,
    Color iconColor, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.surface,
            indent: 5.w,
            endIndent: 5.w,
          ),
      ],
    );
  }
}
