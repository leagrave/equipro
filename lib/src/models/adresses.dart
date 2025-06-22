class Address {
  final String id;
  final String adresse;
  final String city;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;

  Address({
    required this.id,
    required this.adresse,
    required this.city,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      adresse: json['adresse'],
      city: json['city'],
      postalCode: json['postal_code'],
      country: json['country'] ?? 'France',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude']) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude']) : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adresse': adresse,
      'postalCode': postalCode,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return '$adresse, $postalCode $city, $country';
  }
}