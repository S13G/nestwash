import 'package:flutter/material.dart';
import 'package:nestcare/features/general/widgets/main_discount_card.dart';
import 'package:nestcare/features/general/widgets/profile_card_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderDiscountsScreen extends StatelessWidget {
  const ServiceProviderDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileCardWidget(),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Offers/Discounts', style: theme.textTheme.bodyLarge),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Create',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        MainDiscountCard(theme: theme),
      ],
    );
  }
}
