import 'package:shared_preferences/shared_preferences.dart';

/// Manages JWT token storage and retrieval using SharedPreferences.
class AuthTokenService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  AuthTokenService(this._prefs);

  /// Save the JWT access token.
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Retrieve the stored JWT access token.
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Save the user ID after login.
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Retrieve the stored user ID.
  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Check if the user is authenticated (has a valid token stored).
  bool get isAuthenticated => getToken() != null;

  /// Clear all auth data (logout).
  Future<void> clearAuth() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userIdKey);
  }

  /// Save onboarding completion flag.
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool('onboarding_completed', completed);
  }

  /// Check if user has completed onboarding.
  bool get hasCompletedOnboarding {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  /// Save disclaimer acceptance flag.
  Future<void> setDisclaimerAccepted(bool accepted) async {
    await _prefs.setBool('disclaimer_accepted', accepted);
  }

  /// Check if user has accepted the disclaimer.
  bool get hasAcceptedDisclaimer {
    return _prefs.getBool('disclaimer_accepted') ?? false;
  }
}
