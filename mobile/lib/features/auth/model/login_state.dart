class LoginData {
  final String email;
  final String accountType;

  LoginData({required this.email, required this.accountType});

  LoginData copyWith({String? email, String? accountType}) {
    return LoginData(
      email: email ?? this.email,
      accountType: accountType ?? this.accountType,
    );
  }
}

class LoginState {
  final String? error;
  final String? success;
  final LoginData? data;

  LoginState({this.error, this.success, this.data});

  LoginState copyWith({String? error, String? success, LoginData? data}) {
    return LoginState(error: error, success: success, data: data ?? this.data);
  }
}
