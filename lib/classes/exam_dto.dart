import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamDto {
  final int? id;
  final DateTime? day;
  final TimeOfDay? hour;
  final String? classroom;
  final bool? isDone;
  final int? courseId;

  ExamDto({
    this.id,
    this.day,
    this.hour,
    this.classroom,
    this.isDone = false,
    this.courseId,
  });

  factory ExamDto.fromJson(Map<String, dynamic> json) {
    return ExamDto(
      id: json['id'] as int?,
      day: json['day'] != null ? DateFormat('yyyy-MM-dd').parse(json['day'] as String) : null,
      hour: json['hour'] != null
          ? TimeOfDay(
              hour: int.parse(json['hour'].split(":")[0]),
              minute: int.parse(json['hour'].split(":")[1]),
            )
          : null,
      classroom: json['classroom'] as String?,
      isDone: json['done'] as bool? ?? json['done'] as bool?,
      courseId: json['courseId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day'] = day != null ? DateFormat('yyyy-MM-dd').format(day!) : null;
    data['hour'] = hour != null
        ? '${hour!.hour.toString().padLeft(2, '0')}:${hour!.minute.toString().padLeft(2, '0')}:00'
        : null;
    data['classroom'] = classroom;
    data['done'] = isDone;
    data['courseId'] = courseId;
    return data;
  }
}
