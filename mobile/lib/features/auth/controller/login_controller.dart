import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/model/login_state.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/home_provider.dart';

class LoginController extends StateNotifier<LoginState> {
  final Ref _ref;

  LoginController(this._ref) : super(LoginState());

  Future<void> login(String email, String password, String accountType) async {
    _ref.read(loadingProvider.notifier).state = true;

    try {
      await Future.delayed(Duration(seconds: 2));

      state = state.copyWith(
        success: "Login successful",
        data: LoginData(email: email, accountType: accountType),
      );
      _ref.read(loadingProvider.notifier).state = false;
      _ref.read(routerProvider).goNamed("bottom_nav");
    } catch (e) {
      _ref.read(loadingProvider.notifier).state = false;
      state = state.copyWith(error: e.toString());
    }
  }
}
