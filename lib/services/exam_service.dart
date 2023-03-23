import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/exam_dto.dart';
import '../classes/exam_join_course_dto.dart';

class ExamService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<List<ExamJoinCourseDto>> getAllExams() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exams/all'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        final exams =
            jsonData.map((e) => ExamJoinCourseDto.fromJson(e)).toList();
        return exams;
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ExamJoinCourseDto> getExamById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exams/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final examDto = ExamJoinCourseDto.fromJson(jsonData);
        return examDto;
      } else if (response.statusCode == 404) {
        throw Exception('Esame non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> addExam(ExamDto examDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exams/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(examDto.toJson()),
      );
      if (response.statusCode == 201) {
        return 'Esame aggiunto con successo';
      } else if (response.statusCode == 404) {
        throw Exception('Corso non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateExam(ExamDto examDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/exams/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(examDto.toJson()),
      );
      if (response.statusCode == 200) {
        return 'Esame aggiornato con successo!';
      } else if (response.statusCode == 404) {
        throw Exception('Esame non trovato');
      } else if (response.statusCode == 400) {
        throw Exception('Corso non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

 Future<void> deleteExam(int id) async {
  final prefs = await SharedPreferences.getInstance();
  final jwtToken = prefs.getString('jwtToken');
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/exams/delete/$id'),
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
