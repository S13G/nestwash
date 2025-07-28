import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/features/general/widgets/search_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:nestcare/shared/util/service_provider_utils.dart';

import '../../../../providers/service_provider_provider.dart';

class ServiceProvidersScreen extends HookConsumerWidget {
  final String selectedService;

  const ServiceProvidersScreen({super.key, required this.selectedService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final LaundryAnimations animation = useLaundryAnimations(null);
    final filteredProviders = ref.watch(filteredServiceProviders);

    return NestScaffold(
      showBackButton: true,
      padding: EdgeInsets.zero,
      title: selectedService,
      body: FadeTransition(
        opacity: animation.fadeAnimation,
        child: Column(
          children: [
            _buildSearchSection(ref, context, theme),
            _buildFiltersSection(ref, theme),
            Expanded(child: _buildProvidersList(filteredProviders, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(
    WidgetRef ref,
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(child: const SearchWidget(hintText: 'Search providers...')),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showSortBottomSheet(context, ref, theme);
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onTertiaryContainer,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.slidersHorizontal,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(WidgetRef ref, ThemeData theme) {
    final selectedFilter = ref.watch(selectedServiceFilterProvider);
    final filters = [
      {'label': 'All', 'value': ServiceProviderFilterType.all},
      {'label': 'Available', 'value': ServiceProviderFilterType.available},
      {'label': 'Verified', 'value': ServiceProviderFilterType.verified},
      {'label': 'Top Rated', 'value': ServiceProviderFilterType.topRated},
      {'label': 'Outside City', 'value': ServiceProviderFilterType.outsideCity},
    ];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['value'];

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(selectedServiceFilterProvider.notifier).state =
                  filter['value'] as ServiceProviderFilterType;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
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
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: Text(
                  filter['label'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isSelected
                            ? Colors.white
                            : theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProvidersList(List<ServiceProvider> providers, ThemeData theme) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: EdgeInsets.only(bottom: 4.w),
          child: _buildProviderCard(provider, theme, context),
        );
      },
    );
  }

  Widget _buildProviderCard(
    ServiceProvider provider,
    ThemeData theme,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed('service_provider_profile', extra: provider);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                provider.isAvailable
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.3)
                    : theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.2,
                    ),
            width: 1,
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
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
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
                      child: Icon(
                        LucideIcons.user,
                        color: Colors.white,
                        size: 7.w,
                      ),
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
                      Row(
                        children: [
                          Text(
                            provider.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          if (!provider.isAvailable)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.w,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Busy',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.w),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.star400,
                            color: Colors.amber,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${provider.rating}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                          Text(
                            ' (${provider.reviewCount} reviews)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.w),
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
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${provider.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'per item',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 2.w,
                    runSpacing: 2.w,
                    children:
                        provider.services.map((service) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.w,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              service,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final currentSort = ref.read(selectedServiceSortProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 1.w,
                margin: EdgeInsets.only(bottom: 4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                'Sort by',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 4.w),
              ...[
                {
                  'label': 'Highest Rated',
                  'value': ServiceProviderSortType.highestRated,
                },
                {
                  'label': 'Lowest Rated',
                  'value': ServiceProviderSortType.lowestRated,
                },
                {
                  'label': 'Lowest Price',
                  'value': ServiceProviderSortType.lowestPrice,
                },
                {
                  'label': 'Highest Price',
                  'value': ServiceProviderSortType.highestPrice,
                },
              ].map((sort) {
                final isSelected = currentSort == sort['value'];
                return ListTile(
                  title: Text(
                    sort['label'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? Icon(
                            Icons.check_rounded,
                            color: theme.colorScheme.primary,
                          )
                          : null,
                  onTap: () {
                    ref.read(selectedServiceSortProvider.notifier).state =
                        sort['value'] as ServiceProviderSortType;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
