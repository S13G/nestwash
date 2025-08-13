import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/address_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/address_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectPickupAddressScreen extends HookConsumerWidget {
  const SelectPickupAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final addresses = ref.watch(addressListNotifierProvider);
    final selectedAddress = ref.watch(selectedPickupAddressProvider);
    final animations = useLaundryAnimations(null);

    return NestScaffold(
      showBackButton: true,
      title: 'Pickup Location',
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.08),
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Pickup Address',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Select where our rider should collect your laundry',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'Saved Addresses',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 1.h),

            // Content Area
            Expanded(
              child: Container(
                child:
                    addresses.isNotEmpty
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address List
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: addresses.length,
                                separatorBuilder:
                                    (context, index) => SizedBox(height: 2.h),
                                itemBuilder: (context, index) {
                                  final address = addresses[index];
                                  final isSelected =
                                      selectedAddress?.id == address.id;

                                  return _buildModernAddressCard(
                                    context,
                                    ref,
                                    theme,
                                    address,
                                    isSelected,
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                        : _buildModernEmptyState(theme, context),
              ),
            ),

            // Modern Bottom Action Area
            addresses.isNotEmpty
                ? NestButton(
                  text: "Confirm Pickup Location",
                  onPressed:
                      selectedAddress != null
                          ? () {
                            // Add haptic feedback
                            HapticFeedback.mediumImpact();

                            // Complete the pickup address step
                            _completePickupStep(ref);

                            // Navigate back to make order screen
                            context.pop(true);
                          }
                          : null,
                  color:
                      selectedAddress != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.3),
                )
                : SizedBox.shrink(),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _completePickupStep(WidgetRef ref) {
    // Mark step 0 (pickup address) as completed
    final completed = [...ref.read(completedStepsProvider)];
    completed[0] = true;
    ref.read(completedStepsProvider.notifier).state = completed;

    // Update progress
    final newProgress =
        completed.where((step) => step).length / completed.length;
    ref.read(orderProgressProvider.notifier).state = newProgress;

    // Move to next step
    ref.read(currentStepProvider.notifier).state = 1;
  }

  Widget _buildModernAddressCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AddressModel address,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(selectedPickupAddressProvider.notifier).state = address;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.all(4.5.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.06)
                  : theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.08),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Address Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 11.w,
                  height: 11.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSelected
                              ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                              ]
                              : [
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.1,
                                ),
                                theme.colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.05,
                                ),
                              ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    address.isDefault ? LucideIcons.house : LucideIcons.mapPin,
                    color:
                        isSelected
                            ? Colors.white
                            : theme.colorScheme.onPrimaryContainer,
                    size: 5.5.w,
                  ),
                ),

                SizedBox(width: 3.w),

                // Address Label and Default Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color:
                                  isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.secondary,
                            ),
                          ),
                          if (address.isDefault) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.4.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.8,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Default',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.3,
                              ),
                      width: 2,
                    ),
                  ),
                  child: AnimatedScale(
                    scale: isSelected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 3.5.w,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.5.h),

            // Address Details
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.04)
                        : theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.02,
                        ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.05,
                          ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.7,
                        ),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          '${address.address}, ${address.city}, ${address.state}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Instructions
                  if (address.instructions.isNotEmpty) ...[
                    SizedBox(height: 1.5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            address.instructions,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmptyState(ThemeData theme, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Modern Empty State Illustration
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Icon(
              LucideIcons.mapPin300,
              size: 12.w,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'No Saved Addresses',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),

          SizedBox(height: 1.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Add an address in your profile to continue with laundry pickup',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 3.h),

          // Add Address Button
          NestButton(
            text: 'Add Address',
            prefixIcon: Icon(
              LucideIcons.mapPinPlus,
              color: Colors.white,
              size: 5.w,
            ),
            onPressed: () => context.pushNamed("customer_addresses"),
            buttonSize: Size(50.w, 7.h),
          ),
        ],
      ),
    );
  }
}
