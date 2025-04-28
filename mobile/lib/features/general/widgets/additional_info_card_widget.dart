import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdditionalInfoContainer extends StatelessWidget {
  const AdditionalInfoContainer({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          title == 'Reviews'
              ? Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
              : Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
        ],
      ),
    );
  }
}
