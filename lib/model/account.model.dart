import 'package:flutter/material.dart';

class Account {
  final int id;
  final String name;
  final String holderName;
  final String accountNumber;
  final int iconCodePoint;
  final int colorValue;
  final bool isDefault;
  final double income;
  final double expense;
  final double balance;

  const Account({
    required this.id,
    required this.name,
    required this.holderName,
    required this.accountNumber,
    required this.iconCodePoint,
    required this.colorValue,
    this.isDefault = false,
    this.income = 0,
    this.expense = 0,
    this.balance = 0,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  Account copyWith({
    int? id,
    String? name,
    String? holderName,
    String? accountNumber,
    int? iconCodePoint,
    int? colorValue,
    bool? isDefault,
    double? income,
    double? expense,
    double? balance,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      holderName: holderName ?? this.holderName,
      accountNumber: accountNumber ?? this.accountNumber,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'holderName': holderName,
      'accountNumber': accountNumber,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'isDefault': isDefault,
      'income': income,
      'expense': expense,
      'balance': balance,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      holderName: json['holderName'] as String,
      accountNumber: json['accountNumber'] as String,
      iconCodePoint: (json['iconCodePoint'] as num).toInt(),
      colorValue: (json['colorValue'] as num).toInt(),
      isDefault: json['isDefault'] as bool? ?? false,
      income: (json['income'] as num?)?.toDouble() ?? 0,
      expense: (json['expense'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
    );
  }
}
