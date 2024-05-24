import 'package:flutter/cupertino.dart';
import 'package:photo_viewer/data/repository/token_repository.dart';
import '../../../data/repository/user_repository.dart';

class SignupViewModel with ChangeNotifier {
  SignupViewModel() {
    _userRepository = UserRepository();
    _tokenRepository = TokenRepository();
  }

  late UserRepository _userRepository = UserRepository();
  late TokenRepository _tokenRepository = TokenRepository();

  String? email;
  String? password;

  bool validEmail = false;
  bool takenEmail = false;

  bool access = false;

  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      validEmail = false;
      return "이메일을 입력해주세요";
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      validEmail = false;
      return '이메일은 형식을 확인해주세요';
    } else if (takenEmail == true) {
      return "이미 사용중인 이메일이에요";
    }

    validEmail = true;
    return null;
  }

  Future<void> signUp() async {
    await _userRepository.postUser(email!, password!);
  }

  Future<void> isEmailTaken(String nickName) async {
    takenEmail = !await _userRepository.validEmail(nickName);
    notifyListeners();
  }

  void setEmail(String emailValue) {
    email = emailValue;
    notifyListeners();
  }

  void setPassword(String passwordValue) {
    password = passwordValue;
    notifyListeners();
  }
}