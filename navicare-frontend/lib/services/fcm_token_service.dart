import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

/// Registers this device's FCM token to Firestore after login.
/// Cloud Function reads this token when SOS fires to send push notification.
class FcmTokenService {
  static const String _projectId = 'navicare-503706';
  static const String _firestoreBase =
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  /// Call this once right after login succeeds.
  static Future<void> registerFcmToken() async {
    try {
      final userId = await TokenStorage.instance.getUserId();
      if (userId == null || userId.isEmpty) return;

      // Request notification permission (needed on iOS + Web)
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('Notification permission denied');
        return;
      }

      // Get this device's unique FCM token
      final token = await messaging.getToken(
        // vapidKey only needed for Flutter Web — get from:
        // Firebase Console → Project Settings → Cloud Messaging
        // → Web Push certificates → Key pair
        // vapidKey: 'YOUR_VAPID_KEY_HERE',
      );

      if (token == null || token.isEmpty) return;

      print('FCM Token: $token'); // remove after testing

      // Save token to Firestore users/{userId}
      await _saveTokenToFirestore(userId, token);

      // Listen for token refresh and update Firestore automatically
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _saveTokenToFirestore(userId, newToken);
      });
    } catch (e) {
      print('FCM token registration failed: $e');
    }
  }

  /// PATCH users/{userId} with the new fcmToken field via REST API.
  static Future<void> _saveTokenToFirestore(
    String userId,
    String token,
  ) async {
    final url = Uri.parse(
      '$_firestoreBase/users/$userId?updateMask.fieldPaths=fcmToken',
    );

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fields': {
          'fcmToken': {'stringValue': token},
        },
      }),
    );

    if (response.statusCode == 200) {
      print('FCM token saved to Firestore');
    } else {
      print('Failed to save FCM token: ${response.body}');
    }
  }
}