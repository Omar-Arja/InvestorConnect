import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'auth_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:InvestorConnect/models/startup_profile.dart';
import 'package:InvestorConnect/models/investor_profile.dart';
import 'package:InvestorConnect/models/message.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.11:8000/api';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ',
  };

  // Auth requests
  static Future<Map<String, dynamic>> login(
      String email, String password, String? deviceToken) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
        'device_token': deviceToken ?? '',
      });

      if (response.statusCode == 200) {
        headers['Authorization'] =
            'Bearer ${json.decode(response.body)['authorisation']['token']}';

        return json.decode(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<Map<String, dynamic>> signup(
      String firstName, String lastName, String email, String password) async {
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
        throw Exception();
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        AuthService.deleteToken();
        return json.decode(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  static Future<Map<String, dynamic>?> refreshToken() async {
    final url = Uri.parse('$baseUrl/auth/refresh');
    final token = await AuthService.getToken();

    headers['Authorization'] = 'Bearer $token';

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        headers['Authorization'] =
            'Bearer ${json.decode(response.body)['authorisation']['token']}';
        return json.decode(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      print('Refresh token failed: $e');
    }
    return null;
  }

  // Investor profile requests
  static Future<Map<String, dynamic>> createInvestorProfile(
      InvestorProfileModel investorData) async {
    const url = '$baseUrl/investor/create-profile';
    final dio = Dio();

    dio.options.headers['Authorization'] = '${headers['Authorization']}';
    dio.options.headers['Content-Type'] = 'multipart/form-data';

    final FormData formData = FormData.fromMap({
      'calendly_link': investorData.calendlyLink,
      'location': investorData.location,
      'bio': investorData.bio,
      'min_investment_amount': investorData.minInvestmentAmount.toString(),
      'max_investment_amount': investorData.maxInvestmentAmount.toString(),
      'industries': investorData.preferredIndustries.join(','),
      'preferred_locations': investorData.preferredLocations.join(','),
      'investment_stages': investorData.preferredInvestmentStages.join(','),
      'profile_picture_file': await MultipartFile.fromFile(
          investorData.profilePictureFile!.path,
          contentType: MediaType(
              'image', investorData.profilePictureFile!.path.split('.').last)),
    });

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error', 'error': '$e'};
    }
  }

  // Startup profile requests
  static Future<Map<String, dynamic>> createStartupProfile(
      StartupProfileModel startupData) async {
    const url = '$baseUrl/startup/create-profile';
    final dio = Dio();

    dio.options.headers['Authorization'] = '${headers['Authorization']}';
    dio.options.headers['Content-Type'] = 'multipart/form-data';

    final FormData formData = FormData.fromMap({
      'company_name': startupData.companyName,
      'location': startupData.location,
      'industries': startupData.industries.join(','),
      'investment_stage': startupData.investmentStage,
      'company_description': startupData.companyDescription,
      'min_investment_amount': startupData.minInvestmentAmount.toString(),
      'max_investment_amount': startupData.maxInvestmentAmount.toString(),
      'preferred_locations': startupData.preferredLocations.join(','),
      'company_logo_file': await MultipartFile.fromFile(
          startupData.logoFile!.path,
          contentType:
              MediaType('image', startupData.logoFile!.path.split('.').last)),
      'pitch_video_file': await MultipartFile.fromFile(
          startupData.pitchVideoFile!.path,
          contentType: MediaType(
              'video', startupData.pitchVideoFile!.path.split('.').last)),
    });

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error', 'error': '$e'};
    }
  }

  // Profile requests
  static Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('$baseUrl/profile/get');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error', 'error': '$e'};
    }
  }

  // Messages requests
  static Future<Map<String, dynamic>> getChats() async {
    final url = Uri.parse('$baseUrl/messages/all');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error', 'error': '$e'};
    }
  }

  static Future<Map<String, dynamic>> sendMessage(Message message) async {
    final url = Uri.parse('$baseUrl/messages/send');
    final body = message.toJson();

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'error occured': '$e'};
    }
  }

  // AI requests
  static Future<Map<String, dynamic>> getPotentialMatches() async {
    final url = Uri.parse('$baseUrl/swipe/all');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'error occured': '$e'};
    }
  }

  // Swipe requests
  static Future<Map<String, dynamic>> swipedRight(int? userId) async {
    if (userId == null) {
      return {'status': 'error', 'error': 'User id is null'};
    }

    final url = Uri.parse('$baseUrl/swipe/right');
    final body = {'swiped_id': userId.toString()};

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'error occured': '$e'};
    }
  }

  // Notification requests
  static Future<Map<String, dynamic>> getNotifications() async {
    final url = Uri.parse('$baseUrl/notifications/all');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error'};
      }
    } catch (e) {
      return {'error occured': '$e'};
    }
  }
}
