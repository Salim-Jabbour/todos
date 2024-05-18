import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  const AuthLocalDataSource();

  // set user token
  Future<void> setUserToken(String token);

  // get the current token
  Future<String?> getUserToken();

  // set id
  Future<void> setUserId(String id);
  Future<String?> getUserId();

  // set username
  Future<void> setUserImage(String image);
  Future<String?> getUserImage();

  // set username
  Future<void> setUserName(String name);
  Future<String?> getUserName();

  //clear user data (role & token)
  Future<void> clearAllUserData();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);

  final _keyToken = 'token';
  final _keyId = 'id';
  final _keyUsername = 'name';
  final _keyImage = 'image';

  final SharedPreferences _prefs;

  @override
  Future<void> clearAllUserData() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyId);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyImage);
  }

  @override
  Future<String?> getUserId() async {
    return _prefs.getString(_keyId);
  }

  @override
  Future<String?> getUserImage() async {
    return _prefs.getString(_keyImage);
  }

  @override
  Future<String?> getUserName() async {
    return _prefs.getString(_keyUsername);
  }

  @override
  Future<String?> getUserToken() async {
    return _prefs.getString(_keyToken);
  }

  @override
  Future<void> setUserId(String id) async {
    await _prefs.setString(_keyId, id);
  }

  @override
  Future<void> setUserImage(String image) async {
    await _prefs.setString(_keyImage, image);
  }

  @override
  Future<void> setUserName(String name) async {
    await _prefs.setString(_keyUsername, name);
  }

  @override
  Future<void> setUserToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }
}
