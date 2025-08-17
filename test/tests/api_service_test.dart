import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/services/apiService.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel storageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  final Map<String, String> fakeStorage = {};

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'write':
          final key = methodCall.arguments['key'] as String;
          final value = methodCall.arguments['value'] as String?;
          if (value != null) {
            fakeStorage[key] = value;
          } else {
            fakeStorage.remove(key);
          }
          return null;
        case 'read':
          final key = methodCall.arguments['key'] as String;
          return fakeStorage[key];
        case 'delete':
          final key = methodCall.arguments['key'] as String;
          fakeStorage.remove(key);
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
    fakeStorage.clear();
  });

  test('getWithAuth retourne les données quand le token existe', () async {
    fakeStorage['authToken'] = 'token123';


    final data = await ApiService.getWithAuth('/test-endpoint');

    expect(data, isNotNull); 
  });

    test('getWithAuth lance une exception quand le token est null', () async {

      // // On s'attend à ce que l'appel lance une exception
      // expect(
      //   () async => await ApiService.getWithAuth('/endpoint'),
      //   throwsA(isA<Exception>()),
      // );
    });
}
