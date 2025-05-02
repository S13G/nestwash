import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/widgets/chat_user_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return NestScaffold(
      showBackButton: true,
      title: 'all chats',
      body: ListView.separated(
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
    );
  }
}
