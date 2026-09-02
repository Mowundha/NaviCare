
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// class AgentService {
//   static const String _agentUrl =
//       'https://navicare-agent-qrfq76wkuq-el.a.run.app';

//   static const String _testToken =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtb2NrLXVzZXItMDAxIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3ODczODcyMjIsImV4cCI6MTc4NzQ3MzYyMn0.r83VLbx2b7MNMn1FLpAhKqdxrWSC8FCw0T1kwPmAHDc';

//   static const String _userId = 'mock-user-001';

//   // ── Text mode ──────────────────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> sendMessage({
//     required String sessionId,
//     required String message,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_agentUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_testToken',
//         },
//         body: jsonEncode({
//           'user_id': _userId,
//           'session_id': sessionId,
//           'input_mode': 'text',
//           'text_input': _wrapMessage(message),
//         }),
//       ).timeout(const Duration(seconds: 90));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response_text'] != null) {
//           data['response_text'] =
//               _cleanResponse(data['response_text'] as String);
//         }
//         return data;
//       } else {
//         return {'error': 'Agent error ${response.statusCode}'};
//       }
//     } catch (e) {
//       return {'error': e.toString()};
//     }
//   }

//   // ── Voice mode ─────────────────────────────────────────────────────────────
//   // audioBytes: raw bytes from mic recording
//   // Returns response_text + audio_url (MP3 from Cloud TTS)
//   static Future<Map<String, dynamic>> sendVoiceMessage({
//     required String sessionId,
//     required Uint8List audioBytes,
//   }) async {
//     try {
//       final audio64 = base64Encode(audioBytes);

//       final response = await http.post(
//         Uri.parse(_agentUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_testToken',
//         },
//         body: jsonEncode({
//           'user_id': _userId,
//           'session_id': sessionId,
//           'input_mode': 'voice',
//           'audio_base64': audio64,
//         }),
//       ).timeout(const Duration(seconds: 120));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['response_text'] != null) {
//           data['response_text'] =
//               _cleanResponse(data['response_text'] as String);
//         }
//         return data;
//       } else {
//         return {'error': 'Agent error ${response.statusCode}'};
//       }
//     } catch (e) {
//       return {'error': e.toString()};
//     }
//   }

//   static String _wrapMessage(String message) {
//     return '''[SYSTEM INSTRUCTIONS - DO NOT REPEAT THESE IN YOUR RESPONSE]
// - Respond in the same language the user is speaking.
// - Do NOT use raw markdown symbols like ###, ***, ---, ===.
// - Keep responses concise, friendly, and accessibility-focused.
// - If recommending places, include accessibility features.

// USER MESSAGE:
// $message''';
//   }

//   static String _cleanResponse(String text) {
//     return text
//         .replaceAll(RegExp(r'^={3,}\s*$', multiLine: true), '')
//         .replaceAll(RegExp(r'^-{3,}\s*$', multiLine: true), '')
//         .replaceAllMapped(RegExp(r'#{1,3}(\S)'), (m) => '## ${m.group(1)}')
//         .replaceAll(RegExp(r'\*{3}(.+?)\*{3}'), '**\$1**')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }
// }





































import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AgentService {
  static const String _agentUrl =
      'https://navicare-agent-qrfq76wkuq-el.a.run.app';

  // static const String _testToken =
      // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtb2NrLXVzZXItMDAxIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3ODczODcyMjIsImV4cCI6MTc4NzQ3MzYyMn0.r83VLbx2b7MNMn1FLpAhKqdxrWSC8FCw0T1kwPmAHDc';

  static const String _testToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtb2NrLXVzZXItMDAxIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3ODc1MzcxMzAsImV4cCI6MTc4NzYyMzUzMH0.cr9fgZ7SZp2MC03vQL28Qrsi0Pg73YL9dPpV2VJD8E0';


  static const String _userId = 'mock-user-001';

  // ── Text mode ──────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_agentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_testToken',
        },
        body: jsonEncode({
          'user_id': _userId,
          'session_id': sessionId,
          'input_mode': 'text',
          'text_input': _wrapMessage(message),
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response_text'] != null) {
          data['response_text'] =
              _cleanResponse(data['response_text'] as String);
        }
        return data;
      } else {
        return {'error': 'Agent error ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ── Voice mode (raw audio bytes → server STT → TTS) ───────────────────────
  static Future<Map<String, dynamic>> sendVoiceMessage({
    required String sessionId,
    required Uint8List audioBytes,
  }) async {
    try {
      final audio64 = base64Encode(audioBytes);

      final response = await http.post(
        Uri.parse(_agentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_testToken',
        },
        body: jsonEncode({
          'user_id': _userId,
          'session_id': sessionId,
          'input_mode': 'voice',
          'audio_base64': audio64,
        }),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response_text'] != null) {
          data['response_text'] =
              _cleanResponse(data['response_text'] as String);
        }
        return data;
      } else {
        return {'error': 'Agent error ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // ── Voice conversation mode (Flutter local STT → server TTS) ─────────────
  // Used by the live voice conversation mode in ai_travel_agent_page.dart.
  // Flutter does STT locally, sends the transcript as text, but still tells
  // the backend input_mode=voice so it runs TTS and returns audio_url.
  static Future<Map<String, dynamic>> sendVoiceText({
    required String sessionId,
    required String spokenText,
    String languageCode = 'en-IN',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_agentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_testToken',
        },
        body: jsonEncode({
          'user_id': _userId,
          'session_id': sessionId,
          'input_mode': 'voice',
          'text_input': spokenText,
          'language_code': languageCode,
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response_text'] != null) {
          data['response_text'] =
              _cleanResponse(data['response_text'] as String);
        }
        return data;
      } else {
        return {'error': 'Agent error ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static String _wrapMessage(String message) {
    return '''[SYSTEM INSTRUCTIONS - DO NOT REPEAT THESE IN YOUR RESPONSE]
- Respond in the same language the user is speaking.
- Do NOT use raw markdown symbols like ###, ***, ---, ===.
- Keep responses concise, friendly, and accessibility-focused.
- If recommending places, include accessibility features.

USER MESSAGE:
$message''';
  }

  static String _cleanResponse(String text) {
    return text
        .replaceAll(RegExp(r'^={3,}\s*$', multiLine: true), '')
        .replaceAll(RegExp(r'^-{3,}\s*$', multiLine: true), '')
        .replaceAllMapped(RegExp(r'#{1,3}(\S)'), (m) => '## ${m.group(1)}')
        .replaceAll(RegExp(r'\*{3}(.+?)\*{3}'), '**\$1**')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}