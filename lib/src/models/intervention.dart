import 'horse.dart';
import 'user.dart';
import 'invoice.dart';
import 'observation.dart';

class Intervention {
  final String id;
  final String? description;
  final String? careObservation;

  final DateTime? interventionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<Users> users;
  final Horse? horse;
  final Users pro;

  final Invoice? invoice;

  final String? externalNotes;
  final String? incisiveNotes;
  final String? mucousNotes;
  final String? internalNotes;
  final String? otherNotes;

  final List<Observation>? externalObservations;
  final List<Observation>? incisiveObservations;
  final List<Observation>? mucousObservations;
  final List<Observation>? internalObservations;
  final List<Observation>? otherObservations;
  

  Intervention({
    required this.id,
    this.description,
    this.careObservation,
    this.interventionDate,
    this.createdAt,
    this.updatedAt,
    required this.users,
    this.horse,
    required this.pro,
    this.invoice,
    this.externalNotes,
    this.incisiveNotes,
    this.mucousNotes,
    this.internalNotes,
    this.otherNotes,
    this.externalObservations,
    this.incisiveObservations,
    this.mucousObservations,
    this.internalObservations,
    this.otherObservations,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      id: json['id'] as String,
      description: json['description'] as String?,
      careObservation: json['care_observation'] as String?,
      interventionDate: json['intervention_date'] != null
          ? DateTime.parse(json['intervention_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      users: (json['users'] as List<dynamic>)
          .map((e) => Users.fromJson(e))
          .toList(),
      horse: json['horse'] != null ? Horse.fromJson(json['horse']) : null,
      pro: Users.fromJson(json['professional']),
      invoice:
          json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
      externalNotes: json['external_notes'] as String?,
      incisiveNotes: json['incisive_notes'] as String?,
      mucousNotes: json['mucous_notes'] as String?,
      internalNotes: json['internal_notes'] as String?,
      otherNotes: json['other_notes'] as String?,
      externalObservations: (json['external_observations'] as List<dynamic>?)
          ?.map((e) => Observation.fromJson(e))
          .toList(),

      incisiveObservations: (json['incisive_observations'] as List<dynamic>?)
          ?.map((e) => Observation.fromJson(e))
          .toList(),
      mucousObservations: (json['mucous_observations'] as List<dynamic>?)
          ?.map((e) => Observation.fromJson(e))
          .toList(),
      internalObservations: (json['internal_observations'] as List<dynamic>?)
          ?.map((e) => Observation.fromJson(e))
          .toList(),
      otherObservations: (json['other_observations'] as List<dynamic>?)
          ?.map((e) => Observation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'care_observation': careObservation,
      'intervention_date': interventionDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'users': users.map((u) => u.toJson()).toList(),
      'horse': horse?.toJson(),
      'professional': pro.toJson(),
      'invoice': invoice?.toJson(),
      'external_notes': externalNotes,
      'incisive_notes': incisiveNotes,
      'mucous_notes': mucousNotes,
      'internal_notes': internalNotes,
      'other_notes': otherNotes,
      'external_observations': externalObservations,
      'incisive_observations': incisiveObservations,
      'mucous_observations': mucousObservations,
      'internal_observations': internalObservations,
      'other_observations': otherObservations,
    };
  }

  @override
  String toString() {
    return '''
Intervention(
  id: $id,
  description: $description,
  date: $interventionDate,
  horse: ${horse?.name},
  users: ${users.map((u) => u.fullName).join(', ')},
  pro: ${pro.fullName}
)''';
  }

  Intervention copyWith({
    String? id,
    String? description,
    String? careObservation,
    DateTime? interventionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Users>? users,
    Horse? horse,
    Users? pro,
    Invoice? invoice,
    String? externalNotes,
    String? incisiveNotes,
    String? mucousNotes,
    String? internalNotes,
    String? otherNotes,
    List<Observation>? externalObservations,
    List<Observation>? incisiveObservations,
    List<Observation>? mucousObservations,
    List<Observation>? internalObservations,
    List<Observation>? otherObservations,
  }) {
    return Intervention(
      id: id ?? this.id,
      description: description ?? this.description,
      careObservation: careObservation ?? this.careObservation,
      interventionDate: interventionDate ?? this.interventionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      users: users ?? this.users,
      horse: horse ?? this.horse,
      pro: pro ?? this.pro,
      invoice: invoice ?? this.invoice,
      externalNotes: externalNotes ?? this.externalNotes,
      incisiveNotes: incisiveNotes ?? this.incisiveNotes,
      mucousNotes: mucousNotes ?? this.mucousNotes,
      internalNotes: internalNotes ?? this.internalNotes,
      otherNotes: otherNotes ?? this.otherNotes,
      externalObservations: externalObservations ?? this.externalObservations,
      incisiveObservations: incisiveObservations ?? this.incisiveObservations,
      mucousObservations: mucousObservations ?? this.mucousObservations,
      internalObservations: internalObservations ?? this.internalObservations,
      otherObservations: otherObservations ?? this.otherObservations,
    );
  }
}
