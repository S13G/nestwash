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
