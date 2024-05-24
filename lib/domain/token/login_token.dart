import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/repository/token_repository.dart';
import '../../data/repository/user_repository.dart';

class LoginToken {
  String? refreshToken;
  String? accessToken;
  late FlutterSecureStorage storage;
  late UserRepository userRepository;
  late TokenRepository tokenRepository;

  LoginToken._privateConstructor() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    IOSOptions getIOSOptions() => const IOSOptions();
    storage = FlutterSecureStorage(
        aOptions: getAndroidOptions(), iOptions: getIOSOptions());
  }

  static final LoginToken _instance = LoginToken._privateConstructor();

  factory LoginToken() {
    return _instance;
  }

  Future<void> login() async {
    userRepository = UserRepository();
    tokenRepository = TokenRepository();
    if (await storage.containsKey(key: 'accessToken') && await storage.containsKey(key: 'refreshToken')) {
      String? savedAccessToken = await storage.read(key: 'accessToken');
      String? savedRefreshToken = await storage.read(key: 'refreshToken');
      accessToken = savedAccessToken;
      refreshToken = savedRefreshToken;
      await tokenRepository.refreshToken();
    }
  }

  LoginToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access'];
    refreshToken = json['refresh'];
  }

  Future<void> deleteAllTokens() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    accessToken = null;
    refreshToken = null;
  }

  Future<void> saveTokens() async {
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }
}


