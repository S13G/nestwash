import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/providers/chat_provider.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chattingPartnerName = ref.watch(chattingPartnerNameProvider);

    return NestScaffold(
      showBackButton: true,
      title: "Chat with $chattingPartnerName",
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              itemCount: 11,
              itemBuilder: (context, index) {
                final isMe = index.isEven;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.5.h,
                          horizontal: 2.h,
                        ),
                        margin: EdgeInsets.only(top: 1.h, bottom: 0.5.h),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isMe
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.9,
                                  )
                                  : theme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 18),
                          ),
                        ),
                        child: Text(
                          isMe ? "Hi, your laundry is ready!" : "Thank you!",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isMe
                                    ? Colors.white
                                    : theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      if (isMe)
                        Padding(
                          padding: EdgeInsets.only(left: 1.h, bottom: 1.5.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "08:11 AM",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.done_all,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _ChatInputField(),
        ],
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  const _ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 2.5.h,
                    vertical: 1.8.h,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.all(1.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
