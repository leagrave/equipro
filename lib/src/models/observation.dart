class Observation {
  final String id;
  final String observationName;

  Observation({
    required this.id,
    required this.observationName,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'] as String,
      observationName: json['observation_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'observation_name': observationName,
    };
  }
}
