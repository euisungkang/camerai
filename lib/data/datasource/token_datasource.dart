import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:photo_viewer/domain/token/login_token.dart';
import 'package:http/http.dart' as http;

class TokenDataSource {
  String? baseUrl = dotenv.env['BASE_URL'];

  Future<bool> issueToken(String email, String password) async {
    LoginToken loginToken = LoginToken();
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json"
      };
      Map<String, String> body = {
        'user_email': email,
        'password': password
      };

      http.Response response = await http.post(
          Uri.parse('$baseUrl/api/v1/token'),
          headers: headers,
          body: jsonEncode(body)
      );

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        loginToken.accessToken = responseBody['access'];
        loginToken.refreshToken = responseBody['refresh'];
        await loginToken.saveTokens();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> refreshToken() async {
    LoginToken loginToken = LoginToken();
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json"
      };
      Map<String, String> body = {
        "refresh": loginToken.refreshToken!
      };

      http.Response response = await http.post(
          Uri.parse('$baseUrl/api/v1/token/refresh'),
          headers: headers,
          body: jsonEncode(body)
      );

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      loginToken.accessToken = responseBody['access'];
      loginToken.refreshToken = responseBody['refresh'];
      await loginToken.saveTokens();
    } catch (error) {
      print(error);
    }
  }
}