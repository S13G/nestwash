import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/discount_model.dart';
import 'package:nestcare/features/general/services/presentation/widgets/create_discount_sheet_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/discount_widgets.dart';
import 'package:nestcare/providers/discount_provider.dart';
import 'package:nestcare/providers/service_provider_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/util/general_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderDiscountsScreen extends HookConsumerWidget {
  const ServiceProviderDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allDiscounts = ref.watch(allDiscountsProvider);
    final myDiscounts = allDiscounts.toList();

    // Filter state
    final selectedFilter = useState<DiscountFilter>(DiscountFilter.all);

    // Derived filtered list
    List<DiscountModel> visibleDiscounts =
        myDiscounts.where((d) {
          final isExpired = DateTime.now().isAfter(d.expiryDate);
          final remaining = (d.totalCount - d.usedCount).clamp(0, d.totalCount);
          switch (selectedFilter.value) {
            case DiscountFilter.all:
              return true;
            case DiscountFilter.active:
              return !isExpired && remaining > 0;
            case DiscountFilter.expired:
              return isExpired;
            case DiscountFilter.completed:
              return d.usedCount >= d.totalCount;
          }
        }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discounts', style: theme.textTheme.titleLarge),
                  if (visibleDiscounts.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _openCreateDiscountSheet(context, ref);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.onTertiary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.plus600,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Apply discounts to your services to attract customers.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Filters row
          SizedBox(
            height: 6.5.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDiscountFilterButton(
                    theme,
                    selectedFilter.value,
                    'All Discounts',
                    DiscountFilter.all,
                    Icons.list_alt_rounded,
                    () {
                      HapticFeedback.lightImpact();
                      selectedFilter.value = DiscountFilter.all;
                    },
                  ),
                  SizedBox(width: 3.w),
                  _buildDiscountFilterButton(
                    theme,
                    selectedFilter.value,
                    'Active',
                    DiscountFilter.active,
                    Icons.schedule_rounded,
                    () {
                      HapticFeedback.lightImpact();
                      selectedFilter.value = DiscountFilter.active;
                    },
                  ),
                  SizedBox(width: 3.w),
                  _buildDiscountFilterButton(
                    theme,
                    selectedFilter.value,
                    'Expired',
                    DiscountFilter.expired,
                    Icons.history_rounded,
                    () {
                      HapticFeedback.lightImpact();
                      selectedFilter.value = DiscountFilter.expired;
                    },
                  ),
                  SizedBox(width: 3.w),
                  _buildDiscountFilterButton(
                    theme,
                    selectedFilter.value,
                    'Completed',
                    DiscountFilter.completed,
                    Icons.done_all_rounded,
                    () {
                      HapticFeedback.lightImpact();
                      selectedFilter.value = DiscountFilter.completed;
                    },
                  ),
                ],
              ),
            ),
          ),
          if (visibleDiscounts.isNotEmpty) SizedBox(height: 1.h),
          if (visibleDiscounts.isEmpty)
            EmptyState(
              theme: theme,
              onCreate: () => _openCreateDiscountSheet(context, ref),
            )
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: visibleDiscounts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    Device.screenType == ScreenType.tablet ||
                            MediaQuery.of(context).size.width >= 600
                        ? 2
                        : 1,
                childAspectRatio: 2.5,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.5.h,
              ),
              itemBuilder: (context, index) {
                final discount = visibleDiscounts[index];
                final remaining = (discount.totalCount - discount.usedCount)
                    .clamp(0, discount.totalCount);
                final isExpired = DateTime.now().isAfter(discount.expiryDate);

                return GestureDetector(
                  onTap: () {
                    context.pushNamed('discount_details', extra: discount);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.onSurface,
                          theme.colorScheme.onTertiary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.20,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _formatDiscountValue(discount).toUpperCase(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  discount.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '$remaining/${discount.totalCount}',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${discount.category} • Code ${discount.code}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              _formatExpiry(context, discount.expiryDate),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    isExpired
                                        ? theme.colorScheme.error
                                        : Colors.white70,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              LucideIcons.percent,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _openCreateDiscountSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final provider = ref.read(selectedServiceProviderProvider);
    final allServices = ref.watch(allServicesProvider);
    final offeredIds = ref.watch(offeredServiceIdsProvider);

    final offeredServices =
        allServices
            .where((service) => offeredIds.contains(service.id))
            .toList();

    final providerName = provider?.name ?? 'My Laundry';
    final providerImage =
        provider?.profileImage ?? 'assets/images/nestcare_logo.png';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return CreateDiscountSheet(
          offeredServices: offeredServices.map((e) => e.name).toList(),
          providerName: providerName,
          providerImage: providerImage,
        );
      },
    );
  }

  String _formatDiscountValue(DiscountModel d) {
    if ((d.discountAmount ?? 0) > 0 && d.discountPercentage == 0) {
      return '₦${d.discountAmount!.toStringAsFixed(0)} off';
    }
    return '${d.discountPercentage}% off';
  }

  String _formatExpiry(BuildContext context, DateTime date) {
    final td = TimeOfDay.fromDateTime(date);
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'Expires $dateStr ${td.format(context)}';
  }

  Widget _buildDiscountFilterButton(
    ThemeData theme,
    DiscountFilter selectedFilter,
    String title,
    DiscountFilter filter,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : theme.colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
