import 'dart:convert';
import 'package:equipro/src/utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _storage = FlutterSecureStorage();

  /// Récupère le token du secure storage
static Future<String?> _getToken() async {
  try {
    return await _storage.read(key: 'authToken');
  } catch (e) {
    print("Erreur lors de la lecture du token : $e");
    return null;
  }
}


  /// GET avec Auth
  static Future<http.Response> getWithAuth(String endpoint) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return await http.get(
      Uri.parse('${Constants.apiBaseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// POST avec Auth
  static Future<http.Response> postWithAuth(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return await http.post(
      Uri.parse('${Constants.apiBaseUrl}$endpoint'),
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

    return await http.put(
      Uri.parse('${Constants.apiBaseUrl}$endpoint'),
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

    return await http.delete(
      Uri.parse('${Constants.apiBaseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
