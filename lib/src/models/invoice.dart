
import 'adresses.dart';
import 'intervention.dart';

class Invoice {
  final String id;
  final String number;
  final String title;
  final double totalAmount;

  final DateTime? issueDate;
  final DateTime? dueDate;
  final bool? isPaid;
  final bool? isCompany;

  final String user_id;
  final String? horse_id;
  final String pro_id;
  
  final String? paymentType;
  final String? status;
  final Address? billingAddress;

  final Intervention? intervention;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Invoice({
    required this.id,
    required this.number,
    required this.title,
    required this.totalAmount,
    this.issueDate,
    this.dueDate,
    this.isPaid,
    this.isCompany,
    required this.user_id,
    this.horse_id,
    required this.pro_id,
    this.paymentType,
    this.status,
    this.billingAddress,
    this.intervention,
    this.createdAt,
    this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      number: json['number'] ?? '',
      title: json['title'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      issueDate: json['issue_date'] != null ? DateTime.parse(json['issue_date']) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      isPaid: json['is_paid'],
      isCompany: json['is_company'],
      user_id: json['user_id'] ?? '',
      horse_id: json['horse_id'],
      pro_id: json['professional_id'] ?? '',
      paymentType: json['payment_type'],
      status: json['status'],
      billingAddress: json['billing_address'] != null ? Address.fromJson(json['billing_address']) : null,
      intervention: json['intervention'] != null ? Intervention.fromJson(json['intervention']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'total_amount': totalAmount,
      'issue_date': issueDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'is_paid': isPaid,
      'is_company': isCompany,
      'user_id': user_id,
      'horse_id': horse_id,
      'pro_id': pro_id,
      'payment_type': paymentType,
      'status': status,
      'billing_address': billingAddress?.toJson(),
      'intervention': intervention?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Invoice copyWith({
    String? id,
    String? number,
    String? title,
    double? totalAmount,
    DateTime? issueDate,
    DateTime? dueDate,
    bool? isPaid,
    bool? isCompany,
    String? user_id,
    String? horse_id,
    String? pro_id,
    String? paymentType,
    String? status,
    Address? billingAddress,
    Intervention? interventions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      isCompany: isCompany ?? this.isCompany,
      user_id: user_id ?? this.user_id,
      horse_id: horse_id ?? this.horse_id,
      pro_id: pro_id ?? this.pro_id,
      paymentType: paymentType ?? this.paymentType,
      status: status ?? this.status,
      billingAddress: billingAddress ?? this.billingAddress,
      intervention: interventions ?? this.intervention,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


