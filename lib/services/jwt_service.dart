import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtService {
  Future<Map<String, dynamic>?> decodeJwt() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwtToken');

    if (jwt == null) {
      return null;
    }

    final decodedJwt = JwtDecoder.decode(jwt);

    return decodedJwt;
  }

  Future<void> deleteJwt() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwtToken');
  }
}
