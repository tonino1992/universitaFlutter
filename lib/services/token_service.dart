import 'dart:convert';

import 'package:http/http.dart' as http;

import '../classes/user_dto.dart';

class TokenService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<String> verifyTokenValidity(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(token),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        throw Exception('Token non trovato');
      } else if (response.statusCode == 401) {
        throw Exception('Token scaduto');
      } else {
        throw Exception('Errore durante la verifica del token');
      }
    } catch (e) {
      throw Exception('Errore durante la verifica del token');
    }
  }

  Future<void> changePassword(UserDto userDto) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userDto.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Errore durante il cambio password');
      }
    } catch (e) {
      throw Exception('Errore durante il cambio password');
    }
  }
}
