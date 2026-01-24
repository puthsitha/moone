import 'package:flutter/material.dart';
import 'package:monee/core/enums/enum.dart';

GradientDirection gradientDirectionFromLinearGradient(
  LinearGradient gradient,
) {
  final begin = gradient.begin;
  final end = gradient.end;

  if (begin == Alignment.centerLeft && end == Alignment.centerRight) {
    return GradientDirection.leftToRight;
  }

  if (begin == Alignment.centerRight && end == Alignment.centerLeft) {
    return GradientDirection.rightToLeft;
  }

  if (begin == Alignment.topCenter && end == Alignment.bottomCenter) {
    return GradientDirection.topToBottom;
  }

  if (begin == Alignment.bottomCenter && end == Alignment.topCenter) {
    return GradientDirection.bottomToTop;
  }

  if (begin == Alignment.topLeft && end == Alignment.bottomRight) {
    return GradientDirection.topLeftToBottomRight;
  }

  if (begin == Alignment.bottomRight && end == Alignment.topLeft) {
    return GradientDirection.bottomRightToTopLeft;
  }

  // ✅ Safe fallback
  return GradientDirection.leftToRight;
}
