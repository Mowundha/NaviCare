/// Token storage service for managing authentication tokens.
/// Provides a singleton instance for app-wide token access.
class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();

  String? _token;

  TokenStorage._internal();

  static TokenStorage get instance => _instance;

  /// Check if user is logged in (has a valid token)
  Future<bool> get isLoggedIn async {
    return _token != null && _token!.isNotEmpty;
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    _token = token;
  }

  /// Retrieve stored authentication token
  Future<String?> getToken() async {
    return _token;
  }

  /// Clear the stored token (logout)
  Future<void> clearToken() async {
    _token = null;
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    return _token != null;
  }
}
