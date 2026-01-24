import 'dart:convert';

import 'package:monee/core/models/category_model.dart';

class BudgetModel {
  BudgetModel({
    this.id = '',
    this.budget = 0,
    this.category = const CategoryModel(),
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      budget: map['budget'] as num,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
    );
  }

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String id;
  final num budget;
  final CategoryModel category;

  BudgetModel copyWith({
    String? id,
    num? expense,
    num? budget,
    CategoryModel? category,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      budget: budget ?? this.budget,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'budget': budget,
      'category': category.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
