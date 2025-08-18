import 'dart:convert';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static FlutterSecureStorage _storage = const FlutterSecureStorage();
  static http.Client _httpClient = http.Client();

  static String apiBaseUrl = Constants.apiBaseUrl;

  static void overrideDependencies({
    FlutterSecureStorage? storage,
    http.Client? httpClient,
    String? baseUrl,
  }) {
    if (storage != null) _storage = storage;
    if (httpClient != null) _httpClient = httpClient;
    if (baseUrl != null) ApiService.apiBaseUrl = baseUrl;
  }

  static Future<http.Response> Function(String endpoint)? mockGetWithAuth;
  static Future<http.Response> Function(String endpoint)? mockPostWithAuth;

  static Future<String?> _getToken() async {
    try {
      return await _storage.read(key: 'authToken');
    } catch (e) {
      print("Erreur lors de la lecture du token : $e");
      return null;
    }
  }

  static Future<http.Response> getWithAuth(String endpoint) async {
    if (mockGetWithAuth != null) {
      return mockGetWithAuth!(endpoint);
    }

    final token = await _getToken();

    // Autoriser les requêtes sans token uniquement pour /professionalType
    if (token == null && endpoint != '/professionalType') {
      throw Exception("Aucun token trouvé");
    }

    return await _httpClient.get(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }


  /// POST avec Auth
  static Future<http.Response> postWithAuth(String endpoint, Map<String, dynamic> body) async {

        if (mockPostWithAuth != null) {
      return mockPostWithAuth!(endpoint);
    }

    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return await _httpClient.post(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  /// PUT avec Auth
  static Future<http.Response> putWithAuth(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return await _httpClient.put(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  /// DELETE avec Auth
  static Future<http.Response> deleteWithAuth(String endpoint) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return await _httpClient.delete(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
