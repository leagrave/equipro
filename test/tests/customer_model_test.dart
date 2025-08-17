import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/models/customer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Customer Model', () {
    test('fromJson should parse all fields correctly', () {
      final json = {
        'id': '10',
        'user_id': '1',
        'phone': '0123456789',
        'phone2': '0987654321',
        'addresse_id': '100',
        'billing_address_id': '200',
        'is_societe': true,
      };

      final customer = Customer.fromJson(json);

      expect(customer.customerId, '10');
      expect(customer.userId, '1');
      expect(customer.phone, '0123456789');
      expect(customer.phone2, '0987654321');
      expect(customer.addresseId, '100');
      expect(customer.billingAddressId, '200');
      expect(customer.isSociete, true);
    });

    test('toJson should convert object to Map correctly', () {
      final customer = Customer(
        customerId: '10',
        userId: '1',
        phone: '0123456789',
        phone2: '0987654321',
        addresseId: '100',
        billingAddressId: '200',
        isSociete: true,
      );

      final json = customer.toJson();

      expect(json['id'], '10');
      expect(json['user_id'], '1');
      expect(json['phone'], '0123456789');
      expect(json['phone2'], '0987654321');
      expect(json['addresse_id'], '100');
      expect(json['billing_address_id'], '200');
      expect(json['is_societe'], true);
    });
  });

  group('CustomerProfessionnal Model', () {
    test('fromJson should parse all fields correctly', () {
      final json = {
        'customer_id': '10',
        'profesionnel_id': '1',
        'last_visit_date': '2025-08-16T12:00:00',
        'next_visit_date': '2025-09-16T12:00:00',
        'notes': 'Important client',
      };

      final link = CustomerProfessionnal.fromJson(json);

      expect(link.customerId, '10');
      expect(link.profesionnelId, '1');
      expect(link.lastVisitDate, DateTime.parse('2025-08-16T12:00:00'));
      expect(link.nextVisitDate, DateTime.parse('2025-09-16T12:00:00'));
      expect(link.notes, 'Important client');
    });

    test('toJson should convert object to Map correctly', () {
      final link = CustomerProfessionnal(
        customerId: '10',
        profesionnelId: '1',
        lastVisitDate: DateTime.parse('2025-08-16T12:00:00'),
        nextVisitDate: DateTime.parse('2025-09-16T12:00:00'),
        notes: 'Important client',
      );

      final json = link.toJson();

      expect(json['customer_id'], '10');
      expect(json['profesionnel_id'], '1');
      expect(json['last_visit_date'], '2025-08-16T12:00:00.000');
      expect(json['next_visit_date'], '2025-09-16T12:00:00.000');
      expect(json['notes'], 'Important client');
    });
  });
}
