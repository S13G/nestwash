import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/model/user_state.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState?>((ref) {
  return UserNotifier(null);
});

class UserNotifier extends StateNotifier<UserState?> {
  UserNotifier(super.state);

  // Clear user details
  void clearUser() {
    state = null;
  }
}

final dummyAddressDataProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [
    {"street": "Royalton", "houseNumber": "9"},
    {"street": "Oceanview", "houseNumber": "21"},
    {"street": "Hilltop", "houseNumber": "17B"},
  ];
});

final streetControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  return controller;
});

final cityControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  return controller;
});

final addressControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  return controller;
});
