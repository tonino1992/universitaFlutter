
class StudentExamDto {
  DateTime? bookingDate;
  int? vote;
  int? studentId;
  String? studentName;
  String? studentSurname;
  int? examId;
  String? teacherName;
  String? teacherSurname;
  String? subject;

  StudentExamDto({
    this.bookingDate,
    this.vote,
    this.studentId,
    this.studentName,
    this.studentSurname,
    this.examId,
    this.teacherName,
    this.teacherSurname,
    this.subject,
  });

  factory StudentExamDto.fromJson(Map<String, dynamic> json) {
    return StudentExamDto(
      bookingDate: json['bookingDate'] != null
          ? DateTime.parse(json['bookingDate'])
          : null,
      vote: json['vote'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      studentSurname: json['studentSurname'],
      examId: json['examId'],
      teacherName: json['teacherName'],
      teacherSurname: json['teacherSurname'],
      subject: json['subject'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingDate'] = bookingDate?.toIso8601String();
    data['vote'] = vote;
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['studentSurname'] = studentSurname;
    data['examId'] = examId;
    data['teacherName'] = teacherName;
    data['teacherSurname'] = teacherSurname;
    data['subject'] = subject;
    return data;
  }
}
