
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart' as http;
// import 'token_storage.dart';

// /// Auth service using Firestore REST API directly.
// /// Avoids cloud_firestore SDK JS interop bug on Flutter Web.
// class AuthService {
//   // Firestore REST base URL
//   static const String _projectId = 'navicare-503706';
//   static const String _firestoreBase =
//       'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

//   // ─── Password hashing (SHA-256) ─────────────────────────────────────────────
//   static String _hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     return sha256.convert(bytes).toString();
//   }

//   // ─── Firestore REST helpers ──────────────────────────────────────────────────

//   /// Query a collection by a single field equality
//   static Future<List<Map<String, dynamic>>> _queryWhere(
//     String collection,
//     String field,
//     String value,
//   ) async {
//     final url = Uri.parse('$_firestoreBase:runQuery');
//     final body = jsonEncode({
//       'structuredQuery': {
//         'from': [
//           {'collectionId': collection}
//         ],
//         'where': {
//           'fieldFilter': {
//             'field': {'fieldPath': field},
//             'op': 'EQUAL',
//             'value': {'stringValue': value},
//           }
//         },
//         'limit': 1,
//       }
//     });

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     if (response.statusCode != 200) return [];

//     final List<dynamic> results = jsonDecode(response.body);
//     return results
//         .where((r) => r['document'] != null)
//         .map<Map<String, dynamic>>((r) => r['document'] as Map<String, dynamic>)
//         .toList();
//   }

//   /// Write a document to Firestore via REST (PATCH = create or overwrite)
//   static Future<bool> _setDocument(
//     String collection,
//     String docId,
//     Map<String, dynamic> fields,
//   ) async {
//     final url = Uri.parse('$_firestoreBase/$collection/$docId');

//     // Convert plain Dart map → Firestore field value format
//     final firestoreFields = fields.map((k, v) => MapEntry(k, _toFirestoreValue(v)));

//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'fields': firestoreFields}),
//     );

//     return response.statusCode == 200;
//   }

//   /// Convert Dart value → Firestore REST value object
//   static Map<String, dynamic> _toFirestoreValue(dynamic value) {
//     if (value == null) return {'nullValue': null};
//     if (value is bool) return {'booleanValue': value};
//     if (value is int) return {'integerValue': value.toString()};
//     if (value is double) return {'doubleValue': value};
//     if (value is String) return {'stringValue': value};
//     if (value is List) {
//       return {
//         'arrayValue': {
//           'values': value.map((e) => _toFirestoreValue(e)).toList()
//         }
//       };
//     }
//     if (value is Map) {
//       return {
//         'mapValue': {
//           'fields': value.map((k, v) => MapEntry(k.toString(), _toFirestoreValue(v)))
//         }
//       };
//     }
//     return {'stringValue': value.toString()};
//   }

//   /// Extract string field value from a Firestore REST document
//   static String? _getString(Map<String, dynamic> doc, String field) {
//     final fields = doc['fields'] as Map<String, dynamic>?;
//     if (fields == null) return null;
//     final f = fields[field] as Map<String, dynamic>?;
//     if (f == null) return null;
//     return f['stringValue'] as String?;
//   }

//   /// Generate a random-ish doc ID (UUID-lite)
//   static String _generateId() {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final rand = (now * 1000 + now % 999).toRadixString(36);
//     return 'user_$rand';
//   }

//   // ─── Register User ───────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> registerUser({
//     required String fullName,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     int? age,
//     String? gender,
//     List<String>? disabilityTypes,
//     String? mobilityEquipment,
//     String? additionalNotes,
//     String? emergencyContactName,
//     String? emergencyContactPhone,
//   }) async {
//     try {
//       // 1. Check phone already exists
//       final byPhone = await _queryWhere('Users', 'phone_number', phoneNumber);
//       if (byPhone.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this phone number already exists'};
//       }

//       // 2. Check email already exists
//       final byEmail = await _queryWhere('Users', 'email', email);
//       if (byEmail.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this email already exists'};
//       }

//       // 3. Generate user ID and write document
//       final userId = _generateId();
//       final ok = await _setDocument('Users', userId, {
//         'user_id': userId,
//         'full_name': fullName,
//         'email': email,
//         'phone_number': phoneNumber,
//         'hashed_password': _hashPassword(password),
//         'age': age ?? 0,
//         'gender': gender ?? '',
//         'disability_types': disabilityTypes ?? [],
//         'mobility_equipment': mobilityEquipment ?? '',
//         'additional_notes': additionalNotes ?? '',
//         'emergency_contact_name': emergencyContactName ?? '',
//         'emergency_contact_phone': emergencyContactPhone ?? '',
//         'voice_assistant_enabled': false,
//         'role': 'user',
//       });

