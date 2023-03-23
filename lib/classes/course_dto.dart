class CourseDto {
  int? id;
  String subject;
  double hourAmount;
  int teacherId;
  bool? isDone;

  CourseDto({
    required this.id,
    required this.subject,
    required this.hourAmount,
    required this.teacherId,
    required this.isDone,
  });

  factory CourseDto.fromJson(Map<String, dynamic> json) {
    return CourseDto(
      id: json['id'] as int,
      subject: json['subject'] as String,
      hourAmount: json['hourAmount'] as double,
      teacherId: json['teacherId'] as int,
      isDone: json['done'] as bool
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'hourAmount': hourAmount,
      'teacherId': teacherId,
      'done': isDone,
    };
  }
}