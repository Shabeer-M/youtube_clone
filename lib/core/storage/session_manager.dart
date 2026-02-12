import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String isLoggedInKey = 'is_logged_in';
  static const String authTokenKey = 'auth_token';

  final SharedPreferences _prefs;

  SessionManager(this._prefs);

  Future<void> saveLoginState(bool isLoggedIn, {String? token}) async {
    await _prefs.setBool(isLoggedInKey, isLoggedIn);
    if (token != null) {
      await _prefs.setString(authTokenKey, token);
    }
  }

  bool getLoginState() {
    return _prefs.getBool(isLoggedInKey) ?? false;
  }

  String? getAuthToken() {
    return _prefs.getString(authTokenKey);
  }

  Future<void> clearSession() async {
    await _prefs.remove(isLoggedInKey);
    await _prefs.remove(authTokenKey);
  }
}
