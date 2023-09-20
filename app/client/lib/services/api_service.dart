import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<Map<String, dynamic>> signup(String firstName, String lastName, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final name = '$firstName $lastName';

    try {
      final response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Signup failed');
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}
