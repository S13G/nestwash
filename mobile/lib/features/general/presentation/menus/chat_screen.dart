import 'package:flutter/material.dart';
import 'package:nestcare/features/general/widgets/chat_user_widget.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NestScaffold(
      showBackButton: true,
      title: 'chat',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Provider', style: theme.textTheme.bodyLarge),
            SizedBox(height: 2.h),
            ChatUserWidget(
              imageName: 'provider_pic',
              personName: 'Jenny Wilson',
            ),
            SizedBox(height: 4.h),
            Text('Driver', style: theme.textTheme.bodyLarge),
            SizedBox(height: 2.h),
            ChatUserWidget(
              imageName: 'driver_pic',
              personName: 'Ronald Richards',
            ),
          ],
        ),
      ),
    );
  }
}
