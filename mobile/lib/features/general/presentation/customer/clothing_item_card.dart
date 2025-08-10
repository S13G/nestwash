import 'package:flutter/material.dart';
import 'package:nestcare/features/general/model/clothes_model.dart';
import 'package:nestcare/features/general/widgets/clothing_item_selection_widget.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ClothingItemCard extends StatelessWidget {
  final ClothingItemModel item;
  final ClothesItemSelectionModel selection;
  final Function(String) onGenderChanged;
  final Function(int) onQuantityChanged;

  const ClothingItemCard({
    super.key,
    required this.item,
    required this.selection,
    required this.onGenderChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _buildItemIcon(theme),
          SizedBox(width: 4.w),
          Expanded(child: _buildItemDetails(theme)),
          _buildQuantityControls(theme),
        ],
      ),
    );
  }

  Widget _buildItemIcon(ThemeData theme) {
    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconImageWidget(iconName: item.icon, width: 8.w, height: 8.w),
    );
  }

  Widget _buildItemDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            ModernGenderDropdown(
              value: selection.gender,
              onChanged: onGenderChanged,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(ThemeData theme) {
    return ModernQuantityControl(
      quantity: selection.quantity,
      onChanged: onQuantityChanged,
    );
  }
}
