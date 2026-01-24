import 'package:flutter/material.dart';
import 'package:monee/core/enums/enum.dart';
import 'package:monee/core/extensions/extension.dart';
import 'package:monee/core/theme/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.child,
    this.type = ButtonType.defaultBtn,
    super.key,
    this.onPress,
  });

  final ButtonType type;
  final Widget child;
  final VoidCallback? onPress;

  static const double _height = 50;
  static const double _radius = 25;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.defaultBtn:
        return _buildFilled(context);

      case ButtonType.outline:
        return _buildOutlined(context);
    }
  }

  // 🔹 Filled button
  Widget _buildFilled(BuildContext context) {
    return Container(
      height: _height,
      decoration: _decoration(context),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          elevation: 0, // shadow handled by Container
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: BorderSide(
              color: context.colors.lightShadeGrey20,
              width: 3,
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  // 🔹 Outlined button (same style)
  Widget _buildOutlined(BuildContext context) {
    return SizedBox(
      height: _height,
      // decoration: _decoration(context),
      child: OutlinedButton(
        onPressed: onPress,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: child,
      ),
    );
  }

  // 🔹 Shared decoration
  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
