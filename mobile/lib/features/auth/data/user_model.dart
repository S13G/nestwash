class UserModel {
  final String email;
  final String fullName;
  final String? accountType;

  UserModel({required this.email, required this.fullName, this.accountType});
}
