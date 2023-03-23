import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universita_flutter/services/jwt_service.dart';
import 'package:universita_flutter/services/teacher_service.dart';
import '../classes/exam_join_course_dto.dart';

class ExamTableTeacher extends StatefulWidget {
  const ExamTableTeacher({Key? key}) : super(key: key);

  @override
  State<ExamTableTeacher> createState() => _ExamTableTeacherState();
}

class _ExamTableTeacherState extends State<ExamTableTeacher> {
  List<ExamJoinCourseDto> exams = [];
  TeacherService teacherService = TeacherService();
  JwtService jwtService = JwtService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamJoinCourseDto>>(
      future: getExamData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ExamJoinCourseDto>> snapshot) {
        if (snapshot.hasData) {
          exams = snapshot.data!;
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
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Ora')),
                    DataColumn(label: Text('Aula')),
                    DataColumn(label: Text('Azioni')),
                  ],
                  rows: List<DataRow>.generate(
                    exams.length,
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
                            exams[index].courseSubject!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(Text(
                            DateFormat('dd-MM-yyyy').format(exams[index].day!))),
                        DataCell(Text(
                            DateFormat('HH:mm').format(exams[index].hour!))),
                        DataCell(Text(exams[index].classroom!)),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              // Qui puoi inserire la logica per gestire l'esame
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            child: const Text(
                              'Gestisci esame',
                              style: TextStyle(color: Colors.white),
                            ),
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

  Future<List<ExamJoinCourseDto>> getExamData() async {
    try {
      final decodedToken = await jwtService.decodeJwt();
      final teacherId = decodedToken!['id'] as int;
      final exams = await teacherService.getTeacherExams(teacherId);
      return exams;
    } catch (e) {
      return [];
    }
  }
}
