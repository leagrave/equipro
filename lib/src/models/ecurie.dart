class Ecurie {
  final String id;
  final String name;
  final String user_id;
  final String? addressId;
  final String? phone;
  final String? phone2;

  Ecurie({
    required this.id,
    required this.name,
    required this.user_id,
    this.addressId,
    this.phone,
    this.phone2,
  });

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ecurie &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Ecurie.fromJson(Map<String, dynamic> json) {
    return Ecurie(
      id: json['id'] as String,
      name: json['name'] as String,
      user_id: json['user_id'] as String,
      addressId: json['address_id'] as String?,
      phone: json['phone'] as String?,
      phone2: json['phone2'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': user_id,
      'addressId': addressId,
      'phone': phone,
      'phone2': phone2,
    };
  }

  Ecurie copyWith({
    String? id,
    String? name,
    String? user_id,
    String? addressId,
    String? phone,
    String? phone2,
  }) {
    return Ecurie(
      id: id ?? this.id,
      name: name ?? this.name,
      user_id: user_id ?? this.user_id,
      addressId: addressId ?? this.addressId,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
    );
  }
}
