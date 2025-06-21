import './user.dart';

class Customer {
  final String customerId;
  final String? userId;
  final String? phone;
  final String? phone2;
  final String? addresseId;
  final String? billingAddressId;
  final bool isSociete;

  Customer({
    required this.customerId,
    this.userId,
    this.phone,
    this.phone2,
    this.addresseId,
    this.billingAddressId,
    this.isSociete = false,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['id'],
      userId: json['user_id'],
      phone: json['phone'],
      phone2: json['phone2'],
      addresseId: json['addresse_id'],
      billingAddressId: json['billing_address_id'],
      isSociete: json['is_societe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': customerId,
      'user_id': userId,
      'phone': phone,
      'phone2': phone2,
      'addresse_id': addresseId,
      'billing_address_id': billingAddressId,
      'is_societe': isSociete,
    };
  }
}


class CustomerProfessionnal {
  final String customerId;
  final String profesionnelId;
  final DateTime? lastVisitDate;
  final DateTime? nextVisitDate;
  final String? notes;

  CustomerProfessionnal({
    required this.customerId,
    required this.profesionnelId,
    this.lastVisitDate,
    this.nextVisitDate,
    this.notes,
  });

  factory CustomerProfessionnal.fromJson(Map<String, dynamic> json) {
    return CustomerProfessionnal(
      customerId: json['customer_id'],
      profesionnelId: json['profesionnel_id'],
      lastVisitDate: json['last_visit_date'] != null ? DateTime.parse(json['last_visit_date']) : null,
      nextVisitDate: json['next_visit_date'] != null ? DateTime.parse(json['next_visit_date']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'profesionnel_id': profesionnelId,
      'last_visit_date': lastVisitDate?.toIso8601String(),
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'notes': notes,
    };
  }
}

class FullCustomer {
  final Customer customer;
  final User? user; 
  final CustomerProfessionnal? link; 

  FullCustomer({
    required this.customer,
    this.user,
    this.link,
  });
}

