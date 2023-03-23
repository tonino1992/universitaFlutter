import 'package:intl/intl.dart';
import 'user_role.dart';

class PersonDto {
  final int? id;
  final String? userId;
  final String? name;
  final String? surname;
  final DateTime? dateOfBirth;
  final String? password;
  final String? email;
  final UserRole? role;

  PersonDto({
    this.id,
    this.userId,
    this.name,
    this.surname,
    this.dateOfBirth,
    this.password,
    this.email,
    this.role,
  });

  factory PersonDto.fromJson(Map<String, dynamic> json) {
    return PersonDto(
      id: json['id'] != null ? json['id'] as int : null,
      userId: json['userId'] != null ? json['userId'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      surname: json['surname'] != null ? json['surname'] as String : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateFormat('dd-MM-yyyy').parse(json['dateOfBirth'] as String)
          : null,
      password: json['password'] != null ? json['password'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      role: json['role'] != null
          ? UserRole.values.firstWhere((e) =>
              e.toString().split('.')[1].toUpperCase() ==
              json['role'].toString().toUpperCase())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['name'] = name;
    data['surname'] = surname;
    data['password'] = password;
    data['email'] = email;
    data['role'] = role?.toString().toUpperCase();
    data['dateOfBirth'] = dateOfBirth != null
        ? DateFormat('dd-MM-yyyy').format(dateOfBirth!)
        : null;
    return data;
  }
}
