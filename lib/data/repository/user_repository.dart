import '../datasource/user_datasource.dart';

class UserRepository {
  final UserDataSource _userDataSource = UserDataSource();

  Future<bool> validEmail(String email) async {
    return await _userDataSource.validEmail(email);
  }

  Future<void> postUser(String email, String password) async {
    return await _userDataSource.postUser(email, password);
  }
}