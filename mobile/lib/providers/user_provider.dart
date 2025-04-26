import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/data/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(null);
});

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier(super.state);

  // Update user details
  void setUser(String email, String fullName, String? accountType) {
    state = UserModel(
      email: email,
      fullName: fullName,
      accountType: accountType,
    );
  }

  // Clear user details
  void clearUser() {
    state = null;
  }
}

final dummyAddressDataProvider = StateProvider<List<Map<String, String>>>((
  ref,
) {
  return [
    {"street": "Royalton", "houseNumber": "9"},
    {"street": "Oceanview", "houseNumber": "21"},
    {"street": "Hilltop", "houseNumber": "17B"},
  ];
});

final addressProvider = StateNotifierProvider<AddressNotifier, List<String>>((
  ref,
) {
  return AddressNotifier([]);
});

class AddressNotifier extends StateNotifier<List<String>> {
  AddressNotifier(super.state);

  void addAddress(String address) {
    state = [...state, address];
  }

  void updateAddress(String address, int index) {}

  void removeAddress(String address) {
    state = state.where((item) => item != address).toList();
  }
}