//       if (!ok) {
//         return {'success': false, 'error': 'Failed to save user. Check Firestore rules.'};
//       }

//       // 4. Save session
//       await TokenStorage.instance.saveToken('local_token_$userId');
//       await TokenStorage.instance.saveUserId(userId);
//       await TokenStorage.instance.saveRole('user');
//       await TokenStorage.instance.saveUserName(fullName);

//       return {'success': true, 'data': {'user_id': userId, 'full_name': fullName}};
//     } catch (e) {
//       return {'success': false, 'error': 'Registration failed: $e'};
//     }
//   }

//   // ─── Login ───────────────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login({
//     required String identifier,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       final collection = role == 'user' ? 'Users' : 'Caretakers';
//       final hashedPassword = _hashPassword(password);

//       // Try phone first, then email
//       List<Map<String, dynamic>> docs = await _queryWhere(collection, 'phone_number', identifier);
//       if (docs.isEmpty) {
//         docs = await _queryWhere(collection, 'email', identifier);
//       }

//       if (docs.isEmpty) {
//         return {'success': false, 'error': 'No account found with this phone/email'};
//       }

//       final doc = docs.first;
//       final storedHash = _getString(doc, 'hashed_password');

//       if (storedHash != hashedPassword) {
//         return {'success': false, 'error': 'Incorrect password'};
//       }

//       final idField = role == 'user' ? 'user_id' : 'caretaker_id';
//       final subjectId = _getString(doc, idField) ?? '';
//       final name = _getString(doc, 'full_name') ?? _getString(doc, 'name') ?? '';

//       await TokenStorage.instance.saveToken('local_token_$subjectId');
//       await TokenStorage.instance.saveUserId(subjectId);
//       await TokenStorage.instance.saveRole(role);
//       await TokenStorage.instance.saveUserName(name);

//       return {'success': true, 'data': doc};
//     } catch (e) {
//       return {'success': false, 'error': 'Login failed: $e'};
//     }
//   }

//   // ─── Logout ──────────────────────────────────────────────────────────────────
//   static Future<void> logout() async {
//     await TokenStorage.instance.clearToken();
//   }
// }
































// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart' as http;
// import 'token_storage.dart';
// // import 'fcm_token_service.dart';

// // after successful login:
// // await FcmTokenService.registerFcmToken();

// /// Auth service using Firestore REST API directly.
// /// Avoids cloud_firestore SDK JS interop bug on Flutter Web.
// class AuthService {
//   static const String _projectId = 'navicare-503706';
//   static const String _firestoreBase =
//       'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

//   // ─── Password hashing (SHA-256) ─────────────────────────────────────────────
//   static String _hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     return sha256.convert(bytes).toString();
//   }

//   // ─── Firestore REST helpers ──────────────────────────────────────────────────

//   static Future<List<Map<String, dynamic>>> _queryWhere(
//     String collection,
//     String field,
//     String value,
//   ) async {
//     final url = Uri.parse('$_firestoreBase:runQuery');
//     final body = jsonEncode({
//       'structuredQuery': {
//         'from': [
//           {'collectionId': collection}
//         ],
//         'where': {
//           'fieldFilter': {
//             'field': {'fieldPath': field},
//             'op': 'EQUAL',
//             'value': {'stringValue': value},
//           }
//         },
//         'limit': 1,
//       }
//     });

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     if (response.statusCode != 200) return [];
//     final List<dynamic> results = jsonDecode(response.body);
//     return results
//         .where((r) => r['document'] != null)
//         .map<Map<String, dynamic>>((r) => r['document'] as Map<String, dynamic>)
//         .toList();
//   }

//   static Future<bool> _setDocument(
//     String collection,
//     String docId,
//     Map<String, dynamic> fields,
//   ) async {
//     final url = Uri.parse('$_firestoreBase/$collection/$docId');
//     final firestoreFields =
//         fields.map((k, v) => MapEntry(k, _toFirestoreValue(v)));
//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'fields': firestoreFields}),
//     );
//     return response.statusCode == 200;
//   }

