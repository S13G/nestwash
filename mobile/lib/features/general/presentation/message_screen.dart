import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF3F3D56);
  static const onPrimary = Color(0xFF8FD7C7);
  static const background = Color(0xFFF1F7FF);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF121212);
  static const hint = Color(0xFF737373);
  static const accent = Color(0xFF8EB8FF);
  static const primaryContainer = Color(0xFF797777);
  static const secondaryContainer = Color(0xFF7E7BAF);
  static const tertiary = Color(0xFF1F2937);
  static const onTertiary = Color(0xFF6366F1);
}

class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentName;
  final String? attachmentType;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
    this.attachmentName,
    this.attachmentType,
  });
}

class MessageScreen extends StatefulWidget {
  final String providerName;
  final String providerImage;
  final bool isOnline;

  const MessageScreen({super.key, required this.providerName, required this.providerImage, required this.isOnline});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Message> messages = [
    Message(
      id: '1',
      text: 'Hello! I\'ve received your laundry pickup request. I\'ll be there in 30 minutes.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    Message(
      id: '2',
      text: 'Perfect! I\'ll have everything ready. Should I separate the delicates?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      isRead: true,
    ),
    Message(
      id: '3',
      text: 'Yes, please separate them. Also, the white shirt needs special attention - there\'s a small stain on the collar.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isRead: true,
    ),
    Message(
      id: '4',
      text: 'Noted! I\'ll take extra care of that shirt. Do you have any fabric softener preference?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isRead: true,
    ),
    Message(
      id: '5',
      text: 'I\'ve picked up your laundry. Everything is now being processed. I\'ll send you updates!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    Message(
      id: '6',
      text: 'receipt_march_2024.pdf',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: true,
      attachmentName: 'receipt_march_2024.pdf',
      attachmentType: 'pdf',
    ),
    Message(
      id: '7',
      text: 'Great! Thank you for the receipt.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          Message(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: _messageController.text.trim(),
            isMe: true,
            timestamp: DateTime.now(),
            isRead: false,
          ),
        );
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildAttachmentBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [_buildHeader(), Expanded(child: _buildMessagesList()), _buildMessageInput()])),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(2.5.w)),
              child: Icon(Icons.arrow_back_ios_new, color: AppColors.secondary, size: 5.w),
            ),
          ),
          SizedBox(width: 3.w),

          // Provider Avatar
          Stack(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Icon(Icons.person, color: Colors.white, size: 6.w),
              ),
              if (widget.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 3.5.w,
                    height: 3.5.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(1.75.w),
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 3.w),

          // Provider Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.providerName, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.text)),
                SizedBox(height: 0.5.h),
                Text(
                  widget.isOnline ? 'Online' : 'Last seen 2 hours ago',
                  style: TextStyle(fontSize: 12.sp, color: widget.isOnline ? Colors.green : AppColors.hint),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Make a call
                },
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(2.5.w)),
                  child: Icon(Icons.call_outlined, color: AppColors.primary, size: 5.w),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  // More options
                },
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(2.5.w)),
                  child: Icon(Icons.more_vert, color: AppColors.secondary, size: 5.w),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showTimestamp = index == 0 || messages[index - 1].timestamp.difference(message.timestamp).inMinutes.abs() > 30;

        return Column(children: [if (showTimestamp) _buildTimestamp(message.timestamp), _buildMessageBubble(message), SizedBox(height: 2.h)]);
      },
    );
  }

  Widget _buildTimestamp(DateTime timestamp) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(_formatTimestamp(timestamp), style: TextStyle(fontSize: 11.sp, color: AppColors.hint, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Row(
      mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.isMe) ...[
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
              color: message.isMe ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(message.isMe ? 4.w : 1.w),
                bottomRight: Radius.circular(message.isMe ? 1.w : 4.w),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.attachmentName != null) _buildAttachment(message),
                if (message.text.isNotEmpty)
                  Text(message.text, style: TextStyle(fontSize: 14.sp, color: message.isMe ? Colors.white : AppColors.text, height: 1.4)),
                SizedBox(height: 1.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(fontSize: 10.sp, color: message.isMe ? Colors.white.withOpacity(0.7) : AppColors.hint),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 1.w),
                      Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 3.w,
                        color: message.isRead ? AppColors.onPrimary : Colors.white.withOpacity(0.7),
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
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(4.w)),
            child: Icon(Icons.person, color: Colors.white, size: 4.w),
          ),
        ],
      ],
    );
  }

  Widget _buildAttachment(Message message) {
    IconData icon;
    Color color;

    switch (message.attachmentType) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'image':
        icon = Icons.image;
        color = AppColors.primary;
        break;
      case 'document':
        icon = Icons.description;
        color = AppColors.accent;
        break;
      default:
        icon = Icons.attach_file;
        color = AppColors.hint;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(color: message.isMe ? Colors.white.withOpacity(0.2) : AppColors.background, borderRadius: BorderRadius.circular(3.w)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(2.w)),
            child: Icon(icon, color: color, size: 5.w),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message.attachmentName!,
              style: TextStyle(fontSize: 12.sp, color: message.isMe ? Colors.white : AppColors.text, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.download_outlined, color: message.isMe ? Colors.white.withOpacity(0.7) : AppColors.hint, size: 4.w),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showAttachmentOptions,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6.w)),
              child: Icon(Icons.attach_file, color: AppColors.primary, size: 6.w),
            ),
          ),
          SizedBox(width: 3.w),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(6.w)),
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppColors.hint, fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Icon(Icons.send, color: Colors.white, size: 5.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentBottomSheet() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(6.w), topRight: Radius.circular(6.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.w,
            height: 1.h,
            decoration: BoxDecoration(color: AppColors.hint.withOpacity(0.3), borderRadius: BorderRadius.circular(0.5.h)),
          ),
          SizedBox(height: 4.h),

          Text('Send Attachment', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.text)),
          SizedBox(height: 4.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption('Document', Icons.description_outlined, AppColors.primary, () {
                Navigator.pop(context);
                // Handle document selection
              }),
              _buildAttachmentOption('Photos', Icons.photo_library_outlined, AppColors.accent, () {
                Navigator.pop(context);
                // Handle photo selection
              }),
              _buildAttachmentOption('Files', Icons.folder_outlined, AppColors.onPrimary, () {
                Navigator.pop(context);
                // Handle file selection
              }),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(7.5.w)),
            child: Icon(icon, color: color, size: 7.w),
          ),
          SizedBox(height: 2.h),
          Text(title, style: TextStyle(fontSize: 12.sp, color: AppColors.text, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatMessageTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
