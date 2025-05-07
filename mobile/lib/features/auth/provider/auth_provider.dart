import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nestcare/features/auth/controller/login_controller.dart';
import 'package:nestcare/features/auth/controller/signup_controller.dart';
import 'package:nestcare/features/auth/model/login_state.dart';
import 'package:nestcare/features/auth/model/signup_state.dart';

final signupProvider = StateNotifierProvider<SignUpController, SignUpState>(
  (ref) => SignUpController(ref),
);

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(ref),
);