//   static Map<String, dynamic> _toFirestoreValue(dynamic value) {
//     if (value == null) return {'nullValue': null};
//     if (value is bool) return {'booleanValue': value};
//     if (value is int) return {'integerValue': value.toString()};
//     if (value is double) return {'doubleValue': value};
//     if (value is String) return {'stringValue': value};
//     if (value is List) {
//       return {
//         'arrayValue': {
//           'values': value.map((e) => _toFirestoreValue(e)).toList()
//         }
//       };
//     }
//     if (value is Map) {
//       return {
//         'mapValue': {
//           'fields':
//               value.map((k, v) => MapEntry(k.toString(), _toFirestoreValue(v)))
//         }
//       };
//     }
//     return {'stringValue': value.toString()};
//   }

//   static String? _getString(Map<String, dynamic> doc, String field) {
//     final fields = doc['fields'] as Map<String, dynamic>?;
//     if (fields == null) return null;
//     final f = fields[field] as Map<String, dynamic>?;
//     if (f == null) return null;
//     return f['stringValue'] as String?;
//   }

//   static String _generateId(String prefix) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final rand = (now * 1000 + now % 999).toRadixString(36);
//     return '${prefix}_$rand';
//   }

//   // ─── Register User ───────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> registerUser({
//     required String fullName,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     int? age,
//     String? gender,
//     List<String>? disabilityTypes,
//     String? mobilityEquipment,
//     String? additionalNotes,
//     String? emergencyContactName,
//     String? emergencyContactPhone,
//   }) async {
//     try {
//       final byPhone = await _queryWhere('Users', 'phone_number', phoneNumber);
//       if (byPhone.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this phone number already exists'};
//       }

//       final byEmail = await _queryWhere('Users', 'email', email);
//       if (byEmail.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this email already exists'};
//       }

//       final userId = _generateId('user');
//       final ok = await _setDocument('Users', userId, {
//         'user_id': userId,
//         'full_name': fullName,
//         'email': email,
//         'phone_number': phoneNumber,
//         'hashed_password': _hashPassword(password),
//         'age': age ?? 0,
//         'gender': gender ?? '',
//         'disability_types': disabilityTypes ?? [],
//         'mobility_equipment': mobilityEquipment ?? '',
//         'additional_notes': additionalNotes ?? '',
//         'emergency_contact_name': emergencyContactName ?? '',
//         'emergency_contact_phone': emergencyContactPhone ?? '',
//         'voice_assistant_enabled': false,
//         'role': 'user',
//       });

//       if (!ok) {
//         return {'success': false, 'error': 'Failed to save user. Check Firestore rules.'};
//       }

//       await TokenStorage.instance.saveToken('local_token_$userId');
//       await TokenStorage.instance.saveUserId(userId);
//       await TokenStorage.instance.saveRole('user');
//       await TokenStorage.instance.saveUserName(fullName);

//       return {'success': true, 'data': {'user_id': userId, 'full_name': fullName}};
//     } catch (e) {
//       return {'success': false, 'error': 'Registration failed: $e'};
//     }
//   }

//   // ─── Register Caretaker ──────────────────────────────────────────────────────
//   //
//   // Writes to `Caretakers` collection. Field names match the backend
//   // Caretaker Pydantic model so the FastAPI layer can read them as-is.
//   static Future<Map<String, dynamic>> registerCaretaker({
//     required String fullName,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     required String gender,
//     required String specialization,
//     required int yearsOfExperience,
//     required String panCard,
//     String? certificateFileName,
//   }) async {
//     try {
//       // 1. Duplicate phone check
//       final byPhone =
//           await _queryWhere('Caretakers', 'phone_number', phoneNumber);
//       if (byPhone.isNotEmpty) {
//         return {
//           'success': false,
//           'error': 'An account with this phone number already exists.'
//         };
//       }

//       // 2. Duplicate email check
//       //    Backend Caretaker model stores email as "Email" (capital E)
//       final byEmail = await _queryWhere('Caretakers', 'Email', email);
//       if (byEmail.isNotEmpty) {
//         return {
//           'success': false,
//           'error': 'An account with this email already exists.'
//         };
//       }

