import 'package:flutter/material.dart';

import '../classes/course_dto.dart';
import '../services/jwt_service.dart';
import '../services/teacher_service.dart';

class CourseTableTeacher extends StatefulWidget {
  const CourseTableTeacher({super.key});

  @override
  State<CourseTableTeacher> createState() => _CourseTableTeacherState();
}

class _CourseTableTeacherState extends State<CourseTableTeacher> {
  List<CourseDto> courses = [];
  TeacherService teacherService = TeacherService();
  JwtService jwtService = JwtService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseDto>>(
      future: getCourseData(),
      builder: (BuildContext context, AsyncSnapshot<List<CourseDto>> snapshot) {
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
                      DataColumn(label: Text('Azioni')),
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
                              courses[index].subject,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                            ElevatedButton(
                              onPressed: () {
                                // Qui puoi inserire la logica per terminare il corso
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                              ),
                              child: const Text(
                                'Termina',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
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

  Future<List<CourseDto>> getCourseData() async {
    try {
      // Ottiene l'ID dell'insegnante dal JWT salvato nel local storage
      final decodedToken = await jwtService.decodeJwt();
      final teacherId = decodedToken!['id'] as int;

      // Richiede i dati dei corsi dell'insegnante dal server
      final courses = await teacherService.getTeacherCourses(teacherId);
      return courses;
    } catch (e) {
      return [];
    }
  }
}