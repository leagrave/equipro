class Horse {
  final int id;
  final int idClient;
  final String name;
  final int ownerId;
  final String? adresse;
  final int age;
  final String race;
  final DateTime? lastAppointmentDate; 
  final String? color;
  final String? feedingType;
  final String? activityType;
  final String? notes;


  Horse({
    required this.id,
    required this.idClient,
    required this.name,
    required this.ownerId,
    this.adresse,
    required this.age,
    required this.race,
    this.lastAppointmentDate, 
    this.color,
    this.feedingType,
    this.activityType,
    this.notes,
  });
}