//       // 3. Write document
//       final caretakerId = _generateId('caretaker');
//       final ok = await _setDocument('Caretakers', caretakerId, {
//         'caretaker_id': caretakerId,
//         'full_name': fullName,
//         'Email': email,             // capital-E to match Caretaker Pydantic model
//         'phone_number': phoneNumber,
//         'hashed_password': _hashPassword(password),
//         'gender': gender,
//         'specialization': specialization,
//         'years_of_experience': yearsOfExperience,
//         'pan_card': panCard,
//         'certificate_file_name': certificateFileName ?? '',
//         'certifications': <String>[],
//         'supported_disabilities': <String>[],
//         'verification_status': 'pending',
//         'is_available': false,
//         'hourly_rate': null,
//         'daily_rate': 800.0,
//         'agency_name': null,
//         'latitude': null,
//         'longitude': null,
//         'certificate_scan_url': null,
//         'role': 'caretaker',
//       });

//       if (!ok) {
//         return {
//           'success': false,
//           'error': 'Failed to save to database. Check Firestore rules.'
//         };
//       }

//       // 4. Save session
//       await TokenStorage.instance.saveToken('local_token_$caretakerId');
//       await TokenStorage.instance.saveUserId(caretakerId);
//       await TokenStorage.instance.saveRole('caretaker');
//       await TokenStorage.instance.saveUserName(fullName);
//       await TokenStorage.instance.saveCaretakerProfile({
//         'caretaker_id': caretakerId,
//         'full_name': fullName,
//         'Email': email,
//         'phone_number': phoneNumber,
//         'gender': gender,
//         'specialization': specialization,
//         'years_of_experience': yearsOfExperience,
//         'pan_card': panCard,
//       });

//       return {
//         'success': true,
//         'data': {'caretaker_id': caretakerId, 'full_name': fullName}
//       };
//     } catch (e) {
//       return {'success': false, 'error': 'Registration failed: $e'};
//     }
//   }

//   // ─── Login ───────────────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login({
//     required String identifier,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       final collection = role == 'user' ? 'Users' : 'Caretakers';
//       final hashedPassword = _hashPassword(password);

//       // Try phone first, then email
//       List<Map<String, dynamic>> docs =
//           await _queryWhere(collection, 'phone_number', identifier);
//       if (docs.isEmpty) {
//         // Users store email as 'email'; Caretakers as 'Email'
//         final emailField = role == 'user' ? 'email' : 'Email';
//         docs = await _queryWhere(collection, emailField, identifier);
//       }

//       if (docs.isEmpty) {
//         return {'success': false, 'error': 'No account found with this phone/email'};
//       }

//       final doc = docs.first;
//       final storedHash = _getString(doc, 'hashed_password');

//       if (storedHash != hashedPassword) {
//         return {'success': false, 'error': 'Incorrect password'};
//       }

//       final idField = role == 'user' ? 'user_id' : 'caretaker_id';
//       final subjectId = _getString(doc, idField) ?? '';
//       final name =
//           _getString(doc, 'full_name') ?? _getString(doc, 'name') ?? '';

//       await TokenStorage.instance.saveToken('local_token_$subjectId');
//       await TokenStorage.instance.saveUserId(subjectId);
//       await TokenStorage.instance.saveRole(role);
//       await TokenStorage.instance.saveUserName(name);
//       if (role == 'caretaker') {
//         await TokenStorage.instance.saveCaretakerProfile(doc);
//       }

//       return {'success': true, 'data': doc};
//     } catch (e) {
//       return {'success': false, 'error': 'Login failed: $e'};
//     }
//   }

//   // ─── Logout ──────────────────────────────────────────────────────────────────
//   static Future<void> logout() async {
//     await TokenStorage.instance.clearToken();
//   }
// }
















































import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import 'fcm_token_service.dart';

/// Auth service using Firestore REST API directly.
/// Avoids cloud_firestore SDK JS interop bug on Flutter Web.
class AuthService {
  static const String _projectId = 'navicare-503706';
  static const String _firestoreBase =
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  // ─── Password hashing (SHA-256) ─────────────────────────────────────────────
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ─── Firestore REST helpers ──────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> _queryWhere(
    String collection,
    String field,
    String value,
  ) async {
    final url = Uri.parse('$_firestoreBase:runQuery');
    final body = jsonEncode({
      'structuredQuery': {
        'from': [
          {'collectionId': collection}
        ],
        'where': {
          'fieldFilter': {
            'field': {'fieldPath': field},
            'op': 'EQUAL',
            'value': {'stringValue': value},
          }
        },
        'limit': 1,
      }
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) return [];
    final List<dynamic> results = jsonDecode(response.body);
    return results
        .where((r) => r['document'] != null)
        .map<Map<String, dynamic>>((r) => r['document'] as Map<String, dynamic>)
        .toList();
  }

  static Future<bool> _setDocument(
    String collection,
    String docId,
    Map<String, dynamic> fields,
  ) async {
    final url = Uri.parse('$_firestoreBase/$collection/$docId');
    final firestoreFields =
        fields.map((k, v) => MapEntry(k, _toFirestoreValue(v)));
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fields': firestoreFields}),
    );
    return response.statusCode == 200;
  }

