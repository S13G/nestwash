import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/rating_modal.dart';
import 'package:nestcare/features/general/widgets/additional_info_card_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/chat_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderProfileScreen extends HookConsumerWidget {
  final ServiceProvider provider;

  const ServiceProviderProfileScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExpanded = ref.watch(serviceProviderExpandedDescriptionProvider);
    final animations = useLaundryAnimations(null);

    final fullText =
        "${provider.name}'s expertise in laundry services is complemented by their friendly and approachable nature. They enjoy building strong relationships with clients and take the time to listen to their needs and concerns. Their focus on customer satisfaction has earned them a loyal following and many repeat clients. With ${provider.reviewCount} completed orders and a ${provider.rating}-star rating, they are committed to providing exceptional service quality.";

    final shortText =
        fullText.length > 150 ? fullText.substring(0, 150) : fullText;

    return NestScaffold(
      showBackButton: true,
      title: "Provider Profile",
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: SlideTransition(
          position: animations.slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderHeader(theme),
                SizedBox(height: 3.h),

                _buildDescription(theme, fullText, shortText, isExpanded, ref),
                SizedBox(height: 3.h),

                _buildStatsRow(theme),
                SizedBox(height: 3.h),

                _buildServicesSection(theme),
                SizedBox(height: 3.h),

                _buildPricingSection(theme),
                SizedBox(height: 2.h),

                _buildReviewsSection(theme, context),
                SizedBox(height: 2.h),

                _buildActionButtons(context, ref, theme),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
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
                ),
                child: Icon(LucideIcons.user, color: Colors.white, size: 10.w),
              ),
              if (provider.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onTertiaryContainer,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.shieldCheck600,
                      color: Colors.white,
                      size: 3.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
                SizedBox(height: 1.w),
                Text(
                  "Professional Laundry Service Provider",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.w),
                Row(
                  children: [
                    Icon(
                      LucideIcons.building2,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      provider.city?.isNotEmpty == true
                          ? provider.city!
                          : 'N/A',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      LucideIcons.clock,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      provider.responseTime,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.star,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${provider.rating}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 3.w),
                _buildAvailabilityStatus(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityStatus(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      decoration: BoxDecoration(
        color:
            provider.isAvailable
                ? theme.colorScheme.onPrimary.withValues(alpha: 0.1)
                : theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              provider.isAvailable
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onPrimaryContainer,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  provider.isAvailable
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            provider.isAvailable ? 'Available Now' : 'Currently Busy',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color:
                  provider.isAvailable
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(
    ThemeData theme,
    String fullText,
    String shortText,
    bool isExpanded,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About ${provider.name}",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: 2.w),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: RichText(
            key: ValueKey(isExpanded),
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.onPrimaryContainer,
                height: 1.5,
              ),
              children: [
                TextSpan(text: isExpanded ? fullText : "$shortText..."),
                TextSpan(
                  text: isExpanded ? " Read less" : " Read more",
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(
                                serviceProviderExpandedDescriptionProvider
                                    .notifier,
                              )
                              .state = !isExpanded;
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AdditionalInfoContainer(title: 'Experience', value: '4 years'),
        AdditionalInfoContainer(
          title: 'Orders',
          value: '${provider.reviewCount}+',
        ),
        AdditionalInfoContainer(
          title: 'Response',
          value: provider.responseTime,
        ),
      ],
    );
  }

  Widget _buildServicesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Services Offered",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondary,
          ),
        ),
        SizedBox(height: 2.w),
        Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children:
              provider.services.map((service) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    service,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPricingSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pricing",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          SizedBox(height: 2.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Starting from",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                "\$${provider.price.toStringAsFixed(2)} per item",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.w),
          Text(
            "Final pricing may vary based on service type and quantity",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews & Ratings",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                context.pushNamed("service_provider_reviews", extra: provider);
              },
              child: Text(
                "View All",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.w),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiaryContainer,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sarah M.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star_rounded,
                              color: index < 5 ? Colors.amber : Colors.grey,
                              size: 3.w,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "2 days ago",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.w),
              Text(
                "Excellent service! ${provider.name} was very professional and my clothes came back perfectly clean and pressed. Highly recommend!",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: OutlinedButton(
                  onPressed: () => _showRatingModal(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 6.h),
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.star,
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Rate ${provider.name}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NestButton(
                text: provider.isAvailable ? 'Book Now' : 'Schedule Later',
                onPressed:
                    provider.isAvailable
                        ? () {
                          HapticFeedback.lightImpact();
                          ref.read(chattingPartnerNameProvider.notifier).state =
                              provider.name;
                          context.pushNamed("make_order");
                        }
                        : () {
                          HapticFeedback.lightImpact();
                          _showScheduleDialog(context, theme);
                        },
                color:
                    provider.isAvailable
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showScheduleDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme.colorScheme.onTertiaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Schedule Service",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            content: Text(
              "${provider.name} is currently busy. Would you like to be notified when they become available?",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ToastUtil.showSuccessToast(
                    context,
                    "You will be notified when ${provider.name} is available",
                  );
                },
                child: Text(
                  "Notify Me",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showRatingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RatingModal(provider: provider),
    );
  }
}
