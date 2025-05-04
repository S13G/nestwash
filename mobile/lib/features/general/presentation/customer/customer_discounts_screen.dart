import 'package:flutter/material.dart';
import 'package:nestcare/features/general/widgets/main_discount_card.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomerDiscountsScreen extends StatelessWidget {
  const CustomerDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCardWidget(theme: theme, search: false),
        SizedBox(height: 4.h),
        Text('Offers/Discounts', style: theme.textTheme.bodyLarge),
        SizedBox(height: 2.h),
        MainDiscountCard(theme: theme),
      ],
    );
  }
}