  static Map<String, dynamic> _toFirestoreValue(dynamic value) {
    if (value == null) return {'nullValue': null};
    if (value is bool) return {'booleanValue': value};
    if (value is int) return {'integerValue': value.toString()};
    if (value is double) return {'doubleValue': value};
    if (value is String) return {'stringValue': value};
    if (value is List) {
      return {
        'arrayValue': {
          'values': value.map((e) => _toFirestoreValue(e)).toList()
        }
      };
    }
    if (value is Map) {
      return {
        'mapValue': {
          'fields':
              value.map((k, v) => MapEntry(k.toString(), _toFirestoreValue(v)))
        }
      };
    }
    return {'stringValue': value.toString()};
  }

  static String? _getString(Map<String, dynamic> doc, String field) {
    final fields = doc['fields'] as Map<String, dynamic>?;
    if (fields == null) return null;
    final f = fields[field] as Map<String, dynamic>?;
    if (f == null) return null;
    return f['stringValue'] as String?;
  }

  static String _generateId(String prefix) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rand = (now * 1000 + now % 999).toRadixString(36);
    return '${prefix}_$rand';
  }

  // ─── Register User ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    int? age,
    String? gender,
    List<String>? disabilityTypes,
    String? mobilityEquipment,
    String? additionalNotes,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    try {
      final byPhone = await _queryWhere('Users', 'phone_number', phoneNumber);
      if (byPhone.isNotEmpty) {
        return {'success': false, 'error': 'An account with this phone number already exists'};
      }

      final byEmail = await _queryWhere('Users', 'email', email);
      if (byEmail.isNotEmpty) {
        return {'success': false, 'error': 'An account with this email already exists'};
      }

      final userId = _generateId('user');
      final ok = await _setDocument('Users', userId, {
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'hashed_password': _hashPassword(password),
        'age': age ?? 0,
        'gender': gender ?? '',
        'disability_types': disabilityTypes ?? [],
        'mobility_equipment': mobilityEquipment ?? '',
        'additional_notes': additionalNotes ?? '',
        'emergency_contact_name': emergencyContactName ?? '',
        'emergency_contact_phone': emergencyContactPhone ?? '',
        'voice_assistant_enabled': false,
        'role': 'user',
      });

      if (!ok) {
        return {'success': false, 'error': 'Failed to save user. Check Firestore rules.'};
      }

      await TokenStorage.instance.saveToken('local_token_$userId');
      await TokenStorage.instance.saveUserId(userId);
      await TokenStorage.instance.saveRole('user');
      await TokenStorage.instance.saveUserName(fullName);

      // Register FCM token after successful registration
      await FcmTokenService.registerFcmToken();

      return {'success': true, 'data': {'user_id': userId, 'full_name': fullName}};
    } catch (e) {
      return {'success': false, 'error': 'Registration failed: $e'};
    }
  }

  // ─── Register Caretaker ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> registerCaretaker({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String gender,
    required String specialization,
    required int yearsOfExperience,
    required String panCard,
    String? certificateFileName,
  }) async {
    try {
      final byPhone =
          await _queryWhere('Caretakers', 'phone_number', phoneNumber);
      if (byPhone.isNotEmpty) {
        return {
          'success': false,
          'error': 'An account with this phone number already exists.'
        };
      }

      final byEmail = await _queryWhere('Caretakers', 'Email', email);
      if (byEmail.isNotEmpty) {
        return {
          'success': false,
          'error': 'An account with this email already exists.'
        };
      }

      final caretakerId = _generateId('caretaker');
      final ok = await _setDocument('Caretakers', caretakerId, {
        'caretaker_id': caretakerId,
        'full_name': fullName,
        'Email': email,
        'phone_number': phoneNumber,
        'hashed_password': _hashPassword(password),
        'gender': gender,
        'specialization': specialization,
        'years_of_experience': yearsOfExperience,
        'pan_card': panCard,
        'certificate_file_name': certificateFileName ?? '',
        'certifications': <String>[],
        'supported_disabilities': <String>[],
        'verification_status': 'pending',
        'is_available': false,
        'hourly_rate': null,
        'daily_rate': 800.0,
        'agency_name': null,
        'latitude': null,
        'longitude': null,
        'certificate_scan_url': null,
        'role': 'caretaker',
      });

      if (!ok) {
        return {
          'success': false,
          'error': 'Failed to save to database. Check Firestore rules.'
        };
      }

      await TokenStorage.instance.saveToken('local_token_$caretakerId');
      await TokenStorage.instance.saveUserId(caretakerId);
      await TokenStorage.instance.saveRole('caretaker');
      await TokenStorage.instance.saveUserName(fullName);
      await TokenStorage.instance.saveCaretakerProfile({
        'caretaker_id': caretakerId,
        'full_name': fullName,
        'Email': email,
        'phone_number': phoneNumber,
        'gender': gender,
        'specialization': specialization,
        'years_of_experience': yearsOfExperience,
        'pan_card': panCard,
      });

      // Register FCM token after successful caretaker registration
      await FcmTokenService.registerFcmToken();

      return {
        'success': true,
        'data': {'caretaker_id': caretakerId, 'full_name': fullName}
      };
    } catch (e) {
      return {'success': false, 'error': 'Registration failed: $e'};
    }
  }

  // ─── Login ───────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
    required String role,
  }) async {
    try {
      final collection = role == 'user' ? 'Users' : 'Caretakers';
      final hashedPassword = _hashPassword(password);

      List<Map<String, dynamic>> docs =
          await _queryWhere(collection, 'phone_number', identifier);
      if (docs.isEmpty) {
        final emailField = role == 'user' ? 'email' : 'Email';
        docs = await _queryWhere(collection, emailField, identifier);
      }

      if (docs.isEmpty) {
        return {'success': false, 'error': 'No account found with this phone/email'};
      }

      final doc = docs.first;
      final storedHash = _getString(doc, 'hashed_password');

      if (storedHash != hashedPassword) {
        return {'success': false, 'error': 'Incorrect password'};
      }

      final idField = role == 'user' ? 'user_id' : 'caretaker_id';
      final subjectId = _getString(doc, idField) ?? '';
      final name =
          _getString(doc, 'full_name') ?? _getString(doc, 'name') ?? '';

      await TokenStorage.instance.saveToken('local_token_$subjectId');
      await TokenStorage.instance.saveUserId(subjectId);
      await TokenStorage.instance.saveRole(role);
      await TokenStorage.instance.saveUserName(name);
      if (role == 'caretaker') {
        await TokenStorage.instance.saveCaretakerProfile(doc);
      }

      // Register FCM token after successful login
      await FcmTokenService.registerFcmToken();

      return {'success': true, 'data': doc};
    } catch (e) {
      return {'success': false, 'error': 'Login failed: $e'};
    }
  }

  // ─── Logout ──────────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    await TokenStorage.instance.clearToken();
  }
}











































































