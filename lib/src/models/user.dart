import 'adresses.dart'; 

class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool professional;

  final String? phone;
  final String? phone2;
  final String? address;
  final String? postalCode;
  final String? city;
  final String? country;
  final double? longitude;
  final double? latitude;

  final List<Address>? addresses;

  const Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.professional,
    this.phone,
    this.phone2,
    this.address,
    this.postalCode,
    this.city,
    this.country,
    this.longitude,
    this.latitude,
    this.addresses,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    final phone = json['professional_phone'] as String? ?? json['customer_phone'] as String?;
    final phone2 = json['professional_phone2'] as String? ?? json['customer_phone2'] as String?;

    return Users(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      professional: json['professional'] ?? false,
      phone: (phone != null && phone.isNotEmpty) ? phone : null,
      phone2: (phone2 != null && phone2.isNotEmpty) ? phone2 : null,
      address: json['adresse'],
      postalCode: json['postal_code'],
      city: json['city'],
      country: json['country'],
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
              .map((addrJson) => Address.fromJson(addrJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'professional': professional,
      'phone': phone,
      'phone2': phone2,
      'adresse': address,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'addresses': addresses?.map((a) => a.toJson()).toList(),
    };
  }

  Users copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? professional,
    String? phone,
    String? phone2,
    String? address,
    String? postalCode,
    String? city,
    String? country,
    double? longitude,
    double? latitude,
    List<Address>? addresses,
  }) {
    return Users(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      professional: professional ?? this.professional,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      addresses: addresses ?? this.addresses,
    );
  }

  String get fullName => '$firstName $lastName';
}
