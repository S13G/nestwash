import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/general/model/messages_model.dart';

final messageListNotifierProvider = StateNotifierProvider<MessageListNotifier, List<MessagesModel>>((ref) => MessageListNotifier());
final messageProviderName = StateProvider<String>((ref) => 'Adedotun');
final messageProviderImage = StateProvider<String>((ref) => 'assets/images/profile.png');
final messageIsOnline = StateProvider<bool>((ref) => true);

class MessageListNotifier extends StateNotifier<List<MessagesModel>> {
  MessageListNotifier() : super(_initialMessages);

  static final List<MessagesModel> _initialMessages = [
    MessagesModel(
      id: '1',
      text: 'Hello! I\'ve received your laundry pickup request. I\'ll be there in 30 minutes.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    MessagesModel(
      id: '2',
      text: 'Perfect! I\'ll have everything ready. Should I separate the delicates?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      isRead: true,
    ),
    MessagesModel(
      id: '3',
      text: 'Yes, please separate them. Also, the white shirt needs special attention - there\'s a small stain on the collar.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isRead: true,
    ),
    MessagesModel(
      id: '4',
      text: 'Noted! I\'ll take extra care of that shirt. Do you have any fabric softener preference?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isRead: true,
    ),
    MessagesModel(
      id: '5',
      text: 'I\'ve picked up your laundry. Everything is now being processed. I\'ll send you updates!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    MessagesModel(
      id: '6',
      text: 'receipt_march_2024.pdf',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: true,
      attachmentName: 'receipt_march_2024.pdf',
      attachmentType: 'pdf',
    ),
    MessagesModel(
      id: '7',
      text: 'Great! Thank you for the receipt.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isRead: true,
    ),
  ];

  /// Add a new message
  void addMessage(MessagesModel message) {
    state = [...state, message];
  }

  /// Mark message as read by ID
  void markAsRead(String messageId) {
    state = [
      for (final msg in state)
        if (msg.id == messageId)
          MessagesModel(
            id: msg.id,
            text: msg.text,
            isMe: msg.isMe,
            timestamp: msg.timestamp,
            isRead: true,
            attachmentName: msg.attachmentName,
            attachmentType: msg.attachmentType,
          )
        else
          msg,
    ];
  }
}
