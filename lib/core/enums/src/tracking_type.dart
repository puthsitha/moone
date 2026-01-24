enum TrackingType {
  expense,
  income,
  saving;

  static TrackingType fromMap(String value) {
    return TrackingType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => TrackingType.expense,
    );
  }
}

enum GradientDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  topLeftToBottomRight,
  bottomRightToTopLeft,
}
