class Ecurie {
  final int idEcurie;
  final String name;
  final int ownerId;
  final String? address;

  Ecurie({
    required this.idEcurie,
    required this.name,
    required this.ownerId,
    this.address,
  });
}
