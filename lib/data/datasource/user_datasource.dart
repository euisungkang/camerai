import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  String? baseUrl = dotenv.env['BASE_URL'];

  Future<bool> validEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/validation/email?email=$email'),
      );

      String valid = response.body;
      return valid == 'true';
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> postUser(String email, String password) async {
    Map<String, String> headers = {
      "Content-Type": "application/json"
    };

    Map<String, String> body = {
      'email': email,
      'password': password
    };

    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/api/v1/users'),
        headers: headers,
        body: jsonEncode(body)
      );
    } catch (error) {
      print(error);
    }
  }
}