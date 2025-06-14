import 'package:intl/intl.dart';

class MessagesModel {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentName;
  final String? attachmentType;

  MessagesModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
    this.attachmentName,
    this.attachmentType,
  });

  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  static String formatMessageTime(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }
}
