class Client {
  final int idClient;
  final String nom;
  final String prenom;
  final String tel;
  final String mobile;
  final String email;
  final String ville;
  final String? societe; 
  final String? civilite;
  final bool? isSociete;
  final DateTime? derniereVisite;
  final DateTime? prochaineIntervention;
  final String? adresse;
  final String? adresseFacturation;
  final String? region;
  final String? notes;
  final List<String>? adresses; 

  Client({
    required this.idClient,
    required this.nom,
    required this.prenom,
    required this.tel,
    required this.mobile,
    required this.email,
    required this.ville,
    this.societe, 
    this.civilite,
    this.isSociete,
    this.derniereVisite,
    this.prochaineIntervention,
    this.adresse,
    this.adresseFacturation,
    this.region, 
    this.notes,
    this.adresses,
  });
}
