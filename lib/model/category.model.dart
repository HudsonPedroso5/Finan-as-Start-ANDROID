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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'budget': budget,
      'expense': expense,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      iconCodePoint: (json['iconCodePoint'] as num).toInt(),
      colorValue: (json['colorValue'] as num).toInt(),
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      expense: (json['expense'] as num?)?.toDouble() ?? 0,
    );
  }
}
