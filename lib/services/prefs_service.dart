import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userApprovedKey = 'userApproved';

  static PrefsService? _instance;

  /// Get PrefsService instance with initialized SharedPreferences.
  static Future<PrefsService> getInstance() async {
    _instance ??= PrefsService();
    _instance!._prefs ??= await SharedPreferences.getInstance();

    return _instance!;
  }

  SharedPreferences? _prefs;

  /// Set current user access and refresh tokens.
  void setTokens(String accessToken, String refreshToken) {
    _prefs!.setString(accessTokenKey, accessToken);
    _prefs!.setString(refreshTokenKey, refreshToken);
  }

  /// Get current user access token.
  String? getAccessToken() {
    return _prefs!.getString(accessTokenKey);
  }

  /// Get current user refresh token.
  String? getRefreshToken() {
    return _prefs!.getString(refreshTokenKey);
  }

  /// Check if current user is approved or not.
  bool? isUserApproved() {
    return _prefs?.getBool(userApprovedKey);
  }

  /// Set user approval to approved or not.
  void setUserApproved(bool value) {
    _prefs?.setBool(userApprovedKey, value);
  }

  /// Clear all prefs.
  void clearPrefs() {
    _prefs!.clear();
  }
}