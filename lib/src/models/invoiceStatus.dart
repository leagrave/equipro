class InvoiceStatus {
  final String id;
  final String invoiceStatusName;

  InvoiceStatus({
    required this.id,
    required this.invoiceStatusName,
  });

  factory InvoiceStatus.fromJson(Map<String, dynamic> json) {
    return InvoiceStatus(
      id: json['id'] as String,
      invoiceStatusName: json['invoice_status_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_status_name': invoiceStatusName,
    };
  }
}
