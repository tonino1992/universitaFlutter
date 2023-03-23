import 'package:flutter/material.dart';
import 'package:universita_flutter/components/course_table_student.dart';
import 'package:universita_flutter/components/drawer_student.dart';
import 'package:universita_flutter/components/exam_table_teacher.dart';
import 'package:universita_flutter/services/jwt_service.dart';

import '../components/course_table_teacher.dart';
import '../components/drawer_techer.dart';
import '../components/examToDo_table_student.dart';
import '../components/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  JwtService jwtService = JwtService();
  String _currentScreen = 'home';
  late Map<String, Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = _buildScreens();
  }

  Map<String, Widget> _buildScreens() {
    return {
      'home': HomeBody(
        onScreenSelected: (screen) {
          setState(() {
            _currentScreen = screen;
          });
        },
      ),
      'teacherCourses': const CourseTableTeacher(),
      'studentCourses': const CourseTableStudent(),
      'teacherExams': const ExamTableTeacher(),
      'studentExamsToDo': const ExamTableStudent(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      drawer: _buildDrawer(),
      body: _screens[_currentScreen] ?? Container(),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: FutureBuilder(
          future: jwtService.decodeJwt(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!['role'] == 'STUDENT') {
                return const Text('STUDENTE');
              } else {
                return const Text('INSEGNANTE');
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
      // Aggiungi il bottone per aprire il menu laterale
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return FutureBuilder(
      future: jwtService.decodeJwt(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!['role'] == 'STUDENT') {
            return DrawerStudent(
              onScreenSelected: (screen) {
                setState(() {
                  _currentScreen = screen;
                });
              },
            );
          } else {
            return DrawerTeacher(
              onScreenSelected: (screen) {
                setState(() {
                  _currentScreen = screen;
                });
              },
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