// SOLVED FILE MIGHT BE




// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart' as http;
// import 'token_storage.dart';

// /// Auth service using Firestore REST API directly.
// /// Avoids cloud_firestore SDK JS interop bug on Flutter Web.
// class AuthService {
//   static const String _projectId = 'navicare-503706';
//   static const String _firestoreBase =
//       'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

//   // ─── Password hashing (SHA-256) ─────────────────────────────────────────────
//   static String _hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     return sha256.convert(bytes).toString();
//   }

//   // ─── Firestore REST helpers ──────────────────────────────────────────────────

//   static Future<List<Map<String, dynamic>>> _queryWhere(
//     String collection,
//     String field,
//     String value,
//   ) async {
//     final url = Uri.parse('$_firestoreBase:runQuery');
//     final body = jsonEncode({
//       'structuredQuery': {
//         'from': [
//           {'collectionId': collection}
//         ],
//         'where': {
//           'fieldFilter': {
//             'field': {'fieldPath': field},
//             'op': 'EQUAL',
//             'value': {'stringValue': value},
//           }
//         },
//         'limit': 1,
//       }
//     });

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );

//     // Log for debugging
//     print('[_queryWhere] $collection.$field=$value → ${response.statusCode}');
//     if (response.statusCode != 200) {
//       print('[_queryWhere] ERROR body: ${response.body}');
//       return [];
//     }
//     final List<dynamic> results = jsonDecode(response.body);
//     return results
//         .where((r) => r['document'] != null)
//         .map<Map<String, dynamic>>((r) => r['document'] as Map<String, dynamic>)
//         .toList();
//   }

