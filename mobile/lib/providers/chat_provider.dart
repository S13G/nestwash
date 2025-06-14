import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/chat_model.dart';

final chattingPartnerNameProvider = StateProvider<String>((ref) => '');

// Chat list categories
final selectedChatsCategoriesProvider = StateProvider<ChatMessageFilterType>((ref) => ChatMessageFilterType.all);
final allChatsCategoriesProvider = StateProvider<List<String>>((ref) {
  return ["All", "Unread"];
});

// Chat list data
final allChatsProvider = StateProvider<List<ChatMessage>>((ref) {
  return [
    ChatMessage(
      id: '1',
      name: 'Sarah\'s Laundry Service',
      lastMessage: 'Your clothes are ready for pickup! 👕',
      time: '2m ago',
      isOnline: true,
      isUnread: true,
      unreadCount: 2,
      avatar: 'S',
    ),
    ChatMessage(
      id: '2',
      name: 'Premium Cleaners',
      lastMessage: 'Thank you for choosing our service',
      time: '1h ago',
      isOnline: false,
      isUnread: false,
      unreadCount: 0,
      avatar: 'P',
    ),
    ChatMessage(
      id: '3',
      name: 'Customer Support',
      lastMessage: 'How can we help you today?',
      time: '3h ago',
      isOnline: true,
      isUnread: true,
      unreadCount: 1,
      avatar: 'CS',
    ),
    ChatMessage(
      id: '4',
      name: 'QuickWash Express',
      lastMessage: 'Your order #1234 is being processed',
      time: '5h ago',
      isOnline: true,
      isUnread: false,
      unreadCount: 0,
      avatar: 'Q',
    ),
    ChatMessage(
      id: '5',
      name: 'Elite Dry Cleaning',
      lastMessage: 'Special care items completed ✨',
      time: '1d ago',
      isOnline: false,
      isUnread: true,
      unreadCount: 3,
      avatar: 'E',
    ),
  ];
});

// Total unread chats number
final totalUnreadCountProvider = Provider<int>((ref) {
  final allChats = ref.watch(allChatsProvider);
  return allChats.where((chat) => chat.isUnread).fold(0, (sum, chat) => sum + chat.unreadCount);
});

// Total chats number
final totalChatsCountProvider = Provider<int>((ref) {
  final allChats = ref.watch(allChatsProvider);
  return allChats.length;
});

// Filtered chats
final filteredChatsProvider = Provider.family<List<ChatMessage>, String>((ref, searchQuery) {
  final allChats = ref.watch(allChatsProvider);
  final search = searchQuery.toLowerCase();
  final filterType = ref.watch(selectedChatsCategoriesProvider);

  List<ChatMessage> filtered = allChats;

  if (filterType == ChatMessageFilterType.unread) {
    filtered = filtered.where((chat) => chat.isUnread).toList();
  }

  if (search.isNotEmpty) {
    filtered = filtered.where((chat) => chat.name.toLowerCase().contains(search)).toList();
  }

  return filtered;
});
