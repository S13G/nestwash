import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/messages_model.dart';
import 'package:nestcare/features/general/services/model/service_provider_model.dart';
import 'package:nestcare/hooks/use_laundry_animations.dart';
import 'package:nestcare/providers/messages_provider.dart';
import 'package:nestcare/shared/util/toast_util.dart';
import 'package:nestcare/shared/widgets/nest_scaffold.dart';
import 'package:nestcare/shared/util/file_attachment_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageScreen extends HookConsumerWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final messageController = useTextEditingController();
    final messages = ref.watch(messageListNotifierProvider);
    final providerName = ref.watch(messageProviderName);
    final serviceProvider = ServiceProvider(
      id: '1',
      name: 'John Smith',
      rating: 4.8,
      reviewCount: 150,
      price: 12.50,
      responseTime: '< 1 hour',
      city: 'New York',
      isAvailable: true,
      isVerified: true,
      services: ['Wash & Fold', 'Dry Cleaning', 'Ironing'],
      profileImage: '',
      distance: '',
    );
    final isOnline = ref.watch(messageIsOnline);
    final focusNode = useFocusNode();
    final messageNotifier = ref.watch(messageListNotifierProvider.notifier);

    final animations = useLaundryAnimations(null);

    // Automatically scroll down to show the latest message.
    void scrollToBottom(ScrollController controller) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    }

    useEffect(() {
      // Initial scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom(animations.scrollAnimationController);
      });

      return null;
    }, []);

    void sendMessage() {
      if (messageController.text.trim().isNotEmpty) {
        final newMessage = MessagesModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageController.text.trim(),
          isMe: true,
          timestamp: DateTime.now(),
          isRead: false,
        );
        messageNotifier.addMessage(newMessage);
        messageController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 150), () {
            if (animations.scrollAnimationController.hasClients) {
              animations.scrollAnimationController.animateTo(
                animations.scrollAnimationController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        });
      }
    }

    void showAttachmentOptions() {
      animations.bottomSheetAnimationController.forward(from: 0.0);

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder:
            (context) => FadeTransition(
              opacity: animations.bottomSheetFadeAnimation,
              child: SlideTransition(
                position: animations.bottomSheetSlideAnimation,
                child: buildAttachmentBottomSheet(context, theme),
              ),
            ),
      ).whenComplete(
        () => animations.bottomSheetAnimationController.reverse(from: 1.0),
      );
    }

    void showMoreOptions() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder:
            (context) => buildMoreOptionsBottomSheet(
              context,
              theme,
              providerName,
              serviceProvider!,
            ),
      );
    }

    return NestScaffold(
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          buildHeader(
            animations,
            theme,
            context,
            providerName: providerName,
            isOnline: isOnline,
            showMoreOptions: showMoreOptions,
          ),
          Expanded(child: buildMessagesList(theme, animations, messages)),
          buildMessageInput(
            animations,
            theme,
            sendMessage,
            showAttachmentOptions,
            messageController,
            focusNode,
          ),
        ],
      ),
    );
  }

  Widget buildHeader(
    LaundryAnimations animations,
    ThemeData theme,
    BuildContext context, {
    required String providerName,
    required bool isOnline,
    required GestureTapCallback showMoreOptions,
  }) {
    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: SlideTransition(
        position: animations.slideAnimation,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.onTertiaryContainer,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.5.w),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: theme.colorScheme.secondary,
                    size: 5.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Stack(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.onSurface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 6.w),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 3.5.w,
                        height: 3.5.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(1.75.w),
                          border: Border.all(
                            color: theme.colorScheme.onTertiaryContainer,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isOnline ? 'Online' : 'Last seen 2 hours ago',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isOnline
                                ? Colors.green
                                : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Make a call
                    },
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.5.w),
                      ),
                      child: Icon(
                        Icons.call_outlined,
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => showMoreOptions(),
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.5.w),
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.secondary,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoreOptionsBottomSheet(
    BuildContext context,
    ThemeData theme,
    String providerName,
    ServiceProvider serviceProvider,
  ) {
    final accountType = 'customer';

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
            SizedBox(height: 2.h),

            Text('More Options', style: theme.textTheme.titleSmall),
            SizedBox(height: 2.h),

            // More options list
            buildMoreOptionItem(
              theme,
              'View Profile',
              Icons.person_outline,
              () {
                if (accountType == 'service_provider') {
                  context.pushNamed('customer_profile_view', extra: "1");
                } else {
                  context.pushNamed(
                    'message_profile_view',
                    extra: serviceProvider,
                  );
                }
              },
            ),
            SizedBox(height: 2.h),

            buildMoreOptionItem(
              theme,
              'Add to favorites',
              Icons.favorite_outline,
              () {
                context.pop();
                ToastUtil.showSuccessToast(context, 'Added to favorites');
              },
            ),
            SizedBox(height: 2.h),

            buildMoreOptionItem(
              theme,
              'Report User',
              Icons.report_outlined,
              () {
                // Show report dialog
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (!context.mounted) return;
                  context.pop();
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            buildReportDialog(context, theme, providerName),
                  );
                });
              },
              isDestructive: true,
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget buildMoreOptionItem(
    ThemeData theme,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : theme.colorScheme.secondary,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDestructive ? Colors.red : theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onPrimaryContainer,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportDialog(
    BuildContext context,
    ThemeData theme,
    String providerName,
  ) {
    final reportReasons = [
      'Inappropriate behavior',
      'Harassment',
      'Spam',
      'Fake profile',
      'Inappropriate content',
      'Fake or bad services',
      'Other',
    ];

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.report_outlined, color: Colors.red, size: 6.w),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Report $providerName',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.close,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 4.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              Text(
                'Why are you reporting this user?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),

              // Report reasons
              ...reportReasons.map(
                (reason) => GestureDetector(
                  onTap: () {
                    context.pop();
                    _handleReport(context, theme, providerName, reason);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 4.w,
                    ),
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onTertiaryContainer,
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    child: Text(
                      reason,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              // Cancel button
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReport(
    BuildContext context,
    ThemeData theme,
    String providerName,
    String reason,
  ) {
    // Show confirmation
    ToastUtil.showSuccessToast(
      context,
      'Report submitted. Thank you for helping keep our community safe.',
    );
  }

  Widget buildMessagesList(
    ThemeData theme,
    LaundryAnimations animations,
    List<MessagesModel> messages,
  ) {
    return ListView.builder(
      controller: animations.scrollAnimationController,
      padding: EdgeInsets.all(4.w),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showTimestamp =
            index == 0 ||
            messages[index - 1].timestamp
                    .difference(message.timestamp)
                    .inMinutes
                    .abs() >
                30;

        return Column(
          children: [
            if (showTimestamp) buildTimestamp(message, theme),
            buildMessageBubble(message, theme),
            SizedBox(height: 2.h),
          ],
        );
      },
    );
  }

  Widget buildTimestamp(MessagesModel message, ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        MessagesModel.formatTimestamp(message.timestamp),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildMessageBubble(MessagesModel message, ThemeData theme) {
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.isMe) ...[
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.onSurface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 4.w),
          ),
          SizedBox(width: 2.w),
        ],

        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: 75.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  message.isMe
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onTertiaryContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(message.isMe ? 4.w : 1.w),
                bottomRight: Radius.circular(message.isMe ? 1.w : 4.w),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.attachmentName != null)
                  buildAttachment(message, theme),
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          message.isMe
                              ? Colors.white
                              : theme.colorScheme.secondary,
                      height: 1.4,
                    ),
                  ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      MessagesModel.formatMessageTime(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            message.isMe
                                ? Colors.white.withValues(alpha: 0.7)
                                : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 1.w),
                      Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 3.w,
                        color:
                            message.isRead
                                ? theme.colorScheme.onPrimary
                                : Colors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        if (message.isMe) ...[
          SizedBox(width: 2.w),
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 4.w),
          ),
        ],
      ],
    );
  }

  Widget buildAttachment(MessagesModel message, ThemeData theme) {
    IconData icon;
    Color color;

    switch (message.attachmentType) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'image':
        icon = Icons.image;
        color = theme.colorScheme.primary;
        break;
      case 'document':
        icon = Icons.description;
        color = theme.colorScheme.onSurface;
        break;
      default:
        icon = Icons.attach_file;
        color = theme.colorScheme.onPrimaryContainer;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color:
            message.isMe
                ? Colors.white.withValues(alpha: 0.2)
                : theme.colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Icon(icon, color: color, size: 5.w),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message.attachmentName!,
              style: TextStyle(
                fontSize: 12.sp,
                color:
                    message.isMe ? Colors.white : theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.download_outlined,
            color:
                message.isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : theme.colorScheme.onPrimaryContainer,
            size: 4.w,
          ),
        ],
      ),
    );
  }

  Widget buildMessageInput(
    LaundryAnimations animations,
    ThemeData theme,
    GestureTapCallback sendMessage,
    GestureTapCallback showAttachmentOptions,
    TextEditingController messageController,
    FocusNode focusNode,
  ) {
    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: showAttachmentOptions,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Icon(
                  Icons.attach_file,
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  maxLines: 4,
                  minLines: 1,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
            ),

            SizedBox(width: 3.w),
            GestureDetector(
              onTap: sendMessage,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.onSurface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6.w),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.send, color: Colors.white, size: 5.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttachmentBottomSheet(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(0.5.h),
            ),
          ),
          SizedBox(height: 4.h),
          Text('Send Attachment', style: theme.textTheme.titleSmall),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildAttachmentOption(
                theme,
                'Document',
                Icons.description_outlined,
                theme.colorScheme.primary,
                () async {
                  context.pop();
                  await _handleDocumentSelection(context);
                },
              ),
              buildAttachmentOption(
                theme,
                'Photos',
                Icons.photo_library_outlined,
                theme.colorScheme.onSurface,
                () async {
                  context.pop();
                  await _handlePhotoSelection(context);
                },
              ),
              buildAttachmentOption(
                theme,
                'Files',
                Icons.folder_outlined,
                theme.colorScheme.onPrimary,
                () async {
                  context.pop();
                  await _handleFileSelection(context);
                },
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  // Add these new methods to handle file selections
  Future<void> _handleDocumentSelection(BuildContext context) async {
    final result = await FileAttachmentService.selectFiles(
      context: context,
      config: FileSelectionConfig.documents,
    );

    FileAttachmentService.handleFileSelectionResult(
      context,
      result,
      onSuccess: () {
        // Handle successful document selection
        // You can add the files to your message or state management here
        print(
          'Selected documents: ${result.files.map((f) => f.path).join(', ')}',
        );
      },
    );
  }

  Future<void> _handlePhotoSelection(BuildContext context) async {
    final result = await FileAttachmentService.selectFiles(
      context: context,
      config: FileSelectionConfig.multipleImages,
    );

    FileAttachmentService.handleFileSelectionResult(
      context,
      result,
      onSuccess: () {
        // Handle successful photo selection
        print('Selected photos: ${result.files.map((f) => f.path).join(', ')}');
      },
    );
  }

  Future<void> _handleFileSelection(BuildContext context) async {
    final result = await FileAttachmentService.selectFiles(
      context: context,
      config: FileSelectionConfig.anyFile,
    );

    FileAttachmentService.handleFileSelectionResult(
      context,
      result,
      onSuccess: () {
        // Handle successful file selection
        print('Selected files: ${result.files.map((f) => f.path).join(', ')}');
      },
    );
  }

  Widget buildAttachmentOption(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
    GestureTapCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(7.5.w),
            ),
            child: Icon(icon, color: color, size: 7.w),
          ),
          SizedBox(height: 2.h),
          Text(title, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
