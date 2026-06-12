import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final int iconCodePoint;
  final int colorValue;
  final double budget;
  final double expense;

  const Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    this.budget = 0,
    this.expense = 0,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  Category copyWith({
    int? id,
    String? name,
    int? iconCodePoint,
    int? colorValue,
    double? budget,
    double? expense,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      budget: budget ?? this.budget,
      expense: expense ?? this.expense,
    );
  }
}
