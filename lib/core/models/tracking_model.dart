import 'dart:convert';

import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/models/category_model.dart';

class TrackingModel {
  const TrackingModel({
    this.id = '',
    this.type = TrackingType.expense,
    this.title = '',
    this.description = '',
    this.amount = 0,
    this.savingAmount = 0,
    this.date = '',
    this.endDate,
    this.category = const CategoryModel(),
    this.currency = CurrencyType.usd,
  });

  factory TrackingModel.fromMap(Map<String, dynamic> map) {
    return TrackingModel(
      id: map['id'] as String,
      type: TrackingType.fromMap(map['type'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
      amount: map['amount'] as num,
      savingAmount: map['savingAmount'] as num,
      date: map['date'] as String,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      currency: CurrencyType.fromMap(map['currency'] as String),
    );
  }

  factory TrackingModel.fromJson(String source) {
    return TrackingModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  final String id;
  final TrackingType type;
  final String title;
  final String description;
  final num amount;
  final num savingAmount;
  final String date;
  final String? endDate;
  final CategoryModel category;
  final CurrencyType currency;

  TrackingModel copyWith({
    String? id,
    TrackingType? type,
    String? title,
    String? description,
    num? amount,
    num? savingAmount,
    String? date,
    String? endDate,
    CategoryModel? category,
    CurrencyType? currency,
  }) {
    return TrackingModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      savingAmount: savingAmount ?? this.savingAmount,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'amount': amount,
      'savingAmount': savingAmount,
      'date': date,
      'endDate': endDate,
      'category': category.toMap(),
      'currency': currency.name,
    };
  }

  String toJson() => json.encode(toMap());
}