//   static Future<bool> _setDocument(
//     String collection,
//     String docId,
//     Map<String, dynamic> fields,
//   ) async {
//     final url = Uri.parse('$_firestoreBase/$collection/$docId');
//     final firestoreFields =
//         fields.map((k, v) => MapEntry(k, _toFirestoreValue(v)));
//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'fields': firestoreFields}),
//     );

//     // Log for debugging
//     print('[_setDocument] $collection/$docId → ${response.statusCode}');
//     if (response.statusCode != 200) {
//       print('[_setDocument] ERROR body: ${response.body}');
//     }
//     return response.statusCode == 200;
//   }

//   static Map<String, dynamic> _toFirestoreValue(dynamic value) {
//     if (value == null) return {'nullValue': null};
//     if (value is bool) return {'booleanValue': value};
//     if (value is int) return {'integerValue': value.toString()};
//     if (value is double) return {'doubleValue': value};
//     if (value is String) return {'stringValue': value};
//     if (value is List) {
//       return {
//         'arrayValue': {
//           'values': value.map((e) => _toFirestoreValue(e)).toList()
//         }
//       };
//     }
//     if (value is Map) {
//       return {
//         'mapValue': {
//           'fields':
//               value.map((k, v) => MapEntry(k.toString(), _toFirestoreValue(v)))
//         }
//       };
//     }
//     return {'stringValue': value.toString()};
//   }

//   static String? _getString(Map<String, dynamic> doc, String field) {
//     final fields = doc['fields'] as Map<String, dynamic>?;
//     if (fields == null) return null;
//     final f = fields[field] as Map<String, dynamic>?;
//     if (f == null) return null;
//     return f['stringValue'] as String?;
//   }

//   static String _generateId(String prefix) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final rand = (now * 1000 + now % 999).toRadixString(36);
//     return '${prefix}_$rand';
//   }

//   // ─── Register User ───────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> registerUser({
//     required String fullName,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     int? age,
//     String? gender,
//     List<String>? disabilityTypes,
//     String? mobilityEquipment,
//     String? additionalNotes,
//     String? emergencyContactName,
//     String? emergencyContactPhone,
//   }) async {
//     try {
//       print('[registerUser] Starting registration for $email / $phoneNumber');

//       final byPhone = await _queryWhere('Users', 'phone_number', phoneNumber);
//       if (byPhone.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this phone number already exists'};
//       }

//       final byEmail = await _queryWhere('Users', 'email', email);
//       if (byEmail.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this email already exists'};
//       }

//       final userId = _generateId('user');
//       print('[registerUser] Writing to Firestore with userId: $userId');

//       final ok = await _setDocument('Users', userId, {
//         'user_id': userId,
//         'full_name': fullName,
//         'email': email,
//         'phone_number': phoneNumber,
//         'hashed_password': _hashPassword(password),
//         'age': age ?? 0,
//         'gender': gender ?? '',
//         'disability_types': disabilityTypes ?? [],
//         'mobility_equipment': mobilityEquipment ?? '',
//         'additional_notes': additionalNotes ?? '',
//         'emergency_contact_name': emergencyContactName ?? '',
//         'emergency_contact_phone': emergencyContactPhone ?? '',
//         'voice_assistant_enabled': false,
//         'role': 'user',
//       });

//       if (!ok) {
//         print('[registerUser] FAILED: Firestore write returned false');
//         return {'success': false, 'error': 'Failed to save user — check Firestore rules and network'};
//       }

//       print('[registerUser] SUCCESS: user saved to Firestore');
//       await TokenStorage.instance.saveToken('local_token_$userId');
//       await TokenStorage.instance.saveUserId(userId);
//       await TokenStorage.instance.saveRole('user');
//       await TokenStorage.instance.saveUserName(fullName);

//       return {'success': true, 'data': {'user_id': userId, 'full_name': fullName}};
//     } catch (e, stack) {
//       print('[registerUser] EXCEPTION: $e\n$stack');
//       return {'success': false, 'error': 'Registration failed: $e'};
//     }
//   }

//   // ─── Register Caretaker ──────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> registerCaretaker({
//     required String fullName,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     required String gender,
//     required String specialization,
//     required int yearsOfExperience,
//     required String panCard,
//     String? certificateFileName,
//   }) async {
//     try {
//       print('[registerCaretaker] Starting for $email / $phoneNumber');

