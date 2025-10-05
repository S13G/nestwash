import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/core/config/app_theme.dart';
import 'package:nestcare/features/general/model/order_model.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EnhancedOrderItemsWidget extends HookConsumerWidget {
  final Order order;

  const EnhancedOrderItemsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExpanded = useState(false);

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.onSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Icon(Icons.local_laundry_service_outlined, color: Colors.white, size: 6.w),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Items',
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${order.items.length} items • \$${order.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => isExpanded.value = !isExpanded.value,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(
                    isExpanded.value ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),

          // Items List
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded.value ? null : 0,
            child: isExpanded.value
                ? Column(
                    children: [
                      SizedBox(height: 3.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        separatorBuilder: (context, index) => SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return _buildOrderItem(context, theme, item);
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    BuildContext context,
    ThemeData theme,
    OrderItem item,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Item Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: IconImageWidget(
                iconName: _getItemIcon(item.name),
                width: 6.w,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 3.w),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${item.quantity} × \$${item.price.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          // Total Price
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getItemIcon(String itemName) {
    // Map item names to icon names from clothing_items_provider.dart
    final iconMap = {
      // Wash & Fold
      't-shirts': 'tshirt_icon',
      'polos': 'tshirt_icon',
      'shirts': 'shirt_icon',
      'blouses': 'shirt_icon',
      'trousers': 'jeans_icon',
      'jeans': 'jeans_icon',
      'shorts': 'shorts_icon',
      'dresses': 'dress_icon',
      'skirts': 'skirt_icon',
      'undergarments': 'underwear_icon',
      'underwear': 'underwear_icon',
      'towels': 'towel_icon',
      'bedsheets': 'bedsheet_icon',
      'pillowcases': 'bedsheet_icon',

      // Dry Clean
      'suits': 'suit_icon',
      'jackets': 'jacket_icon',
      'blazers': 'jacket_icon',
      'gowns': 'gown_icon',
      'coats': 'coat_icon',
      'sweaters': 'sweater_icon',
      'cardigans': 'sweater_icon',
      'scarves': 'scarf_icon',
      'shawls': 'scarf_icon',
      'ties': 'tie_icon',
      'bow ties': 'tie_icon',

      // Ironing
      'slacks': 'pants_icon',
      'traditional wear': 'traditional_icon',

      // Premium
      'wedding gowns': 'wedding_dress_icon',
      'designer suits': 'designer_suit_icon',
      'leather jackets': 'leather_jacket_icon',
      'silk dresses': 'silk_dress_icon',
      'beaded wear': 'beaded_icon',
      'embroidered wear': 'beaded_icon',
      'luxury coats': 'luxury_coat_icon',

      // Household
      'curtains': 'curtain_icon',
      'drapes': 'curtain_icon',
      'duvets': 'duvet_icon',
      'comforters': 'duvet_icon',
      'blankets': 'blanket_icon',
      'tablecloths': 'tablecloth_icon',
      'runners': 'tablecloth_icon',
      'cushion covers': 'cushion_icon',
      'rugs': 'rug_icon',

      // Footwear
      'sneakers': 'sneaker_icon',
      'leather shoes': 'leather_shoe_icon',
      'suede shoes': 'suede_shoe_icon',
      'boots': 'boot_icon',
      'sandals': 'sandal_icon',
      'heels': 'heel_icon',
    };

    // Convert item name to lowercase and check for matches
    final lowerName = itemName.toLowerCase();

    // Try exact match first
    if (iconMap.containsKey(lowerName)) {
      return iconMap[lowerName]!;
    }

    // Try partial matches
    for (final key in iconMap.keys) {
      if (lowerName.contains(key) || key.contains(lowerName)) {
        return iconMap[key]!;
      }
    }

    // Default icon if no match found
    return 'tshirt_icon';
  }
}
