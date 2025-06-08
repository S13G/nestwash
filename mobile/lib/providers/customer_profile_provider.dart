import 'package:hooks_riverpod/hooks_riverpod.dart';

final isEditingProvider = StateProvider<bool>((ref) => false);

final emailNotificationsProvider = StateProvider<bool>((ref) => true);
