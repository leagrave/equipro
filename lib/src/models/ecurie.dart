class Ecurie {
  final int idEcurie;
  final int idHorse;
  final String name;
  final int ownerId;
  final String? adresse;

  Ecurie({
    required this.idEcurie,
    required this.idHorse,
    required this.name,
    required this.ownerId,
    this.adresse,
  });
}
