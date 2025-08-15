
import 'package:equipro/src/utils/constants.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mock pour FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock pour UserCredential
class MockUserCredential extends Mock implements UserCredential {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockHttpClient extends Mock implements http.Client {}

// Mock HTTP client
class MockApiAuth {
  // méthode simulant la vérification login
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Valeurs "valides" simulées
    if (email == 'test@test.com' && password == 'testDutestOK') {
      return {
        'token': 'fake_token',
        'user': {
          'id': 1,
          'first_name': 'Test',
          'last_name': 'User',
          'pro_id': 123,
        }
      };
    } else {
      // simuler erreur
      throw Exception('Identifiants incorrects');
    }
  }
}

class UserService {
  final http.Client client;

  UserService({required this.client});

  Future<bool> createUser(Map<String, dynamic> userData) async {
    final response = await client.post(
      Uri.parse('https://api.exemple.com/users'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}


class MockApiService {
  static FlutterSecureStorage _storage = const FlutterSecureStorage();
  static http.Client _client = http.Client();

  // Nouvelle variable statique pour la base URL (avec valeur par défaut)
  static String _baseUrl = Constants.apiBaseUrl;

  /// Permet d'injecter des dépendances mockées depuis les tests
  static void overrideDependencies({
    FlutterSecureStorage? storage,
    http.Client? httpClient,
    String? baseUrl,  // ajout de baseUrl injectable
  }) {
    if (storage != null) _storage = storage;
    if (httpClient != null) _client = httpClient;
    if (baseUrl != null) _baseUrl = baseUrl;
  }

  static void resetDependencies() {
    _storage = const FlutterSecureStorage();
    _client = http.Client();
    _baseUrl = Constants.apiBaseUrl;
  }

  static Future<String?> _getToken() async {
    try {
      return await _storage.read(key: 'authToken');
    } catch (_) {
      return null;
    }
  }

  static Future<http.Response> getWithAuth(String endpoint) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return _client.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> postWithAuth(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    if (token == null) throw Exception("Aucun token trouvé");

    return _client.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}