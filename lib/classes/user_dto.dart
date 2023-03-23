import 'user_role.dart';

class UserDto {
  final String? userId;
  final String? email;
  final String? password;
  final UserRole? role;

  UserDto({
    this.userId,
    this.email,
    this.password,
    this.role,
  });

  UserDto.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        role = json['role'] != null ? UserRole.values.firstWhere(
            (e) => e.toString().split('.').last == json['role']) : null;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'password': password,
        'role': role?.toString().split('.').last,
      };
}
