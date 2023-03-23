import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../classes/course_dto.dart';
import '../classes/exam_join_course_dto.dart';
import '../classes/teacher_dto.dart';

class TeacherService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<List<CourseDto>> getTeacherCourses(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers/$id/courses'),
        headers: <String, String>{
          'Authorization': jwtToken!,
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      final List<dynamic> coursesJson = jsonDecode(response.body);
      final List<CourseDto> courses = coursesJson
          .map((courseJson) => CourseDto.fromJson(courseJson))
          .toList();
      return courses;
    } catch (e) {
      throw Exception('Errore durante la richiesta dei corsi');
    }
  }

  Future<List<TeacherDto>> getAllTeachers() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers/all'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        final listDto = jsonData.map((e) => TeacherDto.fromJson(e)).toList();
        return listDto;
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TeacherDto> getTeacherById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final teacherDto = TeacherDto.fromJson(jsonData);
        return teacherDto;
      } else if (response.statusCode == 404) {
        throw Exception('Insegnante non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ExamJoinCourseDto>> getTeacherExams(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers/$id/exams'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        final listExamDto =
            jsonData.map((e) => ExamJoinCourseDto.fromJson(e)).toList();
        return listExamDto;
      } else if (response.statusCode == 404) {
        throw Exception('Insegnante non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TeacherDto> addTeacher(TeacherDto teacherDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teachers/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(teacherDto.toJson()),
      );
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final teacher = TeacherDto.fromJson(jsonData);
        return teacher;
      } else if (response.statusCode == 400) {
        throw Exception('Richiesta non valida');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TeacherDto> updateTeacher(TeacherDto teacherDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/teachers/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(teacherDto.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final teacher = TeacherDto.fromJson(jsonData);
        return teacher;
      } else if (response.statusCode == 404) {
        throw Exception('Insegnante non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTeacher(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/teachers/delete/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
