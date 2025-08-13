import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nestcare/features/general/model/address_model.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';
import 'package:nestcare/features/general/services/model/service_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/clothing_items_provider.dart';
import 'package:nestcare/providers/home_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderSummaryScreen extends HookConsumerWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch all the order data
    final selectedService = ref.watch(selectedServiceProvider);
    final allServices = ref.watch(allServicesProvider);
    final pickupAddress = ref.watch(selectedPickupAddressProvider);
    final dropoffAddress = ref.watch(selectedDropoffAddressProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedTime = ref.watch(selectedTimeProvider);
    final selectedTimeRange = ref.watch(selectedTimeRangeProvider);
    final selectedItems = ref.watch(selectedItemsProvider);
    final clothingItems = ref.watch(clothingItemsProvider);
    final notes = ref.watch(notesProvider);
    final animations = useLaundryAnimations(null);

    // Find the selected service details
    final serviceDetails = allServices.firstWhere(
      (service) => service.id == selectedService,
      orElse: () => allServices.first,
    );

    // Calculate total price
    double totalPrice = _calculateTotalPrice(
      selectedItems,
      clothingItems,
      selectedService ?? '',
    );

    return NestScaffold(
      showBackButton: true,
      title: 'Order Summary',
      body: SlideTransition(
        position: animations.slideAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Section
                    _buildServiceSection(theme, serviceDetails),
                    SizedBox(height: 3.h),

                    // Addresses Section
                    _buildAddressesSection(
                      theme,
                      pickupAddress,
                      dropoffAddress,
                    ),
                    SizedBox(height: 3.h),

                    // Schedule Section
                    _buildScheduleSection(
                      theme,
                      context,
                      selectedDate,
                      selectedTime,
                      selectedTimeRange,
                    ),
                    SizedBox(height: 3.h),

                    // Items Section
                    _buildItemsSection(
                      theme,
                      selectedItems,
                      clothingItems,
                      selectedService ?? '',
                    ),
                    SizedBox(height: 3.h),

                    // Notes Section
                    if (notes.isNotEmpty) ...[
                      _buildNotesSection(theme, notes),
                      SizedBox(height: 3.h),
                    ],

                    // Price Summary Section
                    _buildPriceSummarySection(theme, totalPrice),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),

            // Place Order Button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              child: NestButton(
                text: 'Place Order',
                onPressed: () => _placeOrder(context, ref),
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(ThemeData theme, LaundryServiceModel service) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: service.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(service.icon, color: service.color, size: 8.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name, style: theme.textTheme.titleSmall),
                    SizedBox(height: 0.5.h),
                    Text(
                      service.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Duration: ${service.duration}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesSection(
    ThemeData theme,
    AddressModel? pickup,
    AddressModel? dropoff,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Addresses', style: theme.textTheme.titleSmall),
          SizedBox(height: 2.h),

          // Pickup Address
          _buildAddressItem(
            theme,
            'Pickup Address',
            pickup,
            LucideIcons.mapPinHouse,
            theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),

          // Dropoff Address
          _buildAddressItem(
            theme,
            'Dropoff Address',
            dropoff,
            LucideIcons.mapPinHouse,
            theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(
    ThemeData theme,
    String title,
    AddressModel? address,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Icon(icon, color: color, size: 5.w),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              if (address != null) ...[
                Text(
                  '${address.address}, ${address.city}, ${address.state}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (address.instructions.isNotEmpty)
                  Text(
                    'Instructions: ${address.instructions}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ] else
                Text(
                  'Not selected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(
    ThemeData theme,
    BuildContext context,
    DateTime? date,
    TimeOfDay? time,
    TimeRange? timeRange,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule', style: theme.textTheme.titleSmall),
          SizedBox(height: 2.h),

          // Pickup Schedule
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  LucideIcons.truck,
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
                      'Pickup Schedule',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    if (date != null && time != null) ...[
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        time.format(context),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else
                      Text(
                        'Not scheduled',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Dropoff Schedule
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  LucideIcons.calendarDays,
                  color: theme.colorScheme.secondary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dropoff Schedule',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    if (timeRange != null) ...[
                      Text(
                        _getTimeRangeText(timeRange),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else
                      Text(
                        'Not scheduled',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(
    ThemeData theme,
    Map<String, ClothesItemSelectionModel> selectedItems,
    Map<String, List<ClothingItemModel>> clothingItems,
    String serviceId,
  ) {
    final serviceItems = clothingItems[serviceId] ?? [];
    final itemsWithQuantity =
        selectedItems.entries
            .where((entry) => entry.value.quantity > 0)
            .toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selected Items', style: theme.textTheme.titleSmall),
          SizedBox(height: 2.h),

          if (itemsWithQuantity.isEmpty)
            Text(
              'No items selected',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            )
          else
            ...itemsWithQuantity.map((entry) {
              final itemName = entry.key;
              final selection = entry.value;
              final clothingItem = serviceItems.firstWhere(
                (item) => item.name == itemName,
                orElse:
                    () =>
                        ClothingItemModel(name: itemName, price: 0.0, icon: ''),
              );

              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Icon(
                        LucideIcons.boxes,
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
                            itemName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (selection.gender.isNotEmpty)
                            Text(
                              'Gender: ${selection.gender}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          Text(
                            'Qty: ${selection.quantity} × \$${clothingItem.price.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(selection.quantity * clothingItem.price).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildNotesSection(ThemeData theme, String notes) {
    return Container(
      padding: EdgeInsets.all(4.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Special Instructions', style: theme.textTheme.titleSmall),
          SizedBox(height: 1.h),
          Text(
            notes,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummarySection(ThemeData theme, double totalPrice) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Summary', style: theme.textTheme.titleSmall),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: theme.textTheme.bodyLarge),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Service Fee', style: theme.textTheme.bodyLarge),
              Text(
                '\$2.00',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: theme.textTheme.titleSmall),
              Text(
                '\$${(totalPrice + 2.00).toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalPrice(
    Map<String, ClothesItemSelectionModel> selectedItems,
    Map<String, List<ClothingItemModel>> clothingItems,
    String serviceId,
  ) {
    final serviceItems = clothingItems[serviceId] ?? [];
    double total = 0.0;

    for (final entry in selectedItems.entries) {
      final itemName = entry.key;
      final selection = entry.value;

      if (selection.quantity > 0) {
        final clothingItem = serviceItems.firstWhere(
          (item) => item.name == itemName,
          orElse: () => ClothingItemModel(name: itemName, price: 0.0, icon: ''),
        );
        total += selection.quantity * clothingItem.price;
      }
    }

    return total;
  }

  String _getTimeRangeText(TimeRange timeRange) {
    switch (timeRange) {
      case TimeRange.morning:
        return 'Morning (8:00 AM - 12:00 PM)';
      case TimeRange.afternoon:
        return 'Afternoon (12:00 PM - 5:00 PM)';
      case TimeRange.evening:
        return 'Evening (5:00 PM - 8:00 PM)';
    }
  }

  void _placeOrder(BuildContext context, WidgetRef ref) {
    ToastUtil.showSuccessToast(context, 'Order placed successfully!');

    // Reset all order providers
    resetAllOrderProviders(ref);

    // Set bottom navigation to orders tab (index 1)
    ref.read(bottomNavigationProvider.notifier).state = 1;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.goNamed('bottom_nav');
      }
    });
  }
}