//       final byPhone = await _queryWhere('Caretakers', 'phone_number', phoneNumber);
//       if (byPhone.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this phone number already exists.'};
//       }

//       final byEmail = await _queryWhere('Caretakers', 'Email', email);
//       if (byEmail.isNotEmpty) {
//         return {'success': false, 'error': 'An account with this email already exists.'};
//       }

//       final caretakerId = _generateId('caretaker');
//       print('[registerCaretaker] Writing to Firestore with caretakerId: $caretakerId');

//       final ok = await _setDocument('Caretakers', caretakerId, {
//         'caretaker_id': caretakerId,
//         'full_name': fullName,
//         'Email': email,
//         'phone_number': phoneNumber,
//         'hashed_password': _hashPassword(password),
//         'gender': gender,
//         'specialization': specialization,
//         'years_of_experience': yearsOfExperience,
//         'pan_card': panCard,
//         'certificate_file_name': certificateFileName ?? '',
//         'certifications': <String>[],
//         'supported_disabilities': <String>[],
//         'verification_status': 'pending',
//         'is_available': false,
//         'hourly_rate': null,
//         'daily_rate': 800.0,
//         'agency_name': null,
//         'latitude': null,
//         'longitude': null,
//         'certificate_scan_url': null,
//         'role': 'caretaker',
//       });

//       if (!ok) {
//         print('[registerCaretaker] FAILED: Firestore write returned false');
//         return {'success': false, 'error': 'Failed to save to database — check Firestore rules'};
//       }

//       print('[registerCaretaker] SUCCESS: caretaker saved to Firestore');
//       await TokenStorage.instance.saveToken('local_token_$caretakerId');
//       await TokenStorage.instance.saveUserId(caretakerId);
//       await TokenStorage.instance.saveRole('caretaker');
//       await TokenStorage.instance.saveUserName(fullName);
//       await TokenStorage.instance.saveCaretakerProfile({
//         'caretaker_id': caretakerId,
//         'full_name': fullName,
//         'Email': email,
//         'phone_number': phoneNumber,
//         'gender': gender,
//         'specialization': specialization,
//         'years_of_experience': yearsOfExperience,
//         'pan_card': panCard,
//       });

//       return {
//         'success': true,
//         'data': {'caretaker_id': caretakerId, 'full_name': fullName}
//       };
//     } catch (e, stack) {
//       print('[registerCaretaker] EXCEPTION: $e\n$stack');
//       return {'success': false, 'error': 'Registration failed: $e'};
//     }
//   }

//   // ─── Login ───────────────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login({
//     required String identifier,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       print('[login] Attempting login for $identifier as $role');
//       final collection = role == 'user' ? 'Users' : 'Caretakers';
//       final hashedPassword = _hashPassword(password);

//       List<Map<String, dynamic>> docs =
//           await _queryWhere(collection, 'phone_number', identifier);
//       if (docs.isEmpty) {
//         final emailField = role == 'user' ? 'email' : 'Email';
//         docs = await _queryWhere(collection, emailField, identifier);
//       }

//       if (docs.isEmpty) {
//         print('[login] No account found for $identifier');
//         return {'success': false, 'error': 'No account found with this phone/email'};
//       }

//       final doc = docs.first;
//       final storedHash = _getString(doc, 'hashed_password');

//       if (storedHash != hashedPassword) {
//         print('[login] Password mismatch for $identifier');
//         return {'success': false, 'error': 'Incorrect password'};
//       }

//       final idField = role == 'user' ? 'user_id' : 'caretaker_id';
//       final subjectId = _getString(doc, idField) ?? '';
//       final name = _getString(doc, 'full_name') ?? _getString(doc, 'name') ?? '';

//       print('[login] SUCCESS for $identifier, id=$subjectId');
//       await TokenStorage.instance.saveToken('local_token_$subjectId');
//       await TokenStorage.instance.saveUserId(subjectId);
//       await TokenStorage.instance.saveRole(role);
//       await TokenStorage.instance.saveUserName(name);
//       if (role == 'caretaker') {
//         await TokenStorage.instance.saveCaretakerProfile(doc);
//       }

//       return {'success': true, 'data': doc};
//     } catch (e, stack) {
//       print('[login] EXCEPTION: $e\n$stack');
//       return {'success': false, 'error': 'Login failed: $e'};
//     }
//   }

//   // ─── Logout ──────────────────────────────────────────────────────────────────
//   static Future<void> logout() async {
//     await TokenStorage.instance.clearToken();
//   }
// }