class ActivityType {
  final String id;
  final String label;

  ActivityType({required this.id, required this.label});

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'].toString(),
      label: json['activity_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
