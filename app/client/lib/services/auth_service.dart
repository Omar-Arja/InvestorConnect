import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/services/api_service.dart';

class AuthService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<String?> getToken() async {
    await init();
    return _prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    await init();
    _prefs.setString('token', token);
  }

  static Future<void> deleteToken() async {
    await init();
    _prefs.remove('token');
  }

  static Future<bool> hasToken() async {
    await init();
    return _prefs.containsKey('token');
  }

  static Future<bool?> isTokenExpired() async {
    if (await hasToken()) {
      final token = await getToken();
      final decodedToken = JwtDecoder.decode(token!);
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expiryDate);
    } else {
      return null;
    }
  }

  static Future<bool> isTokenValid() async {
    if (await hasToken()) {
      final response = await ApiService.refreshToken();
        if (response != null && response['status'] == 'success') {
          await saveToken(response['authorisation']['token']);
          return true;
        } else {
          return false;
        }
    } else {
      return false;
    }
  }

  static Future<int?> getUserId() async {
    if (await hasToken()) {
      final token = await getToken();
      final decodedToken = JwtDecoder.decode(token!);
      int parsedId = int.parse(decodedToken['sub']);
      return parsedId;
    } else {
      return null;
    }
  }

  // device token
  static Future<void> saveDeviceToken(String token) async {
    await init();
    _prefs.setString('deviceToken', token);
  }

  static Future<String?> getDeviceToken() async {
    await init();
    return _prefs.getString('deviceToken');
  }
}