import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainDiscountCard extends StatelessWidget {
  const MainDiscountCard({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontSize: 4.h,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          Text(
            'Limited offer!!',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Get 50% discount for every order ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 1.5.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
