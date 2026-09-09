

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../services/token_storage.dart';

/// SOS service — uses Firestore REST API (same pattern as auth_service.dart)
/// so it works on Flutter Web without JS interop errors.
/// Notifications are sent via a Firebase Cloud Function triggered by the
/// sos_alerts onCreate event — no FCM server key needed in client code.
class SosService {
  static const String _projectId = 'navicare-503706';
  static const String _firestoreBase =
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  // ── Public API ─────────────────────────────────────────────────────────────

  static Future<String> triggerSOS() async {
    try {
      // 1. Identity
      final userId   = await TokenStorage.instance.getUserId() ?? 'unknown';
      final userName = await TokenStorage.instance.getUserName() ?? 'Traveler';

      // 2. GPS
      final Position pos = await _getCurrentPosition();

      // 3. Fetch user doc via REST (no SDK, no JS interop issue)
      final userDoc = await _getDocument('users', userId);
      final fields  = userDoc['fields'] as Map<String, dynamic>? ?? {};

      // Parse activeBooking map
      final Map<String, dynamic>? activeBooking =
          _extractMap(fields['activeBooking']);

      // 4. Build SOS Firestore fields payload
      final now = DateTime.now().toUtc().toIso8601String();
      final sosFields = <String, dynamic>{
        'userId':       {'stringValue': userId},
        'travelerName': {'stringValue': userName},
        'latitude':     {'doubleValue': pos.latitude},
        'longitude':    {'doubleValue': pos.longitude},
        'locationUrl':  {'stringValue': _mapsUrl(pos.latitude, pos.longitude)},
        'sosTime':      {'stringValue': now},
        'status':       {'stringValue': 'ACTIVE'},
        // Cloud Function reads emergencyContacts from the user doc directly
        // so we don't need to duplicate them here — just store the userId
        'bookingTitle': {
          'stringValue': activeBooking?['serviceType'] ??
              activeBooking?['title'] ?? 'No active booking'
        },
        'caretakerName': {
          'stringValue': activeBooking?['caretakerName'] ?? 'N/A'
        },
      };

      // 5. Write to Firestore via REST — Cloud Function triggers on onCreate
      final created = await _createDocument('sos_alerts', sosFields);
      if (!created) {
        return 'SOS failed: Could not reach Firebase. Check your internet connection.';
      }

      return 'SOS sent successfully. Emergency contacts notified.';

    } on LocationServiceDisabledException {
      return 'SOS failed: Location services are disabled. Please enable GPS.';
    } on PermissionDeniedException {
      return 'SOS failed: Location permission denied. Cannot send SOS without GPS.';
    } catch (e) {
      return 'SOS failed: ${e.toString()}';
    }
  }

  // ── GPS ────────────────────────────────────────────────────────────────────

  static Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw LocationServiceDisabledException();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException('Location permission denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }

  // ── Firestore REST helpers ─────────────────────────────────────────────────

  /// GET a single document. Returns the raw Firestore JSON map.
  static Future<Map<String, dynamic>> _getDocument(
    String collection,
    String docId,
  ) async {
    final url = Uri.parse('$_firestoreBase/$collection/$docId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return {};
  }

  /// POST to create a new document (auto-generated ID) in a collection.
  static Future<bool> _createDocument(
    String collection,
    Map<String, dynamic> firestoreFields,
  ) async {
    final url = Uri.parse('$_firestoreBase/$collection');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fields': firestoreFields}),
    );
    return response.statusCode == 200;
  }

  // ── Firestore value extractors ─────────────────────────────────────────────

  static Map<String, dynamic>? _extractMap(dynamic field) {
    if (field == null) return null;
    final mapFields = (field as Map)['mapValue']?['fields'];
    if (mapFields == null) return null;
    final result = <String, dynamic>{};
    (mapFields as Map).forEach((k, v) {
      result[k] = _extractScalar(v);
    });
    return result;
  }

  static dynamic _extractScalar(dynamic field) {
    if (field == null) return null;
    final f = field as Map;
    return f['stringValue'] ??
        f['integerValue'] ??
        f['doubleValue'] ??
        f['booleanValue'];
  }

  static String _mapsUrl(double lat, double lng) =>
      'https://www.google.com/maps?q=$lat,$lng';
}