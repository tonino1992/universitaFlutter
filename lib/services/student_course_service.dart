import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:universita_flutter/classes/course_join_teacher_dto.dart';

import '../classes/student_course_dto.dart';
import '../classes/student_dto.dart';

class StudentCourseService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<List<CourseJoinTeacherDto>> getStudentCourses(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentcourses/$id/courses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwt!,
        },
      );
       if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final courses = <CourseJoinTeacherDto>[];
        for (var data in jsonData) {
          courses.add(CourseJoinTeacherDto.fromJson(data));
        }
        return courses;
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> enrollStudentInCourse(
      StudentCourseDto studentCourseDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/studentcourses/iscription'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(studentCourseDto.toJson()),
      );
      if (response.statusCode == 201) {
        return 'Iscrizione riuscita';
      } else if (response.statusCode == 409) {
        throw Exception('Studente già iscritto al corso');
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else if (response.statusCode == 400) {
        throw Exception('Corso non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StudentDto>> getStudentsByCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentcourses/$id/students'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final students = <StudentDto>[];
        for (var data in jsonData) {
          students.add(StudentDto.fromJson(data));
        }
        return students;
      } else if (response.statusCode == 404) {
        throw Exception('Corso non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
