import 'dart:convert';

import 'package:http/http.dart' as http;

import '../classes/course_dto.dart';
import '../classes/course_join_teacher_dto.dart';

class CourseService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<List<CourseJoinTeacherDto>> getAllCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses/all'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((json) => CourseJoinTeacherDto.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<CourseJoinTeacherDto> getCourseById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/courses/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CourseJoinTeacherDto.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Course not found');
    } else {
      throw Exception('Failed to load course');
    }
  }

  Future<String> updateCourse(CourseDto courseDto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(courseDto.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Corso aggiunto con successo';
    } else if (response.statusCode == 404) {
      throw Exception('Course not found');
    } else if (response.statusCode == 400) {
      throw Exception('Teacher not found');
    } else {
      throw Exception('Failed to update course');
    }
  }

  Future<String> addCourse(CourseDto courseDto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(courseDto.toJson()),
    );
    if (response.statusCode == 201) {
      return 'Corso aggiornato con successo';
    } else if (response.statusCode == 404) {
      throw Exception('Teacher not found');
    } else {
      throw Exception('Failed to add course');
    }
  }

  Future<int> getExamIdByCourseId(int courseId) async {
    final response = await http.get(Uri.parse('$baseUrl/courses/exams/$courseId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 404) {
      throw Exception('Course not found');
    } else {
      throw Exception('Failed to get exam ID');
    }
  }
}
