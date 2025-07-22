class Invoice {
  final int idInvoice;
  final int idClient;
  final int idHorse;
  final bool isSociete;
  final String addressFacturation;
  final DateTime dateCreation;
  final DateTime? dateEcheance;
  final DateTime? dateModification;
  final String etat;
  final bool paye;
  final double montant;

  Invoice({
    required this.idInvoice,
    required this.idClient,
    required this.idHorse,
    required this.etat,
    required this.paye,
    required this.montant,
    required this.isSociete,
    required this.dateCreation,
    required this.addressFacturation,
    this.dateModification,
    this.dateEcheance
  });
}
