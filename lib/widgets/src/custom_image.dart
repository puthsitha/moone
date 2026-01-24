import 'package:flutter/material.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/theme/spacing.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    required this.color,
    required this.icon,
    super.key,
  });

  final LinearGradient? color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(Spacing.s),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: color,
        color: context.colors.lightShadeGrey10,
        boxShadow: [
          BoxShadow(
            color: color != null
                ? color!.colors.last.withValues(alpha: 0.3)
                : context.colors.lightShadeGrey40.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 3),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
