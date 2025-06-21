class Horse {
  final String id;
  final String name;
  final int age;
  final String? breedId;
  final String? stableId;
  final String? feedTypeId;
  final String? colorId;
  final String? activityTypeId;
  final String? addresseId;
  final DateTime? lastVisitDate;
  final DateTime? nextVisitDate;
  final String? notes;

  Horse({
    required this.id,
    required this.name,
    required this.age,
    this.breedId,
    this.stableId,
    this.feedTypeId,
    this.colorId,
    this.activityTypeId,
    this.addresseId,
    this.lastVisitDate,
    this.nextVisitDate,
    this.notes,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      breedId: json['breed_id'],
      stableId: json['stable_id'],
      feedTypeId: json['feed_type_id'],
      colorId: json['color_id'],
      activityTypeId: json['activity_type_id'],
      addresseId: json['addresse_id'],
      lastVisitDate: json['last_visit_date'] != null ? DateTime.parse(json['last_visit_date']) : null,
      nextVisitDate: json['next_visit_date'] != null ? DateTime.parse(json['next_visit_date']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'breed_id': breedId,
      'stable_id': stableId,
      'feed_type_id': feedTypeId,
      'color_id': colorId,
      'activity_type_id': activityTypeId,
      'addresse_id': addresseId,
      'last_visit_date': lastVisitDate?.toIso8601String(),
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'notes': notes,
    };
  }
}
