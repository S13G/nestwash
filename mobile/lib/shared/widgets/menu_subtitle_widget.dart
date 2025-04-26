import 'package:flutter/material.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuSubtitleWidget extends StatelessWidget {
  const MenuSubtitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Text(
        title[0].toUpperCase() + title.substring(1),
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primaryContainer,
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    super.key,
    required this.title,
    required this.iconName,
    this.onTap,
  });

  final String title;
  final String iconName;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            IconImageWidget(iconName: iconName, width: 3.5.h, height: 3.5.h),
            SizedBox(width: 4.w),
            Text(
              title[0].toUpperCase() + title.substring(1),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: theme.colorScheme.primaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
