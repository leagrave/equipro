

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool professional;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.professional,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      professional: json['professional'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'professional': professional,
    };
  }

  String get fullName => '$firstName $lastName';
}



class HorseUser {
  final String horseId;
  final String userId;

  HorseUser({
    required this.horseId,
    required this.userId,
  });

  factory HorseUser.fromJson(Map<String, dynamic> json) {
    return HorseUser(
      horseId: json['horse_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horse_id': horseId,
      'user_id': userId,
    };
  }
}
