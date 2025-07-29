class HorseBreed {
  final String id;
  final String label;

  HorseBreed({required this.id, required this.label});

  factory HorseBreed.fromJson(Map<String, dynamic> json) {
    return HorseBreed(
      id: json['id'].toString(),
      label: json['breed_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
