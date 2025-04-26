import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/profile_card_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiscountsScreen extends StatelessWidget {
  const DiscountsScreen({super.key});

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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.1),
                offset: const Offset(0, 8),
                blurRadius: 30,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '50%',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 5.h,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              Text(
                'Limited offer!!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Get 50% discount for every order ',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 1.5.h,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
