class Address {
  final String idAddress;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final String? user_id;
  final String? horse_id;
  final String? type; // "main", "billing", etc.

  Address({
    required this.idAddress,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
    this.user_id,
    this.horse_id,
    this.type,
  });

    /// Constructeur nommé pour créer une adresse vide
  static Address empty() {
    return Address(
      idAddress: '',
      address: '',
      city: '',
      postalCode: '',
      country: '',
      latitude: null,
      longitude: null,
      user_id: null,
      horse_id: null,
      type: null,
    );
  }


  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      idAddress: json['id'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      user_id: json['user_id'] ?? null,
      horse_id: json['horse_id'] ?? null,
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idAddress,
      'address': address,
      'postalCode': postalCode,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'user_id' : user_id,
      'horse_id': horse_id,
      'type': type,
    };
  }

  Address copyWith({
    String? idAddress,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? user_id,
    String? horse_id,
    String? type,
  }) {
    return Address(
      idAddress: idAddress ?? this.idAddress,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      user_id: user_id ?? this.user_id,
      horse_id: horse_id ?? this.horse_id,
      type: type ?? this.type,
    );
  }



  @override
  String toString() {
    return '$idAddress, $address, $postalCode, $city, $country';
  }
}
