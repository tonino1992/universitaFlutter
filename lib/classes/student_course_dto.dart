class StudentCourseDto {
  final int studentId;
  final int courseId;

  StudentCourseDto({this.studentId = 0, this.courseId = 0});

  factory StudentCourseDto.fromJson(Map<String, dynamic> json) {
    return StudentCourseDto(
      studentId: json['studentId'] as int,
      courseId: json['courseId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseId': courseId,
    };
  }
}
