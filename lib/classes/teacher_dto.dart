import 'package:intl/intl.dart';
import 'package:universita_flutter/classes/person_dto.dart';
import 'package:universita_flutter/classes/user_role.dart';

class TeacherDto extends PersonDto {
  TeacherDto({
    int? id,
    required String userId,
    String? name,
    String? surname,
    DateTime? dateOfBirth,
    String? password,
    String? email,
  }) : super(
          id: id,
          userId: userId,
          name: name,
          surname: surname,
          dateOfBirth: dateOfBirth,
          password: password,
          email: email,
        );

  @override
  UserRole get role => UserRole.teacher;

  factory TeacherDto.fromJson(Map<String, dynamic> json) {
    return TeacherDto(
      id: json['id'] as int,
      userId: json['userId'] as String,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateFormat('dd-MM-yyyy').parse(json['dateOfBirth'] as String)
          : null,
      password: json['password'] as String?,
      email: json['email'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['role'] = UserRole.teacher.toString().toUpperCase();
    return data;
  }
}
