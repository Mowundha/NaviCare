import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class BackendService {
  static const String _baseUrl =
      'https://navicare-main-api-qrfq76wkuq-el.a.run.app';

  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.instance.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── TRAVEL ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> generateTripPlan({
    required String userId,
    required String destinationName,
    required double destinationLatitude,
    required double destinationLongitude,
    required String startDate,
    required String endDate,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/travel/generate-plan'),
      headers: await _headers(),
      body: jsonEncode({
        'user_id': userId,
        'destination_name': destinationName,
        'destination_latitude': destinationLatitude,
        'destination_longitude': destinationLongitude,
        'start_date': startDate,
        'end_date': endDate,
        'itinerary_data': {},
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── CARETAKER ────────────────────────────────────────────

  static Future<Map<String, dynamic>> findCaretakers({
    required String planId,
    required String sessionId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/agent/book-caretaker'),
      headers: await _headers(),
      body: jsonEncode({
        'plan_id': planId,
        'session_id': sessionId,
        'input_mode': 'text',
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── PAYMENT ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> createPayment({
    required String userId,
    required String planId,
    required double grossAmount,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/payment/create-intent'),
      headers: await _headers(),
      body: jsonEncode({
        'user_id': userId,
        'plan_id': planId,
        'gross_amount': grossAmount,
        'currency': 'INR',
        'payment_method': 'upi',
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── DISPATCH ─────────────────────────────────────────────

  static Future<Map<String, dynamic>> requestDispatch({
    required String planId,
    required String caretakerId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/dispatch/request'),
      headers: await _headers(),
      body: jsonEncode({
        'plan_id': planId,
        'caretaker_id': caretakerId,
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── COMMUNITY ────────────────────────────────────────────

  static Future<List<dynamic>> getCommunities() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/v1/community'),
      headers: await _headers(),
    ).timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  static Future<Map<String, dynamic>> createCommunity({
    required String name,
    required String description,
    required String whatsappInviteLink,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/community'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'description': description,
        'whatsapp_invite_link': whatsappInviteLink,
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── REVIEWS ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> submitReview({
    required String placeId,
    required int rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/reviews'),
      headers: await _headers(),
      body: jsonEncode({
        'place_id': placeId,
        'rating': rating,
        'comment': comment,
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }

  // ── TRANSIT ──────────────────────────────────────────────

  static Future<Map<String, dynamic>> queryTransit({
    required double sourceLat,
    required double sourceLon,
    required String destinationName,
    required String sessionId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/v1/agent/query-transit'),
      headers: await _headers(),
      body: jsonEncode({
        'source_latitude': sourceLat,
        'source_longitude': sourceLon,
        'destination_name': destinationName,
        'session_id': sessionId,
        'input_mode': 'text',
      }),
    ).timeout(const Duration(seconds: 30));

    return jsonDecode(response.body);
  }
}