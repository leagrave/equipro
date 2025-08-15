import 'adresses.dart';
import 'user.dart';
import 'horseBreed.dart';
import 'horseActivityType.dart';
import 'horseColor.dart';
import 'horseFeedType.dart';

class Horse {
  final String id;
  final String name;
  final int? age;
  final String? stableId;
  final DateTime? lastVisitDate;
  final DateTime? nextVisitDate;
  final String? notes;

  final List<Users>? users;
  final List<HorseBreed>? breeds;
  final List<HorseColor>? colors;
  final List<FeedType>? feedTypes;
  final List<ActivityType>? activityTypes;
  final List<Address>? address;


  Horse({
    required this.id,
    required this.name,
    this.age,
    this.stableId,
    this.lastVisitDate,
    this.nextVisitDate,
    this.notes,
    this.users,
    this.breeds,
    this.colors,
    this.feedTypes,
    this.activityTypes,
    this.address,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'],
      name: json['name'],
      age: json['age'] ?? 0,
      stableId: json['stable_id'] ?? null,
      lastVisitDate: json['last_visit_date'] != null ? DateTime.parse(json['last_visit_date']) : null,
      nextVisitDate: json['next_visit_date'] != null ? DateTime.parse(json['next_visit_date']) : null,
      notes: json['notes'] ?? null,
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => Users.fromJson(userJson))
          .toList(),
      breeds: (json['breeds'] as List<dynamic>?)?.map((e) => HorseBreed.fromJson(e)).toList() ,
      colors: (json['colors'] as List<dynamic>?)?.map((e) => HorseColor.fromJson(e)).toList(),
      feedTypes: (json['feed_types'] as List<dynamic>?)?.map((e) => FeedType.fromJson(e)).toList() ,
      activityTypes: (json['activity_types'] as List<dynamic>?)?.map((e) => ActivityType.fromJson(e)).toList(),
      address: (json['address'] as List<dynamic>?)?.map((addrJson) => Address.fromJson(addrJson)).toList(),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'stable_id': stableId,
      'last_visit_date': lastVisitDate?.toIso8601String(),
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'notes': notes,
      'users': users?.map((e) => e.toJson()).toList(),
      'breeds': breeds?.map((e) => e.toJson()).toList(),
      'colors': colors?.map((e) => e.toJson()).toList(),
      'feed_types': feedTypes?.map((e) => e.toJson()).toList(),
      'activity_types': activityTypes?.map((e) => e.toJson()).toList(),
      'address': address?.map((a) => a.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '''
  Horse(
    id: $id,
    name: $name,
    age: $age,
    stableId: $stableId,
    lastVisitDate: $lastVisitDate,
    nextVisitDate: $nextVisitDate,
    notes: $notes,
    users: ${users?.map((u) => '${u.firstName} ${u.lastName}').join(', ')},
    breeds: ${breeds?.map((b) => b.label).join(', ')},
    colors: ${colors?.map((c) => c.label).join(', ')},
    feedTypes: ${feedTypes?.map((f) => f.label).join(', ')},
    activityTypes: ${activityTypes?.map((a) => a.label).join(', ')},
    address: ${address?.map((a) => '${a.address}, ${a.city}').join(' | ')}
  )''';
}


  Horse copyWith({
    String? id,
    String? name,
    int? age,
    String? addresseId,
    String? stableId,
    DateTime? lastVisitDate,
    DateTime? nextVisitDate,
    String? notes,
    List<Users>? users,
    List<HorseBreed>? breeds,
    List<HorseColor>? colors,
    List<FeedType>? feedTypes,
    List<ActivityType>? activityTypes,
    List<Address>? address,
  }) {
    return Horse(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      stableId: stableId ?? this.stableId,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      nextVisitDate: nextVisitDate ?? this.nextVisitDate,
      notes: notes ?? this.notes,
      users: users ?? this.users,
      breeds: breeds ?? this.breeds,
      colors: colors ?? this.colors,
      feedTypes: feedTypes ?? this.feedTypes,
      activityTypes: activityTypes ?? this.activityTypes,
      address: address ?? this.address,
    );
  }
}
