import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/profile_card_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCardWidget extends ConsumerWidget {
  const ProfileCardWidget({
    super.key,
    required this.theme,
    required this.formKey,
    required this.searchController,
    required this.searchFocusNode,
  });

  final ThemeData theme;
  final GlobalKey<FormState> formKey;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

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
          Row(
            children: [
              ImageWidget(imageName: 'search', width: 3.h, height: 3.h),
              SizedBox(width: 2.w),
              Expanded(
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onChanged: (value) {
                      ref.read(searchTextProvider.notifier).state =
                          value.trim();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
