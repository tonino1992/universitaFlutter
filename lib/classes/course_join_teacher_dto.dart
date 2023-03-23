class CourseJoinTeacherDto {
  final int? id;
  final String? subject;
  final double? hourAmount;
  final bool? isDone;
  final int? teacherId;
  final String? teacherName;
  final String? teacherSurname;

  CourseJoinTeacherDto({
    this.id,
    this.subject,
    this.hourAmount,
    this.isDone,
    this.teacherId,
    this.teacherName,
    this.teacherSurname,
  });

  factory CourseJoinTeacherDto.fromJson(Map<String, dynamic> json) {
    return CourseJoinTeacherDto(
      id: json['id'] as int?,
      subject: json['subject'] as String?,
      hourAmount: json['hourAmount'] as double?,
      isDone: json['done'] as bool?,
      teacherId: json['teacherId'] as int?,
      teacherName: json['teacherName'] as String?,
      teacherSurname: json['teacherSurname'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'hourAmount': hourAmount,
      'done': isDone,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'teacherSurname': teacherSurname,
    };
  }
}
