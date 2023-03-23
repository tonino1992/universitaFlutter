import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universita_flutter/services/jwt_service.dart';

import '../classes/change_user_id_dto.dart';
import '../classes/user_dto.dart';

class UserService {
  final String baseUrl = 'http://192.168.1.150:8090';

  Future<String> login(UserDto userDto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(userDto.toJson()),
      );

      if (response.statusCode == 200) {
        // Se la risposta è OK, salva il token nel local storage
        final token = response.body;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('jwtToken', 'Bearer $token');
        return 'Login riuscito';
      } else if (response.statusCode == 401) {
        throw Exception('Credenziali non valide');
      } else if (response.statusCode == 404) {
        throw Exception('Utente non trovato');
      } else {
        throw Exception('Errore durante il login');
      }
    } catch (e) {
      throw Exception('Errore durante il login');
    }
  }

  Future<dynamic> updateUser(UserDto userDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!,
        },
        body: jsonEncode(userDto.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Aggiornamento riuscito';
      } else {
        throw Exception('Errore durante l\'aggiornamento');
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento');
    }
  }

  Future<dynamic> addUser(UserDto userDto) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!,
        },
        body: jsonEncode(userDto.toJson()),
      );

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);
        return UserDto.fromJson(userJson);
      } else {
        throw Exception('Errore durante l\'aggiunta');
      }
    } catch (e) {
      throw Exception('Errore durante l\'aggiunta');
    }
  }

  Future<void> deleteUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');

    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!,
        },);
      if (response.statusCode != 200) {
        throw Exception('Errore durante l\'eliminazione dell\'utente');
      }
    } catch (e) {
      throw Exception('Errore durante l\'eliminazione dell\'utente');
    }
  }

  Future<void> recuperaPassword(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recupera-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(userId),
      );
      if (response.statusCode != 200) {
        throw Exception('Errore durante il recupero della password');
      }
    } catch (e) {
      throw Exception('Errore durante il recupero della password');
    }
  }

  Future<void> changeUserId(ChangeUserIdDto userIds) async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/change-userid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwtToken!,
        },
        body: jsonEncode(userIds.toJson()),
      );
      if (response.statusCode == 404) {
        throw Exception('Utente non trovato');
      } else if (response.statusCode == 401) {
        throw Exception('UserId già in uso');
      } else if (response.statusCode != 200) {
        throw Exception('Errore durante la modifica del userId');
      }
    } catch (e) {
      throw Exception('Errore durante la modifica del userId');
    }
  }
}
