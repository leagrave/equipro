class FeedType {
  final String id;
  final String label;

  FeedType({required this.id, required this.label});

  factory FeedType.fromJson(Map<String, dynamic> json) {
    return FeedType(
      id: json['id'].toString(),
      label: json['feed_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}
