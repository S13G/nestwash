class SignUpData {
  final String email;
  final int? otp;
  final String? fullName;
  final String? password;
  final String? accountType;

  SignUpData({
    required this.email,
    this.fullName,
    this.password,
    this.accountType,
    this.otp,
  });

  SignUpData copyWith({
    String? email,
    int? otp,
    String? fullName,
    String? password,
    String? accountType,
  }) {
    return SignUpData(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
    );
  }
}

class SignUpState {
  final String? error;
  final String? success;
  final SignUpData? data;

  SignUpState({this.error, this.success, this.data});

  SignUpState copyWith({String? error, String? success, SignUpData? data}) {
    return SignUpState(error: error, success: success, data: data ?? this.data);
  }
}
