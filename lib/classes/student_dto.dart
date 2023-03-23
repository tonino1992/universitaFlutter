import 'package:intl/intl.dart';
import 'person_dto.dart';
import 'user_role.dart';

class StudentDto extends PersonDto {
  StudentDto({
    int id = 0,
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
  UserRole get role => UserRole.student;

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id'] as int? ?? 0,
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
    data['role'] = UserRole.student.toString().toUpperCase();
    return data;
  }
}
