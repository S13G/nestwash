import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/model/signup_state.dart';
import 'package:nestcare/providers/auth_provider.dart';
import 'package:nestcare/providers/home_provider.dart';

class SignUpController extends StateNotifier<SignUpState> {
  final Ref _ref;

  SignUpController(this._ref) : super(SignUpState());

  Future<void> enterEmail(String email, {bool forgotPassword = false}) async {
    _ref.read(loadingProvider.notifier).state = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        data: SignUpData(email: email),
        success: "OTP sent successfully",
      );
      _ref.read(loadingProvider.notifier).state = false;

      forgotPassword
          ? _ref
              .read(routerProvider)
              .goNamed('verify_email', extra: forgotPassword)
          : _ref.read(routerProvider).goNamed('verify_email');
    } catch (e) {
      _ref.read(loadingProvider.notifier).state = false;
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> verifyOtp(int otp, {bool forgotPassword = false}) async {
    _ref.read(loadingProvider.notifier).state = true;

    try {
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(
        data: state.data!.copyWith(otp: otp),
        success: "OTP verified",
      );
      _ref.read(loadingProvider.notifier).state = false;

      forgotPassword
          ? _ref.read(routerProvider).goNamed("login")
          : _ref.read(routerProvider).goNamed("register");
    } catch (e) {
      _ref.read(loadingProvider.notifier).state = false;
      state = state.copyWith(error: e.toString());
    }
  }

  void setAccountType(String accountType) {
    final currentData = state.data;
    if (currentData != null) {
      state = state.copyWith(
        data: currentData.copyWith(accountType: accountType),
      );
    }
  }

  Future<void> completeSignup(
    String fullName,
    String password,
    String accountType,
  ) async {
    _ref.read(loadingProvider.notifier).state = true;
    try {
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(
        data: state.data!.copyWith(
          fullName: fullName,
          password: password,
          accountType: accountType,
        ),
        success: "Account registered successfully!",
      );
      _ref.read(loadingProvider.notifier).state = false;
      _ref.read(routerProvider).goNamed("login");
    } catch (e) {
      _ref.read(loadingProvider.notifier).state = false;
      state = state.copyWith(error: e.toString());
    }
  }
}
