import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:nestcare/shared/widgets/profile_card_search_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCardWidget extends ConsumerWidget {
  const ProfileCardWidget({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: theme.colorScheme.onPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 3.h,
                child: ImageWidget(imageName: 'user_pic'),
              ),
              SizedBox(width: 1.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primaryContainer,
                    ),
                  ),
                  Text(
                    'Nancy',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 2.8.h,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: null,
                icon: Icon(Icons.more_vert, color: Colors.white, size: 4.h),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ProfileCardSearchWidget(theme: theme),
        ],
      ),
    );
  }
}
