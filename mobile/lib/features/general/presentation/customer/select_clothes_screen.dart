import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';
import 'package:nestcare/features/general/presentation/customer/clothing_item_card.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/clothing_items_provider.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/providers/services_provider.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectClothesScreen extends HookConsumerWidget {
  const SelectClothesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    final selectedServiceId = ref.watch(selectedServiceProvider);
    final animations = useLaundryAnimations(null);

    // Get items for the selected service from the provider
    final availableItems = ref.watch(
      serviceClothingItemsProvider(selectedServiceId ?? 'wash_fold'),
    );
    final totalItems = _getTotalSelectedItems(selectedItems);
    final totalPrice = _calculateTotalPrice(selectedItems, availableItems);

    return NestScaffold(
      showBackButton: true,
      title: 'Select Items',
      body: SlideTransition(
        position: animations.slideAnimation,
        child: Column(
          children: [
            _buildHeader(context, totalItems, totalPrice),
            SizedBox(height: 2.h),
            Expanded(
              child: _buildItemsList(
                context,
                ref,
                availableItems,
                selectedItems,
              ),
            ),
            _buildBottomSection(context, ref, selectedItems, totalItems),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalItems, double totalPrice) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Items',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '$totalItems items',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.secondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(
    BuildContext context,
    WidgetRef ref,
    List<ClothingItemModel> availableItems,
    Map<String, ClothesItemSelectionModel> selectedItems,
  ) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: availableItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final item = availableItems[index];
        final selection =
            selectedItems[item.name] ?? ClothesItemSelectionModel();

        return ClothingItemCard(
          item: item,
          selection: selection,
          onGenderChanged: (gender) => _updateGender(ref, item.name, gender),
          onQuantityChanged:
              (change) => _updateQuantity(ref, item.name, change),
        );
      },
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    WidgetRef ref,
    Map<String, ClothesItemSelectionModel> selectedItems,
    int totalItems,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: NestButton(
        color: totalItems > 0 ? theme.colorScheme.primary : Colors.grey,
        onPressed:
            totalItems > 0
                ? () => _confirmSelection(context, ref, selectedItems)
                : null,
        text: totalItems > 0 ? 'Confirm Selection' : 'Select items to continue',
      ),
    );
  }

  int _getTotalSelectedItems(
    Map<String, ClothesItemSelectionModel> selectedItems,
  ) {
    return selectedItems.values
        .map((item) => item.quantity)
        .fold(0, (sum, qty) => sum + qty);
  }

  double _calculateTotalPrice(
    Map<String, ClothesItemSelectionModel> selectedItems,
    List<ClothingItemModel> availableItems,
  ) {
    double total = 0.0;
    for (final item in availableItems) {
      final selection = selectedItems[item.name];
      if (selection != null && selection.quantity > 0) {
        total += item.price * selection.quantity;
      }
    }
    return total;
  }

  void _updateGender(WidgetRef ref, String itemName, String gender) {
    ref.read(selectedItemsProvider.notifier).updateGender(itemName, gender);
    HapticFeedback.selectionClick();
  }

  void _updateQuantity(WidgetRef ref, String itemName, int change) {
    ref.read(selectedItemsProvider.notifier).updateQuantity(itemName, change);
    HapticFeedback.lightImpact();
  }

  void _confirmSelection(
    BuildContext context,
    WidgetRef ref,
    Map<String, ClothesItemSelectionModel> selectedItems,
  ) {
    final selectedClothes = Map.fromEntries(
      selectedItems.entries.where((entry) => entry.value.quantity > 0),
    );

    if (selectedClothes.isNotEmpty) {
      HapticFeedback.mediumImpact();
      context.pop(selectedClothes);
    }
  }
}
