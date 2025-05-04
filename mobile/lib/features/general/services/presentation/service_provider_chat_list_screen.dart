import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/chat_user_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServiceProviderChatListScreen extends ConsumerWidget {
  const ServiceProviderChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "All chats",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ChatUserWidget(
                imageName: 'provider_pic',
                personName: 'Jenny Wilson',
                ref: ref,
              );
            },
            separatorBuilder:
                (BuildContext context, int index) => SizedBox(height: 3.h),
          ),
        ),
      ],
    );
  }
}
