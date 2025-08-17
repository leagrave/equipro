import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/models/user.dart';

void main() {
  group('Users Model', () {
    test('fromJson should parse all fields correctly', () {
      final json = {
        'id': '10',
        'user_id': '1',
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'professional': true,
        'phone': '0123456789',
        'last_visit_date': '2025-08-16T12:00:00',
        'addresses': [
          {
            'id': '100',
            'address': '123 Main St',
            'city': 'Paris',
            'postal_code': '75001',
            'country': 'France',
          }
        ],
      };

      final user = Users.fromJson(json);

      expect(user.id, '1');
      expect(user.customer_id, '10');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john@example.com');
      expect(user.professional, true);
      expect(user.phone, '0123456789');
      expect(user.lastVisitDate, DateTime.parse('2025-08-16T12:00:00'));

      // Test des adresses
      expect(user.addresses!.length, 1);
      final address = user.addresses!.first;
      expect(address.idAddress, '100');
      expect(address.address, '123 Main St');
      expect(address.city, 'Paris');
      expect(address.postalCode, '75001');
      expect(address.country, 'France');
      expect(address.latitude, null);
      expect(address.longitude, null);
      expect(address.user_id, null);
      expect(address.horse_id, null);
      expect(address.type, '');
    });
  });
}
