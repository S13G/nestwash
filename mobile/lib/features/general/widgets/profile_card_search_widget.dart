import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/profile_card_provider.dart';
import 'package:nestcare/shared/widgets/image_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileCardSearchWidget extends ConsumerWidget {
  const ProfileCardSearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNotifier = ref.read(searchControllerNotifierProvider.notifier);
    final searchText = ref.watch(searchControllerNotifierProvider);
    final theme = Theme.of(context);

    return Row(
      children: [
        IconImageWidget(iconName: 'search', width: 3.h, height: 3.h),
        SizedBox(width: 2.w),
        Expanded(
          child: TextFormField(
            controller: searchNotifier.controller,
            focusNode: searchNotifier.focusNode,
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
