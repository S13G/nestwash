import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/services/presentation/widgets/add_service_widget.dart';
import 'package:nestcare/features/general/services/presentation/widgets/service_item_pricing_sheet.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageServicesScreen extends HookConsumerWidget {
  const ManageServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allServices = ref.watch(allServicesProvider);
    final offeredIds = ref.watch(offeredServiceIdsProvider);

    final offeredServices =
        allServices
            .where((service) => offeredIds.contains(service.id))
            .toList();

    return NestScaffold(
      title: 'manage services',
      showBackButton: true,
      actions: [
        TextButton.icon(
          onPressed: () => _showAddServiceSheet(context, ref),
          icon: Icon(LucideIcons.plus, color: theme.colorScheme.primary),
          label: Text(
            'Add',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      backgroundColor: theme.colorScheme.surface,
      body:
          offeredServices.isEmpty
              ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: _EmptyState(
                  theme: theme,
                  onAddTap: () => _showAddServiceSheet(context, ref),
                ),
              )
              : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: offeredServices.length,
                itemBuilder: (context, index) {
                  final service = offeredServices[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.2,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: service.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                service.icon,
                                color: service.color,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    service.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.8.h),
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.timer,
                                        size: 16,
                                        color: service.color,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        service.duration,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: service.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 3.w),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                final current = {...offeredIds};
                                if (current.remove(service.id)) {
                                  ref
                                      .read(offeredServiceIdsProvider.notifier)
                                      .state = current;
                                  ToastUtil.showSuccessToast(
                                    context,
                                    '${service.name} removed from your services',
                                  );
                                } else {
                                  ToastUtil.showErrorToast(
                                    context,
                                    'Service not found in your offerings',
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: theme.colorScheme.error.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.trash2,
                                      color: theme.colorScheme.error,
                                      size: 18,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Remove',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showServiceItemPricingSheet(context, ref, service.id, service.name);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.plus,
                                  color: theme.colorScheme.primary,
                                  size: 18,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Manage Item Prices',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  void _showAddServiceSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allServices = ref.read(allServicesProvider);
    final offeredIds = ref.read(offeredServiceIdsProvider);
    final availableServices =
        allServices
            .where((service) => !offeredIds.contains(service.id))
            .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return AddServiceWidget(
          theme: theme,
          availableServices: availableServices,
          offeredIds: offeredIds,
        );
      },
    );
  }

  void _showServiceItemPricingSheet(BuildContext context, WidgetRef ref, String serviceId, String serviceName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ServiceItemPricingSheet(
          serviceId: serviceId,
          serviceName: serviceName,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onAddTap;

  const _EmptyState({required this.theme, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 12.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              LucideIcons.washingMachine,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'No services offered yet',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),
          Text(
            'Add services to start receiving orders and manage your offerings.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.5.h),
          NestButton(
            round: true,
            buttonSize: Size(40.w, 6.h),
            text: 'Add Service',
            mediumText: true,
            onPressed: () {
              HapticFeedback.lightImpact();
              onAddTap();
            },
          ),
        ],
      ),
    );
  }
}
