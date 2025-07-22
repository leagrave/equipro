import 'package:cloud_firestore/cloud_firestore.dart';

import 'adresses.dart';
import 'horse.dart';
import 'professionalType.dart';
class Users {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool professional;

  final String? password;
  final ProfessionalType? typeProfessional;

  final bool? isSociete;
  final String? societeName;

  final bool? isVerified;
  final String? siretNumber;

  final String? phone;
  final String? phone2;

  final DateTime? lastVisitDate;
  final DateTime? nextVisitDate;
  final String? notes;

  final List<Address>? addresses;
  final List<Horse>? horses;

  const Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.professional,
    this.password,
    this.typeProfessional,
    this.isSociete,
    this.isVerified,
    this.siretNumber,
    this.societeName,
    this.phone,
    this.phone2,
    this.lastVisitDate,
    this.nextVisitDate,
    this.notes,
    this.addresses,
    this.horses = const [],
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'].toString(),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      professional: json['professional'] ?? false,
      password: json['password'] ?? '',
      typeProfessional: json['professional_type_name'] != null
          ? ProfessionalType(
              idProfessional: json['professional_type_id'],
              nameProfessional: json['professional_type_name'],
            )
          : null,
      isSociete: json['is_societe'] ?? false,
      isVerified: json['is_verified'] ?? false,
      societeName: json['societe_name'] ?? '',
      siretNumber: json['siret_number'] ?? '',
      phone: (json['phone'] as String?)?.isNotEmpty == true ? json['phone'] : null,
      phone2: (json['phone2'] as String?)?.isNotEmpty == true ? json['phone2'] : null,
      lastVisitDate: json['last_visit_date'] != null
          ? DateTime.tryParse(json['last_visit_date'].toString())
          : null,
      nextVisitDate: json['next_visit_date'] != null
          ? DateTime.tryParse(json['next_visit_date'].toString())
          : null,
      notes: json['notes'] ?? '',
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
              .map((addrJson) => Address.fromJson(addrJson))
              .toList()
          : [],
      horses: (json['horses'] as List<dynamic>? ?? [])
          .map((horseJson) => Horse.fromJson(horseJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'professional': professional,
      'password': password,
      'typeProfessional': typeProfessional?.toJson(),
      'isSociete': isSociete,
      'isVerified': isVerified,
      'societeName': societeName,
      'siretNumber': siretNumber,
      'phone': phone,
      'phone2': phone2,
      'lastVisitDate': lastVisitDate,
      'nextVisitDate': nextVisitDate,
      'notes': notes,
      'addresses': addresses?.map((a) => a.toJson()).toList(),
      'horses': horses?.map((e) => e.toJson()).toList(),
    };
  }

  Users copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? professional,
    String? password,
    ProfessionalType? typeProfessional,
    bool? isSociete,
    bool? isverified,
    String? societeName,
    String? sirenNumber,
    String? phone,
    String? phone2,
    DateTime? lastVisitDate,
    DateTime? nextVisitDate,
    String? notes,
    List<Address>? addresses,
    List<Horse>? horses,
  }) {
    return Users(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      professional: professional ?? this.professional,
      password: password ?? this.password,
      typeProfessional: typeProfessional ?? this.typeProfessional,
      isSociete: isSociete ?? this.isSociete,
      isVerified: isVerified ?? this.isVerified,
      societeName: societeName ?? this.societeName,
      siretNumber: siretNumber ?? this.siretNumber,
      phone: phone ?? this.phone,
      phone2: phone2 ?? this.phone2,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      nextVisitDate: nextVisitDate ?? this.nextVisitDate,
      notes: notes ?? this.notes,
      addresses: addresses ?? this.addresses,
      horses: horses ?? this.horses,
    );
  }

  String get fullName => '$firstName $lastName';
}
