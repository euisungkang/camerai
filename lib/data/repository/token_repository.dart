import 'package:photo_viewer/data/datasource/token_datasource.dart';

class TokenRepository {
  final TokenDataSource _tokenDataSource = TokenDataSource();

  Future<bool> issueToken(String email, String password) async {
    return _tokenDataSource.issueToken(email, password);
  }

  Future<void> refreshToken() async {
    await _tokenDataSource.refreshToken();
  }
}