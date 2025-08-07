class PaymentType {
  final String id;
  final String paymentTypeName;

  PaymentType({
    required this.id,
    required this.paymentTypeName,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json['id'] as String,
      paymentTypeName: json['payment_type_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_type_name': paymentTypeName,
    };
  }
}
