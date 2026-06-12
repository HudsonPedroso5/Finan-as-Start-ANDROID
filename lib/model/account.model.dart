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
}
