import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monee/core/enums/enum.dart';

class CustomException implements Exception {
  CustomException(this.message);
  final String message; // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}

extension TrackingX on TrackingType {
  bool get isExpense => this == TrackingType.expense;
  bool get isIncome => this == TrackingType.income;
  bool get isSaving => this == TrackingType.saving;
}

extension GradientDirectionX on GradientDirection {
  Alignment get begin {
    switch (this) {
      case GradientDirection.leftToRight:
        return Alignment.centerLeft;
      case GradientDirection.rightToLeft:
        return Alignment.centerRight;
      case GradientDirection.topToBottom:
        return Alignment.topCenter;
      case GradientDirection.bottomToTop:
        return Alignment.bottomCenter;
      case GradientDirection.topLeftToBottomRight:
        return Alignment.topLeft;
      case GradientDirection.bottomRightToTopLeft:
        return Alignment.bottomRight;
    }
  }

  Alignment get end {
    switch (this) {
      case GradientDirection.leftToRight:
        return Alignment.centerRight;
      case GradientDirection.rightToLeft:
        return Alignment.centerLeft;
      case GradientDirection.topToBottom:
        return Alignment.bottomCenter;
      case GradientDirection.bottomToTop:
        return Alignment.topCenter;
      case GradientDirection.topLeftToBottomRight:
        return Alignment.bottomRight;
      case GradientDirection.bottomRightToTopLeft:
        return Alignment.topLeft;
    }
  }
}

extension DateTimeX on DateTime {
  String toMonthYear() {
    return DateFormat('MMMM yyyy').format(this);
  }
}
