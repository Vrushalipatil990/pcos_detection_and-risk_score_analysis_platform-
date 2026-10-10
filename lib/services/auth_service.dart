import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Android emulator uses 10.0.2.2 to reach your PC.
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // static const String baseUrl = 'http://192.168.42.181';
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
      }),
    );

    return {
      'statusCode': response.statusCode,
      ...jsonDecode(response.body) as Map<String, dynamic>,
    };
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return {
      'statusCode': response.statusCode,
      ...jsonDecode(response.body) as Map<String, dynamic>,
    };
  }
}