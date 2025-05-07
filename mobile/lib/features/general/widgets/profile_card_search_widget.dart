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
    final theme = Theme.of(context);

    return Row(
      children: [
        IconImageWidget(iconName: 'search', width: 2.5.h, height: 2.5.h),
        SizedBox(width: 2.w),
        Expanded(
          child: TextFormField(
            controller: searchNotifier.controller,
            focusNode: searchNotifier.focusNode,
            decoration: InputDecoration(
              filled: false,
              hintText: 'Search',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
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
