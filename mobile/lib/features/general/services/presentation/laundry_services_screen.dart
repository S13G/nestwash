// screens/laundry_services_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';
import 'package:nestcare/features/general/widgets/search_widget.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../providers/services_provider.dart';

class LaundryServicesScreen extends HookConsumerWidget {
  const LaundryServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final searchText = ref.watch(searchTextProvider);
    final allServices = ref.watch(filteredServiceProvider(searchText));
    final selectedServiceId = ref.watch(selectedServiceProvider);

    final animations = useLaundryAnimations(selectedServiceId);

    return NestScaffold(
      padding: EdgeInsets.zero,
      body: GestureDetector(
        onTap: () {
          // Deselect service when tapping outside
          if (selectedServiceId != null) {
            ref.read(selectedServiceProvider.notifier).state = null;
          }
        },
        child: FadeTransition(
          opacity: animations.fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header section
              _buildHeader(theme),
              SizedBox(height: 3.h),

              // search bar
              SearchWidget(hintText: 'Search services...'),
              SizedBox(height: 3.h),

              // services grid
              Expanded(
                child: SlideTransition(
                  position: animations.slideAnimation,
                  child: _buildServicesGrid(
                    theme,
                    allServices,
                    selectedServiceId,
                    context,
                    ref,
                  ),
                ),
              ),

              // Animated Bottom Action Button (if service selected)
              SlideTransition(
                position: animations.bottomSheetSlideAnimation,
                child: FadeTransition(
                  opacity: animations.bottomSheetFadeAnimation,
                  child:
                      selectedServiceId != null
                          ? _buildBottomAction(
                            theme,
                            context,
                            allServices,
                            selectedServiceId,
                            ref,
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Our Services', style: theme.textTheme.titleLarge),
        SizedBox(height: 0.5.h),
        Text(
          'Choose the perfect care for your clothes',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(
    ThemeData theme,
    List<LaundryServiceModel> allServices,
    String? selectedServiceId,
    BuildContext context,
    WidgetRef ref,
  ) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
      ),
      itemCount: allServices.length,
      itemBuilder: (context, index) {
        final service = allServices[index];
        final isSelected = selectedServiceId == service.id;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _buildServiceCard(service, isSelected, index, context, ref),
        );
      },
    );
  }

  Widget _buildServiceCard(
    LaundryServiceModel service,
    bool isSelected,
    int index,
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Toggle selection - set to null if already selected, otherwise set to service.id
        ref.read(selectedServiceProvider.notifier).state =
            isSelected ? null : service.id;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.onTertiaryContainer.withValues(alpha: 0.2),
              service.color.withValues(alpha: 0.5),
              theme.colorScheme.onSurface.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color:
                isSelected
                    ? service.color
                    : service.color.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? service.color.withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: isSelected ? 20 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Badge & Service Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (service.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.onSurface,
                          theme.colorScheme.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Popular',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? service.color
                            : service.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    service.icon,
                    color: isSelected ? Colors.white : service.color,
                    size: 28,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),

            // Service Name & Description
            Text(
              service.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              service.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // Duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Duration',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  service.duration,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    ThemeData theme,
    BuildContext context,
    List<LaundryServiceModel> allServices,
    String selectedServiceId,
    WidgetRef ref,
  ) {
    final selectedService = allServices.firstWhere(
      (service) => service.id == selectedServiceId,
    );

    return Padding(
      padding: EdgeInsets.all(1.5.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Service Details Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedService.color.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selectedService.color.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedService.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        selectedService.icon,
                        color: selectedService.color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedService.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Duration for service: ${selectedService.duration}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                if (selectedService.features.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        selectedService.features
                            .map(
                              (feature) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.5.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedService.color.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: selectedService.color.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  feature,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: selectedService.color,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Continue Button
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.pushNamed(
                "service_providers",
                queryParameters: {'selectedService': selectedService.name},
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    selectedService.color,
                    selectedService.color.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: selectedService.color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue with ${selectedService.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2.5.w),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
