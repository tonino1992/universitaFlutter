import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/exam_join_course_dto.dart';
import '../classes/student_dto.dart';
import '../classes/student_exam_dto.dart';

class StudentExamService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<dynamic> studentExamBooking(StudentExamDto studentExamDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/studentexams/booking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$jwtToken'
        },
        body: jsonEncode(studentExamDto.toJson()),
      );
      if (response.statusCode == 201) {
        return 'Esame creato con successo';
      } else if (response.statusCode == 404) {
        throw Exception('Studente o esame non trovato');
      } else if (response.statusCode == 400) {
        throw Exception('Esame già sostenuto');
      } else if (response.statusCode == 409) {
        throw Exception('Studente già prenotato per questo esame');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> studentExamUpdateVote(StudentExamDto studentExamDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/studentexams/updatevote'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$jwtToken'
        },
        body: jsonEncode(studentExamDto.toJson()),
      );
      if (response.statusCode == 200) {
        return 'Esame aggiornato con successo!';
      } else if (response.statusCode == 404) {
        throw Exception('Studente o esame non trovato');
      } else if (response.statusCode == 400) {
        throw Exception('Esame non ancora sostenuto');
      } else if (response.statusCode == 409) {
        throw Exception('Esame già votato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ExamJoinCourseDto>> getStudentExamsToDo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentexams/$id/examstodo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<ExamJoinCourseDto> exams = [];
        for (var json in jsonData) {
          exams.add(ExamJoinCourseDto.fromJson(json));
        }
        return exams;
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StudentDto>> getStudentsByExam(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentexams/$examId/students'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        final students =
            jsonData.map((data) => StudentDto.fromJson(data)).toList();
        return students;
      } else if (response.statusCode == 404) {
        throw Exception('Esame non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ExamJoinCourseDto>> getStudentExamsDone(int studentId) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentexams/$studentId/examsdone'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        final exams =
            jsonData.map((data) => ExamJoinCourseDto.fromJson(data)).toList();
        return exams;
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StudentExamDto>> findAllByExamId(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/studentexams/$examId/all'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        final studentExams =
            jsonData.map((data) => StudentExamDto.fromJson(data)).toList();
        return studentExams;
      } else if (response.statusCode == 404) {
        throw Exception('Esame non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<StudentExamDto>> getDoneExamsByStudent(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students/$id/doneexams'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<StudentExamDto> studentExams = List<StudentExamDto>.from(
            jsonData.map((x) => StudentExamDto.fromJson(x)));
        return studentExams;
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
