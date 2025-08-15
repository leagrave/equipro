class ProfessionalType {
  final String idProfessional;
  final String nameProfessional; 

  const ProfessionalType({
    required this.idProfessional,
    required this.nameProfessional,
  });

  factory ProfessionalType.fromJson(Map<String, dynamic> json) {
    return ProfessionalType(
      idProfessional: json['id'].toString(),
      nameProfessional: json['professional_type_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProfessional': idProfessional,
      'nameProfessional': nameProfessional,
    };
  }

    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfessionalType && other.idProfessional == idProfessional;
  }

  @override
  int get hashCode => idProfessional.hashCode;
}
