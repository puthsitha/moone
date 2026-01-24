import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';

class CategoryModel {
  const CategoryModel({
    this.id = '',
    this.type = TrackingType.expense,
    this.titleEn = '',
    this.titleKm = '',
    this.color = const LinearGradient(colors: []),
    this.icon = '',
    this.gradientDirection = GradientDirection.leftToRight,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    final direction = GradientDirection.values.firstWhere(
      (e) => e.name == (map['gradientDirection'] ?? 'leftToRight'),
      orElse: () => GradientDirection.leftToRight,
    );

    return CategoryModel(
      id: map['id'] as String,
      type: TrackingType.fromMap(map['type'] as String),
      titleEn: map['titleEn'] as String,
      titleKm: map['titleKm'] as String,
      icon: map['icon'] as String,
      gradientDirection: direction,
      color: LinearGradient(
        begin: direction.begin,
        end: direction.end,
        colors: (map['color'] as List<dynamic>)
            .map((c) => Color(c as int))
            .toList(),
      ),
    );
  }

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String categoryTitle(String lang) {
    return lang == 'km'
        ? (titleKm.isNotEmpty ? titleKm : titleEn)
        : (titleEn.isNotEmpty ? titleEn : titleKm);
  }

  final String id;
  final TrackingType type;
  final String titleEn;
  final String titleKm;
  final LinearGradient color;
  final String icon;
  final GradientDirection gradientDirection;

  CategoryModel copyWith({
    String? id,
    TrackingType? type,
    String? titleEn,
    String? titleKm,
    LinearGradient? color,
    String? icon,
    GradientDirection? gradientDirection,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      titleEn: titleEn ?? this.titleEn,
      titleKm: titleKm ?? this.titleKm,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      gradientDirection: gradientDirection ?? this.gradientDirection,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'titleEn': titleEn,
      'titleKm': titleKm,
      'icon': icon,
      'gradientDirection': gradientDirection.name,
      'color': color.colors.map((c) => c.toARGB32()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
