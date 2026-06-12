import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';

enum PaymentType { debit, credit }

class Payment {
  final int id;
  final int accountId;
  final int categoryId;
  final double amount;
  final PaymentType type;
  final DateTime datetime;
  final String title;
  final String description;

  const Payment({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.datetime,
    required this.title,
    required this.description,
  });

  Payment copyWith({
    int? id,
    int? accountId,
    int? categoryId,
    double? amount,
    PaymentType? type,
    DateTime? datetime,
    String? title,
    String? description,
  }) {
    return Payment(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      datetime: datetime ?? this.datetime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'categoryId': categoryId,
      'amount': amount,
      'type': type.name,
      'datetime': datetime.toIso8601String(),
      'title': title,
      'description': description,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: (json['id'] as num).toInt(),
      accountId: (json['accountId'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'credit' ? PaymentType.credit : PaymentType.debit,
      datetime: DateTime.parse(json['datetime'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}

class PaymentView {
  final Payment payment;
  final Account account;
  final Category category;

  const PaymentView({
    required this.payment,
    required this.account,
    required this.category,
  });
}
