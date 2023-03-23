import 'package:intl/intl.dart';

class ExamJoinCourseDto {
  final int? id;
  final DateTime? day;
  final DateTime? hour;
  final int? vote;
  final String? classroom;
  final bool? isDone;
  final int? courseId;
  final String? courseSubject;
  final String? teacherName;
  final String? teacherSurname;

  ExamJoinCourseDto({
    this.id,
    this.day,
    this.hour,
    this.vote,
    this.classroom,
    this.isDone,
    this.courseId,
    this.courseSubject,
    this.teacherName,
    this.teacherSurname,
  });

  factory ExamJoinCourseDto.fromJson(Map<String, dynamic> json) {
    return ExamJoinCourseDto(
      id: json['id'] as int?,
     day: json['day'] != null ? DateFormat('yyyy-MM-dd').parse(json['day'] as String) : null,
      hour: json['hour'] != null ? DateFormat('HH:mm:ss').parse(json['hour'] as String) : null,
      vote: json['vote'] as int?,
      classroom: json['classroom'] as String?,
      isDone: json['done'] as bool?,
      courseId: json['courseId'] as int?,
      courseSubject: json['courseSubject'] as String?,
      teacherName: json['teacherName'] as String?,
      teacherSurname: json['teacherSurname'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day != null ? DateFormat('yyyy-MM-dd').format(day!) : null;
    data['hour'] = hour != null ? DateFormat('HH:mm:ss').format(hour!) : null;
    data['vote'] = vote;
    data['classroom'] = classroom;
    data['done'] = isDone;
    data['courseId'] = courseId;
    data['courseSubject'] = courseSubject;
    data['teacherName'] = teacherName;
    data['teacherSurname'] = teacherSurname;
    return data;
  }
}
