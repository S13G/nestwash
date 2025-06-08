import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/discount_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/discount_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../shared/widgets/nest_scaffold.dart';

class CustomerDiscountScreen extends HookConsumerWidget {
  const CustomerDiscountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    String selectedCategory = ref.watch(selectedDiscountCategoryProvider);
    final categories = ref.watch(allDiscountsCategoriesProvider);
    final filteredDiscounts = ref.watch(filteredDiscountsProvider);

    final animations = useLaundryAnimations(null);

    return NestScaffold(
      padding: EdgeInsets.zero,
      body: FadeTransition(
        opacity: animations.fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            _buildHeader(theme, filteredDiscounts),
            SizedBox(height: 2.h),

            // category filter
            _buildCategoryFilter(ref, theme, selectedCategory, categories),
            SizedBox(height: 2.h),

            // discounts list
            Expanded(
              child:
                  filteredDiscounts.isEmpty
                      ? _buildEmptyState(theme, ref)
                      : _buildDiscountsList(animations, filteredDiscounts, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, List<DiscountModel> filteredDiscounts) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Discounts', style: theme.textTheme.titleLarge),
              SizedBox(height: 0.5.h),
              Text(
                'Grab these deals while they last!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2), width: 1),
          ),
          child: Text(
            '${filteredDiscounts.length} Available',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13.sp,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(
    WidgetRef ref,
    ThemeData theme,
    String selectedCategory,
    List<String> categories,
  ) {
    return SizedBox(
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              ref.read(selectedDiscountCategoryProvider.notifier).state = category;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                gradient:
                    isSelected
                        ? LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: isSelected ? null : theme.colorScheme.onTertiaryContainer,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(
                    color:
                        isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.05),
                    blurRadius: isSelected ? 15 : 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : theme.colorScheme.secondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiscountsList(
    LaundryAnimations animations,
    List<DiscountModel> filteredDiscounts,
    ThemeData theme,
  ) {
    return SlideTransition(
      position: animations.slideAnimation,
      child: ListView.builder(
        itemCount: filteredDiscounts.length,
        itemBuilder: (context, index) {
          final discount = filteredDiscounts[index];
          return _buildDiscountCard(discount, index, theme, context);
        },
      ),
    );
  }

  Widget _buildDiscountCard(
    DiscountModel discount,
    int index,
    ThemeData theme,
    BuildContext context,
  ) {
    final daysLeft = discount.expiryDate.difference(DateTime.now()).inDays;
    final availableCount = discount.totalCount - discount.usedCount;
    final progressValue = discount.usedCount / discount.totalCount;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: EdgeInsets.only(bottom: 3.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              discount.gradientStart.withValues(alpha: 0.8),
              discount.gradientEnd.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5.w),
          boxShadow: [
            BoxShadow(
              color: discount.gradientStart.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Stack(
            children: [
              // Glassmorphism overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with provider info and discount percentage
                    Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Icon(LucideIcons.washingMachine, color: Colors.white, size: 6.w),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discount.serviceProviderName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                discount.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Text(
                            '${discount.discountPercentage}%\nOFF',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Discount title and description
                    Text(
                      discount.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      discount.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Progress bar and availability
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$availableCount of ${discount.totalCount} left',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                height: 0.8.h,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(1.h),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: 1 - progressValue,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1.h),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '$daysLeft days left',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Code and claim button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(3.w),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.confirmation_number_outlined,
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  discount.code,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: () => _claimDiscount(discount, theme, context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Claim',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: discount.gradientStart,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You'll need this illustration image
          Container(
            width: 60.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimaryContainer,
              borderRadius: BorderRadius.circular(5.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 20.w,
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Discounts Available',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'No active discounts found\nfor the selected category',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
              height: 1.5,
            ),
          ),
          SizedBox(height: 3.h),
          GestureDetector(
            onTap: () {
              ref.read(selectedDiscountCategoryProvider.notifier).state = 'All';
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'View All Discounts',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _claimDiscount(DiscountModel discount, ThemeData theme, BuildContext context) {
    // Copy code to clipboard
    Clipboard.setData(ClipboardData(text: discount.code));

    // Show success message
    ToastUtil.showSuccessToast(
      context,
      'Code ${discount.code} copied to clipboard!',
      color: AppColors.onPrimary,
    );

    // Navigate to service provider or booking screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceProviderScreen(providerId: discount.serviceProviderName)));
  }
}
