import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:photo_viewer/data/repository/token_repository.dart';
import 'package:photo_viewer/domain/image/image.dart';
import 'package:photo_viewer/domain/image/image_detail.dart';
import 'package:photo_viewer/domain/token/login_token.dart';
import 'package:http/http.dart' as http;

class ImageDataSource {
  String? baseUrl = dotenv.env['BASE_URL'];
  final TokenRepository _tokenRepository = TokenRepository();
  final Dio dio = Dio();

  Future<List<ImageBasic>> getImages(int page) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer ${LoginToken().accessToken}"
      };

      http.Response response = await http.get(
        Uri.parse('$baseUrl/api/v1/images?page=$page'),
        headers: headers
      );

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 401) {
        await _tokenRepository.refreshToken();
        headers = {
          "Authorization": "Bearer ${LoginToken().accessToken}"
        };

        response = await http.get(
          Uri.parse('$baseUrl/api/v1/images?page=$page'),
          headers: headers
        );
      }

      responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseBody.isEmpty) {
        return <ImageBasic>[];
      } else {
        List<ImageBasic> images = (responseBody['images'] as List).map((dynamic p) => ImageBasic.fromJson(p)).toList();
        return images;
      }
    } catch (error) {
      print(error);
      return <ImageBasic>[];
    }
  }

  Future<ImageDetail> getImageDetail(String imageUUID) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer ${LoginToken().accessToken}"
      };

      http.Response response = await http.get(
          Uri.parse('$baseUrl/api/v1/images/$imageUUID'),
          headers: headers
      );

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 401) {
        await _tokenRepository.refreshToken();
        headers = {
          "Authorization": "Bearer ${LoginToken().accessToken}"
        };

        response = await http.get(
            Uri.parse('$baseUrl/api/v1/images/$imageUUID'),
            headers: headers
        );
        responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      }

      ImageDetail i = ImageDetail.fromJson(responseBody);
      return i;
    } catch(error) {
      print(error);
      return ImageDetail();
    }
  }

  Future<List<ImageBasic>> postImages(File? image) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${LoginToken().accessToken}",
    };

    FormData data = FormData.fromMap({'images': List.from([await MultipartFile.fromFile(image!.path)])});

    try {
      Response response = await dio.post(
        Uri.parse('$baseUrl/api/v1/images').toString(),
        data: data,
        options: Options(
          headers: headers
        )
      );

      if (response.statusCode == 401) {
        await _tokenRepository.refreshToken();

        headers = {
          "Authorization": "Bearer ${LoginToken().accessToken}",
        };

        response = await dio.post(
          Uri.parse('$baseUrl/api/v1/images').toString(),
          data: data,
          options: Options(
            headers: headers
          )
        );
      } else if (response.statusCode == 200) {
        List<ImageBasic> basics = (response.data as List).map((e) => ImageBasic.fromJson(e)).toList();
        return basics;
      }

      return <ImageBasic>[];
    } catch(error) {
      print(error);
      return <ImageBasic>[];
    }
  }

  Future<String> analyzeDescription(String imageUUID, String imageUrl) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${LoginToken().accessToken}",
      "Content-Type": "application/json"
    };

    Map<String, String> body = {
      'image_uuid': imageUUID,
      'image_url': imageUrl
    };

    try {
      http.Response response = await http.post(
          Uri.parse('$baseUrl/api/v1/images/analyze'),
          headers: headers,
          body: jsonEncode(body)
      );

      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 401) {
        headers = {
          "Authorization": "Bearer ${LoginToken().accessToken}",
          "Content-Type": "application/json"
        };

        response = await http.post(
            Uri.parse('$baseUrl/api/v1/images/analyze'),
            headers: headers,
            body: jsonEncode(body)
        );

        responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      }

      return responseBody['description'] as String;
    } catch (error) {
      print(error);
      return "";
    }
  }

  Future<List<String>> analyzeTags(String imageUUID, File? image) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${LoginToken().accessToken}",
    };

    FormData data = FormData.fromMap({
      'image_uuid': imageUUID,
      'image': await MultipartFile.fromFile(image!.path)
    });

    try {
      Response response = await dio.post(
        Uri.parse('$baseUrl/api/v1/images/tags').toString(),
        data: data,
        options: Options(
          headers: headers
        )
      );

      if (response.statusCode == 401) {
        headers = {
          "Authorization": "Bearer ${LoginToken().accessToken}",
        };

        response = await dio.post(
            Uri.parse('$baseUrl/api/v1/images/tags').toString(),
            data: data,
            options: Options(
                headers: headers
            )
        );
      } else if (response.statusCode == 200) {
         List<String> tags = (response.data['tags'] as List).map((e) => e.toString()).toList();
         return tags;
      }
      return <String>[];
    } catch (error) {
      print(error);
      return <String>[];
    }
  }
}