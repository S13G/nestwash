import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/earning_metrics.dart';
import 'package:nestcare/features/general/widgets/additional_info_card_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/service_provider_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProviderMainProfileScreen extends HookConsumerWidget {
  final ServiceProvider provider;

  const ProviderMainProfileScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      showBackButton: true,
      title: "Profile",
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

                _buildStatsRow(theme),
                SizedBox(height: 3.h),

                _buildEarningsOverview(theme),
                SizedBox(height: 3.h),

                _buildProfileManagement(theme, ref, context),
                SizedBox(height: 3.h),

                _buildServicesSection(theme, context),
                SizedBox(height: 3.h),

                _buildPricingSection(theme),
                SizedBox(height: 2.h),

                _buildReviewsSection(theme, context),
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
                SizedBox(height: 3.w),
                _buildAvailabilityToggle(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle(ThemeData theme) {
    final isAvailable = useState(provider.isAvailable);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        isAvailable.value = !isAvailable.value;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
        decoration: BoxDecoration(
          color:
              isAvailable.value
                  ? theme.colorScheme.onPrimary.withValues(alpha: 0.1)
                  : theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isAvailable.value
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
                    isAvailable.value
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              isAvailable.value ? 'Available Now' : 'Currently Busy',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color:
                    isAvailable.value
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
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
        AdditionalInfoContainer(title: 'Rating', value: '${provider.rating}★'),
      ],
    );
  }

  Widget _buildEarningsOverview(ThemeData theme) {
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
                    children: const [
                      Text(
                        'This Week',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '\$1,245.50',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
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
                children: const [
                  EarningsMetric(label: 'Today', amount: '\$245'),
                  EarningsMetric(label: 'This Month', amount: '\$4,890'),
                  EarningsMetric(label: 'Pending', amount: '\$125', dim: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileManagement(
    ThemeData theme,
    WidgetRef ref,
    BuildContext context,
  ) {
    final isEditing = useState(false);
    final nameController = useTextEditingController(text: provider.name);
    final cityController = useTextEditingController(text: provider.city ?? '');
    final priceController = useTextEditingController(
      text: provider.price.toStringAsFixed(2),
    );
    final bioController = useTextEditingController(
      text:
          "Professional laundry service provider with expertise in handling all types of fabrics and garments.",
    );
    final experienceController = useTextEditingController(text: "4 years");
    final shortBioController = useTextEditingController(
      text: "Professional laundry service",
    );
    final isAvailable = useState(provider.isAvailable);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile Information', style: theme.textTheme.titleSmall),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  isEditing.value = !isEditing.value;
                },
                child: Text(
                  isEditing.value ? 'Cancel' : 'Edit',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          if (!isEditing.value) ...[
            _readOnlyRow(theme, 'Name', provider.name),
            _readOnlyRow(theme, 'City', provider.city ?? 'Unknown'),
            _readOnlyRow(theme, 'Experience', '4 years'),
            _readOnlyRow(
              theme,
              'Base Price',
              '\$${provider.price.toStringAsFixed(2)} per item',
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bio', style: theme.textTheme.bodySmall),
                  SizedBox(height: 0.5.h),
                  Text(
                    "Professional laundry service provider with expertise in handling all types of fabrics and garments.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            _editableField(theme, 'Name', nameController),
            _editableField(theme, 'City', cityController),
            _editableField(theme, 'Experience', experienceController),
            _editableField(
              theme,
              'Base Price (\$)',
              priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Short Bio', style: theme.textTheme.bodySmall),
                  SizedBox(height: 0.6.h),
                  TextField(
                    controller: shortBioController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.6.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'A brief tagline about your services',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bio', style: theme.textTheme.bodySmall),
                  SizedBox(height: 0.6.h),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.6.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Describe your services and expertise',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Availability', style: theme.textTheme.bodySmall),
                Switch(
                  value: isAvailable.value,
                  activeThumbColor: theme.colorScheme.primary,
                  onChanged: (val) => isAvailable.value = val,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                final parsedPrice = double.tryParse(
                  priceController.text.trim(),
                );
                if (parsedPrice == null) {
                  ToastUtil.showErrorToast(
                    context,
                    'Please enter a valid price.',
                  );
                  return;
                }

                final updated = ServiceProvider(
                  id: provider.id,
                  name:
                      nameController.text.trim().isEmpty
                          ? provider.name
                          : nameController.text.trim(),
                  profileImage: provider.profileImage,
                  rating: provider.rating,
                  reviewCount: provider.reviewCount,
                  price: parsedPrice,
                  isVerified: provider.isVerified,
                  isAvailable: isAvailable.value,
                  responseTime: provider.responseTime,
                  distance: provider.distance,
                  services: provider.services,
                  city:
                      (cityController.text.trim().isEmpty
                          ? provider.city
                          : cityController.text.trim()),
                );

                ref.read(selectedServiceProviderProvider.notifier).state =
                    updated;
                isEditing.value = false;
                ToastUtil.showSuccessToast(
                  context,
                  'Profile updated successfully',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                minimumSize: Size(double.infinity, 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save Changes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _readOnlyRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Services Offered",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSecondary,
              ),
            ),
            TextButton(
              onPressed:
                  () => context.pushNamed("service_provider_manage_services"),
              child: Text(
                "Manage",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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

  Widget _editableField(
    ThemeData theme,
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          SizedBox(height: 0.6.h),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.6.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
