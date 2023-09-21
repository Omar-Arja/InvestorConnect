import 'dart:convert';
import 'package:client/models/investor_profile.dart';
import 'package:http/http.dart' as http;
import 'package:client/models/startup_profile.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ',
  };

  // Auth requests
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        headers['Authorization'] = 'Bearer ${json.decode(response.body)['authorisation']['token']}';

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

  // Startup profile requests
  static Future<Map<String, dynamic>> createStartupProfile(StartupProfileModel startupData) async {
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
      'company_logo_file': await MultipartFile.fromFile(startupData.logoFile!.path, contentType: MediaType('image', startupData.logoFile!.path.split('.').last)),
      'pitch_video_file': await MultipartFile.fromFile(startupData.pitchVideoFile!.path, contentType: MediaType('video', startupData.pitchVideoFile!.path.split('.').last)),
    });

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
          return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error'};
    }
  }

  // Investor profile requests
  static Future<Map<String, dynamic>> createInvestorProfile(InvestorProfileModel investorData) async {
    const url = '$baseUrl/investor/create-profile';
    final dio = Dio();

    dio.options.headers['Authorization'] = '${headers['Authorization']}';
    dio.options.headers['Content-Type'] = 'multipart/form-data';

    final FormData formData = FormData.fromMap({
      'location': investorData.location,
      'bio': investorData.bio,
      'min_investment_amount': investorData.minInvestmentAmount.toString(),
      'max_investment_amount': investorData.maxInvestmentAmount.toString(),
      'industries': investorData.preferredIndustries.join(','),
      'preferred_locations': investorData.preferredLocations.join(','),
      'investment_stages': investorData.preferredInvestmentStages.join(','),
      'profile_picture_file': await MultipartFile.fromFile(investorData.profilePictureFile!.path, contentType: MediaType('image', investorData.profilePictureFile!.path.split('.').last)),
    });

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      } else {
          return {'status': 'error'};
      }
    } catch (e) {
      return {'status': 'error'};
    }
  }
}
