import 'package:flutter/material.dart';
import '../classes/course_join_teacher_dto.dart';
import '../services/jwt_service.dart';
import '../services/student_course_service.dart';

class CourseTableStudent extends StatefulWidget {
  const CourseTableStudent({Key? key}) : super(key: key);

  @override
  State<CourseTableStudent> createState() => _CourseTableStudentState();
}

class _CourseTableStudentState extends State<CourseTableStudent> {
  List<CourseJoinTeacherDto> courses = [];
  StudentCourseService studentCourseService = StudentCourseService();
  JwtService jwtService = JwtService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseJoinTeacherDto>>(
      future: getCourseData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CourseJoinTeacherDto>> snapshot) {
        if (snapshot.hasData) {
          courses = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Materia')),
                    DataColumn(label: Text('Ore')),
                    DataColumn(label: Text('Terminato')),
                    DataColumn(label: Text('Insegnante')),
                    DataColumn(label: Text('Prenota esame')),
                  ],
                  rows: List<DataRow>.generate(
                    courses.length,
                    (index) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          // Colori diversi per le righe pari e dispari
                          if (index.isEven) {
                            return Colors.grey.withOpacity(0.3);
                          }
                          return null;
                        },
                      ),
                      cells: [
                        DataCell(
                          Text(
                            courses[index].subject!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(Text(courses[index].hourAmount.toString())),
                        DataCell(
                          Center(
                            child: Text(
                              courses[index].isDone! ? 'Sì' : 'No',
                              style: TextStyle(
                                color: courses[index].isDone!
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${courses[index].teacherName} ${courses[index].teacherSurname}',
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              // Qui puoi inserire la logica per prenotare l'esame
                            },
                            child: const Text('Prenota esame'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<List<CourseJoinTeacherDto>> getCourseData() async {
    final decodedToken = await jwtService.decodeJwt();
    final studentId = decodedToken!['id'] as int;
    try {
      final courses = await studentCourseService.getStudentCourses(studentId);
      return courses;
    } catch (e) {
      return [];
    }
  }
}
