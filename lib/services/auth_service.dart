import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  // Android emulator uses 10.0.2.2 to reach your PC.
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String baseUrl = 'http://192.168.10.218:3001/api';
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

  

static Future<Map<String, dynamic>> predictPCOS({
  required Map<String, dynamic> questionnaireData,
}) async {
 final uri = Uri.parse('http://192.168.10.218:8001/predict');

  debugPrint('PCOS API: Sending request to $uri');
  debugPrint('PCOS API: Request body ${jsonEncode(questionnaireData)}');

  final response = await http
      .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(questionnaireData),
      )
      .timeout(const Duration(seconds: 30));

  debugPrint('PCOS API: Response status ${response.statusCode}');
  debugPrint('PCOS API: Response body ${response.body}');

  final decoded = jsonDecode(response.body);

  if (decoded is! Map<String, dynamic>) {
    throw Exception('Unexpected response from prediction API.');
  }

  if (response.statusCode != 200) {
    throw Exception(
      decoded['detail']?.toString() ??
          'Prediction failed with status ${response.statusCode}.',
    );
  }

  return decoded;
}


}