import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/services/apiService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class MockStorage extends FlutterSecureStorage {
  final Map<String, String> _data = {};
  @override
  Future<String?> read({required String key, IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    return _data[key];
  }

  @override
  Future<void> write({required String key, required String? value, IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }
}

class MockHttpClient extends http.BaseClient {
  http.Response? response;
  Uri? lastUri;
  Map<String, String>? lastHeaders;
  String? lastBody;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastUri = request.url;
    lastHeaders = request.headers;
    if (request is http.Request) {
      lastBody = request.body;
    }
    final resp = response ?? http.Response('{}', 200);
    return http.StreamedResponse(
      Stream.value(utf8.encode(resp.body)),
      resp.statusCode,
      headers: resp.headers,
    );
  }
}

void main() {
  group('ApiService', () {
    late MockStorage mockStorage;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockStorage = MockStorage();
      mockHttpClient = MockHttpClient();
      ApiService.overrideDependencies(
        storage: mockStorage,
        httpClient: mockHttpClient,
        baseUrl: 'https://fakeapi.com/',
      );
    });

    test('getWithAuth throws if no token except /professionalType', () async {
      await expectLater(
        () => ApiService.getWithAuth('/other'),
        throwsException,
      );
      // /professionalType doit passer même sans token
      final response = await ApiService.getWithAuth('/professionalType');
      expect(response.statusCode, 200);
    });

    test('getWithAuth returns response with token', () async {
      await mockStorage.write(key: 'authToken', value: 'abc123');
      mockHttpClient.response = http.Response('{"ok":true}', 200);
      final response = await ApiService.getWithAuth('/test');
      expect(response.statusCode, 200);
      expect(mockHttpClient.lastHeaders?['Authorization'], 'Bearer abc123');
    });

    test('postWithAuth returns response with token', () async {
      await mockStorage.write(key: 'authToken', value: 'abc123');
      mockHttpClient.response = http.Response('{"ok":true}', 201);
      final response = await ApiService.postWithAuth('/test', {'foo': 'bar'});
      expect(response.statusCode, 201);
    });

    test('postWithAuth throws if no token', () async {
      await expectLater(
        () => ApiService.postWithAuth('/test', {'foo': 'bar'}),
        throwsException,
      );
    });

    test('putWithAuth returns response with token', () async {
      await mockStorage.write(key: 'authToken', value: 'abc123');
      mockHttpClient.response = http.Response('{"ok":true}', 200);
      final response = await ApiService.putWithAuth('/test', {'foo': 'bar'});
      expect(response.statusCode, 200);
    });

    test('deleteWithAuth returns response with token', () async {
      await mockStorage.write(key: 'authToken', value: 'abc123');
      mockHttpClient.response = http.Response('{"ok":true}', 204);
      final response = await ApiService.deleteWithAuth('/test');
      expect(response.statusCode, 204);
    });
  });
}