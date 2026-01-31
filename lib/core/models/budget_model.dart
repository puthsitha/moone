import 'dart:convert';

import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/category_model.dart';

class BudgetModel {
  BudgetModel({
    this.id = '',
    this.budget = 0,
    this.category = const CategoryModel(),
    this.currency = CurrencyType.usd,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      budget: map['budget'] as num,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      currency: CurrencyType.fromMap(map['currency'] as String),
    );
  }

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String id;
  final num budget;
  final CategoryModel category;
  final CurrencyType currency;

  BudgetModel copyWith({
    String? id,
    num? expense,
    num? budget,
    CategoryModel? category,
    CurrencyType? currency,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      budget: budget ?? this.budget,
      category: category ?? this.category,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'budget': budget,
      'category': category.toMap(),
      'currency': currency.name,
    };
  }

  String toJson() => json.encode(toMap());
}
