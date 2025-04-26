import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddressCard extends StatelessWidget {
  final String street;
  final String houseNumber;
  final ThemeData theme;

  const AddressCard({
    super.key,
    required this.street,
    required this.houseNumber,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.primaryContainer),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Street", style: theme.textTheme.bodyMedium),
              Spacer(),
              Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
              SizedBox(width: 1.w),
              Icon(Icons.delete, color: theme.colorScheme.primary),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            street,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
          SizedBox(height: 1.h),
          Text("House Number", style: theme.textTheme.bodyMedium),
          SizedBox(height: 1.h),
          Text(
            houseNumber,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
