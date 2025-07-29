class HorseColor {
  final String id;
  final String label;

  HorseColor({required this.id, required this.label});

  factory HorseColor.fromJson(Map<String, dynamic> json) {
    return HorseColor(
      id: json['id'].toString(),
      label: json['color_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
