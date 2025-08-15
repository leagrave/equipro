class Event {
  final int idEvent;
  final int idClient;
  final int? idHorse;
  final int? idEcurie;
  final String eventName;
  final String addressEcurie;
  final DateTime dateDebut;
  final DateTime dateFin;
  final DateTime heureDebut;
  final DateTime heureFin;
  final String? notes;

  Event({
    required this.idEvent,
    required this.idClient,
    required this.eventName,
    required this.addressEcurie,
    required this.dateDebut,
    required this.dateFin,
    required this.heureDebut,
    required this.heureFin,
    this.idEcurie,
    this.idHorse,
    this.notes,
  });

}

