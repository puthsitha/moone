import 'package:flutter/material.dart';
import 'package:monee/core/theme/colors.dart';

extension BuildContextExt on BuildContext {
  AppColorScheme get colors {
    return Theme.of(this).extension<AppColorScheme>()!;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }
}
