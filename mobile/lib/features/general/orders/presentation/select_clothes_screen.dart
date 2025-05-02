import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/orders_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/nest_button.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectClothesScreen extends ConsumerWidget {
  const SelectClothesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemsProvider);
    final theme = Theme.of(context);

    // Map of item names to their icon paths
    final itemIcons = {
      'Outer wear': 'jacket_icon',
      'Shirt': 'tshirt_icon',
      'Dress': 'dress_icon',
      'Others': 'bra_icon',
      'Bottom': 'jeans_icon',
    };

    return NestScaffold(
      showBackButton: true,
      title: 'Select Items',
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 8.h),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...selectedItems.entries.map((entry) {
                  final itemName = entry.key;
                  final itemSelection = entry.value;

                  return Column(
                    children: [
                      ClothingItemTile(
                        name: itemName,
                        price: 3,
                        gender: itemSelection.gender,
                        quantity: itemSelection.quantity,
                        iconName: itemIcons[itemName]!,
                        onGenderChanged: (gender) {
                          ref
                              .read(selectedItemsProvider.notifier)
                              .updateGender(itemName, gender);
                        },
                        onDecrement: () {
                          ref
                              .read(selectedItemsProvider.notifier)
                              .updateQuantity(itemName, -1);
                        },
                        onIncrement: () {
                          ref
                              .read(selectedItemsProvider.notifier)
                              .updateQuantity(itemName, 1);
                        },
                      ),
                      Divider(
                        height: 1,
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          NestButton(
            onPressed: () {
              // Filter items with quantity > 0
              final selectedClothes = Map.fromEntries(
                selectedItems.entries.where(
                  (entry) => entry.value.quantity > 0,
                ),
              );

              if (selectedClothes.isNotEmpty) {
                context.pop(selectedClothes);
              }
            },
            text: 'confirm Selection',
          ),
        ],
      ),
    );
  }
}

class ClothingItemTile extends StatelessWidget {
  final String name;
  final int price;
  final String gender;
  final int quantity;
  final String iconName;
  final Function(String) onGenderChanged;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const ClothingItemTile({
    super.key,
    required this.name,
    required this.price,
    required this.gender,
    required this.quantity,
    required this.iconName,
    required this.onGenderChanged,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      child: Row(
        children: [
          // Icon representation
          ClothingIcon(iconName: iconName),
          SizedBox(width: 4.w),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primaryContainer,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '\$$price',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Gender dropdown
                    GenderDropdown(value: gender, onChanged: onGenderChanged),
                  ],
                ),
              ],
            ),
          ),

          // Quantity control
          QuantityControl(
            quantity: quantity,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
          ),
        ],
      ),
    );
  }
}

class ClothingIcon extends StatelessWidget {
  final String iconName;

  const ClothingIcon({super.key, required this.iconName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconImageWidget(iconName: iconName, width: 14.w, height: 14.w);
  }
}

class GenderDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const GenderDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down),
        underline: const SizedBox(),
        isDense: true,
        borderRadius: BorderRadius.circular(8),
        items: const [
          DropdownMenuItem(value: 'Men', child: Text('Men')),
          DropdownMenuItem(value: 'Women', child: Text('Women')),
          DropdownMenuItem(value: 'Both', child: Text('Both')),
        ],
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Minus button
        QuantityButton(icon: Icons.remove, onTap: onDecrement),

        // Quantity display
        Container(
          width: 10.w,
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Plus button
        QuantityButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 7.w,
        height: 7.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 4.w),
      ),
    );
  }
}
