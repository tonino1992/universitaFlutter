import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../classes/student_dto.dart';

class StudentService {
  final String baseUrl = 'http://192.168.1.150:8090';
  Future<List<StudentDto>> getAllStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students/all'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        final students =
            jsonData.map((student) => StudentDto.fromJson(student)).toList();
        return students;
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<StudentDto> getStudentById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final studentDto = StudentDto.fromJson(jsonData);
        return studentDto;
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> addStudent(StudentDto studentDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(studentDto.toJson()),
      );
      if (response.statusCode == 201) {
        return 'Studente aggiunto con successo';
      } else if (response.statusCode == 400) {
        throw Exception('Richiesta non valida');
      } else if (response.statusCode == 401) {
        throw Exception('Non autorizzato');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updateStudent(StudentDto studentDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/students/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(studentDto.toJson()),
      );
      if (response.statusCode == 200) {
        return 'Studente aggiornato con successo';
      } else if (response.statusCode == 404) {
        throw Exception('Studente non trovato');
      } else if (response.statusCode == 409) {
        throw Exception('Utente già esistente');
      } else {
        throw Exception('Errore durante la richiesta');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteStudent(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/students/delete/$id'),
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
