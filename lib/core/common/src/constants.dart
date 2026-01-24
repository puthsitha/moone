import 'package:flutter/material.dart';

final List<LinearGradient> prettyGradients = [
  // 1. Peach Blossom
  const LinearGradient(
    colors: [Color(0xFFFFD1DC), Color(0xFFFFB7C5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 2. Cotton Candy
  const LinearGradient(
    colors: [Color(0xFFFFC0CB), Color(0xFFB5EAD7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 3. Lavender Dream
  const LinearGradient(
    colors: [Color(0xFFE6D9FF), Color(0xFFBFA2DB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),

  // 4. Baby Blue Sky
  const LinearGradient(
    colors: [Color(0xFFBEE7E8), Color(0xFFAED9E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 5. Rose Milk
  const LinearGradient(
    colors: [Color(0xFFFFE4E1), Color(0xFFFFC1CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 6. Mint Cream
  const LinearGradient(
    colors: [Color(0xFFDFF5EA), Color(0xFFBEE7C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 7. Soft Sunset
  const LinearGradient(
    colors: [Color(0xFFFFE0B2), Color(0xFFFFCCBC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),

  // 8. Sakura Glow
  const LinearGradient(
    colors: [Color(0xFFFFDDE1), Color(0xFFFAB2C4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 9. Vanilla Sky
  const LinearGradient(
    colors: [Color(0xFFFFF1C1), Color(0xFFB5EAEA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 10. Dreamy Lilac
  const LinearGradient(
    colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 11. Blush Mint
  const LinearGradient(
    colors: [Color(0xFFFFD6E0), Color(0xFFC1F0DC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 12. Cloudy Pastel
  const LinearGradient(
    colors: [Color(0xFFF1F3F8), Color(0xFFE3E6F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),

  // 13. Soft Berry
  const LinearGradient(
    colors: [Color(0xFFFBC2EB), Color(0xFFA6C1EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),

  // 14. Calm Ocean
  const LinearGradient(
    colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];

final List<Color> avatarColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.red,
  Colors.teal,
  Colors.indigo,
];

Color getAvatarColor(String name) {
  final colors = avatarColors;
  final index = name.codeUnits.reduce((a, b) => a + b) % colors.length;
  return colors[index];
}

const bodyPadding = EdgeInsets.all(16);
const paddingHorizontal = EdgeInsets.symmetric(horizontal: 16);
const paddingVertical = EdgeInsets.symmetric(vertical: 16);

/// The standard body padding for the app.
const kBodyPadding = EdgeInsets.symmetric(horizontal: 20);
const kPadding = EdgeInsets.all(20);

/// The standard button padding for the app.
const kButtonPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 16);

/// The standard app bar button size.
const double kAppBarButtonSize = 56;

final ShapeBorder kCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

final BorderRadius kBorderRadius = BorderRadius.circular(16);

/// The standard shadow for containers
const kCardShadow = [
  BoxShadow(
    blurRadius: 6,
    color: Color.fromRGBO(153, 153, 153, 0.46),
    offset: Offset(0, 2),
    spreadRadius: 0.2,
  ),
];

/// The standard shadow for containers
const kAppBarShadow = [
  BoxShadow(
    blurRadius: 9,
    color: Color.fromRGBO(153, 153, 153, 0.3),
    offset: Offset(0, 1),
    spreadRadius: 3,
  ),
];

/// The secondary shadow for containers with primaryColor
const kCardShadowPrimary = [
  BoxShadow(
    blurRadius: 32.2,
    color: Color.fromRGBO(55, 1, 120, 0.59),
    offset: Offset(0, 5),
    spreadRadius: 2.8,
  ),
];

/// The secondary shadow for buttons
const kButtonShadow = [
  BoxShadow(
    blurRadius: 9.2,
    color: Color.fromRGBO(153, 153, 153, 0.5),
    offset: Offset(0, 4),
  ),
];
