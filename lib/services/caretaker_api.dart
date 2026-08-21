import 'dart:convert';
import 'package:http/http.dart' as http;

class CaretakerRegistrationRequest {
  final String name;
  final int age;
  final String gender;
  final String specialization;
  final int yearsOfExperience;
  final String panCard;
  final String? certificateFileName;

  CaretakerRegistrationRequest({
    required this.name,
    required this.age,
    required this.gender,
    required this.specialization,
    required this.yearsOfExperience,
    required this.panCard,
    this.certificateFileName,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'specialization': specialization,
    'yearsOfExperience': yearsOfExperience,
    'panCard': panCard,
    'certificateFileName': certificateFileName,
  };
}

class CaretakerRegistrationResponse {
  final String message;
  final String? token;
  final Map<String, dynamic>? caretakerData;

  CaretakerRegistrationResponse({
    required this.message,
    this.token,
    this.caretakerData,
  });

  factory CaretakerRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return CaretakerRegistrationResponse(
      message: json['message'] ?? 'Registration successful',
      token: json['token'],
      caretakerData: json['caretaker'],
    );
  }
}

class CaretakerApiService {
  static const String _baseUrl = 'https://api.example.com'; // Replace with actual API URL
  static const String _registerEndpoint = '/api/caretakers/register';

  /// Register a new caretaker
  static Future<CaretakerRegistrationResponse> registerCaretaker(
    CaretakerRegistrationRequest request,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$_registerEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Registration request timeout'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return CaretakerRegistrationResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Invalid registration data');
      } else if (response.statusCode == 409) {
        throw Exception('Email or PAN already registered');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Registration failed with status ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
