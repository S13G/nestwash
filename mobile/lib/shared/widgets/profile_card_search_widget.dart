import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/profile_card_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCardSearchWidget extends ConsumerWidget {
  const ProfileCardSearchWidget({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(searchControllerProvider);
    final searchFocusNode = ref.watch(searchFocusNodeProvider);

    return Row(
      children: [
        ImageWidget(imageName: 'search', width: 3.h, height: 3.h),
        SizedBox(width: 2.w),
        Expanded(
          child: TextFormField(
            controller: searchController,
            focusNode: searchFocusNode,
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
      ],
    );
  }
}
