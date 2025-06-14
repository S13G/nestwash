enum ChatMessageFilterType { all, unread }

class ChatMessage {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool isUnread;
  final int unreadCount;
  final String avatar;

  ChatMessage({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.isUnread,
    required this.unreadCount,
    required this.avatar,
  });
}
