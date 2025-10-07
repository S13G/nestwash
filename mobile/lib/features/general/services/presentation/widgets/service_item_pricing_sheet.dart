import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';
import 'package:nestcare/providers/clothing_items_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceItemPricingSheet extends HookConsumerWidget {
  final String serviceId;
  final String serviceName;

  const ServiceItemPricingSheet({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final clothingItems = ref.watch(serviceClothingItemsProvider(serviceId));

    // Create a map of controllers for each item
    final controllers = useMemoized(() {
      return {
        for (var item in clothingItems)
          item.name: TextEditingController(text: item.price.toStringAsFixed(2)),
      };
    }, [clothingItems]);

    // Dispose controllers when widget is disposed
    useEffect(() {
      return () {
        for (var controller in controllers.values) {
          controller.dispose();
        }
      };
    }, [controllers]);

    return FractionallySizedBox(
      heightFactor: 0.87,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 2.h,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(LucideIcons.tag, color: theme.colorScheme.primary),
                  SizedBox(width: 2.w),
                  Text(
                    'Set Prices for $serviceName Items',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                'Set the base/starting price for each item in this service.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clothingItems.length,
                  itemBuilder: (context, index) {
                    final item = clothingItems[index];
                    final controller = controllers[item.name]!;

                    return Container(
                      margin: EdgeInsets.only(bottom: 1.5.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              LucideIcons.shirt,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 25.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h,
                                ),
                                prefixText: '\$ ',
                                prefixStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
              NestButton(
                text: 'Save Prices',
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Validate and save prices
                  bool isValid = true;
                  final updatedItems = <ClothingItemModel>[];

                  for (var item in clothingItems) {
                    final controller = controllers[item.name]!;
                    final priceText = controller.text.trim();
                    final price = double.tryParse(priceText);

                    if (price == null || price <= 0) {
                      isValid = false;
                      ToastUtil.showErrorToast(
                        context,
                        'Please enter a valid price for ${item.name}',
                      );
                      break;
                    }

                    updatedItems.add(
                      ClothingItemModel(
                        name: item.name,
                        price: price,
                        icon: item.icon,
                      ),
                    );
                  }

                  if (isValid) {
                    // In a real app, you would update the provider or database here
                    ToastUtil.showSuccessToast(
                      context,
                      'Prices updated successfully',
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}
