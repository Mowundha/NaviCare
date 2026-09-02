// /// Token storage service for managing authentication tokens.
// /// Provides a singleton instance for app-wide token access.
// class TokenStorage {
//   static final TokenStorage _instance = TokenStorage._internal();

//   String? _token;

//   TokenStorage._internal();

//   static TokenStorage get instance => _instance;

//   /// Check if user is logged in (has a valid token)
//   Future<bool> get isLoggedIn async {
//     return _token != null && _token!.isNotEmpty;
//   }

//   /// Save authentication token
//   Future<void> saveToken(String token) async {
//     _token = token;
//   }

//   /// Retrieve stored authentication token
//   Future<String?> getToken() async {
//     return _token;
//   }

//   /// Clear the stored token (logout)
//   Future<void> clearToken() async {
//     _token = null;
//   }

//   /// Check if token exists
//   Future<bool> hasToken() async {
//     return _token != null;
//   }
// }

































/// Token storage service for managing authentication tokens.
class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();

  String? _token;
  String? _userId;
  String? _role;
  String? _userName;
  Map<String, dynamic>? _caretakerProfile;

  TokenStorage._internal();

  static TokenStorage get instance => _instance;

  Future<bool> get isLoggedIn async {
    return _token != null && _token!.isNotEmpty;
  }

  Future<void> saveToken(String token) async => _token = token;
  Future<String?> getToken() async => _token;
  Future<void> clearToken() async {
    _token = null;
    _userId = null;
    _role = null;
    _userName = null;
    _caretakerProfile = null;
  }

  Future<void> saveUserId(String userId) async => _userId = userId;
  Future<String?> getUserId() async => _userId;

  Future<void> saveRole(String role) async => _role = role;
  Future<String?> getRole() async => _role;

  Future<void> saveUserName(String name) async => _userName = name;
  Future<String?> getUserName() async => _userName;

  Future<void> saveCaretakerProfile(Map<String, dynamic> profile) async {
    _caretakerProfile = Map<String, dynamic>.from(profile);
  }

  Future<Map<String, dynamic>?> getCaretakerProfile() async {
    return _caretakerProfile == null
        ? null
        : Map<String, dynamic>.from(_caretakerProfile!);
  }

  Future<bool> hasToken() async => _token != null;
}