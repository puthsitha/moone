import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF3498DB);
  static const secondary = Color(0xFFD8B226);
  static const tertiary = Color(0xFF091734);
  static const black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0x00f6f7fb);
  static const secondaryTextLight = Color(0xFF8F96B1);

  //purple
  static const purpleLight = Color(0xFF8C6FF7);
  static const purplePrimary = Color(0xFF5A31F4);
  static const purpleDark = Color(0xFF3F22AB);
  //orange
  static const orangeLight = Color(0xFFFFF0DD);
  static const orangePrimary = Color(0xFFFF9F21);
  //green
  static const greenLight = Color(0xFF5BD51E);
  static const greenPrimary = Color(0xFF60BA62);
  static const greenDark = Color(0xFF4AC272);

  //yellow
  static const yellowPrimary = Color(0xFFFFB323);
  //blue
  static const darkCyanBlue = Color(0xFF2C5054);
  static const blueLight = Color(0xFF4F6FB4);
  //grey
  static const greyLight = Color(0xFF6A7486);
  static const greyPrimary = Color(0xFFB9C2C3);
  static const greySecondary = Color(0xFFB9C2C3);
  static const greyDark = Color(0xFF163336);
  //red
  static const redPrimary = Color(0xFFFC3B3B);
  //order color status
  static const processing = Color(0xFFFFBA7A);
  static const inDelivery = Color(0xFFE8DB67);
  static const delivered = Color(0xFF62C684);

  // grey shades
  static const pureWhite = Color(0xFFFFFFFF);
  static const lightShadeGrey10 = Color(0xFFF7F9FA);
  static const lightShadeGrey20 = Color(0xFFF2F4F5);
  static const lightShadeGrey30 = Color(0xFFE3E5E5);
  static const lightShadeGrey40 = Color(0xFFCDCFD0);
  static const lightShadeGrey50 = Color(0xFF979C9E);

  static const pureDark = Color(0xFF090A0A);
  static const darkShadeGrey100 = Color(0xFF202325);
  static const darkShadeGrey90 = Color(0xFF303437);
  static const darkShadeGrey80 = Color(0xFF404446);
  static const darkShadeGrey70 = Color(0xFF6C7072);
  static const darkShadeGrey60 = Color(0xFF72777A);
}

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.transparent,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiary,
    required this.purpleLight,
    required this.purplePrimary,
    required this.purpleDark,
    required this.orangeLight,
    required this.orangePrimary,
    required this.greenLight,
    required this.greenPrimary,
    required this.greenDark,
    required this.darkCyanBlue,
    required this.blueLight,
    required this.greyLight,
    required this.redPrimary,
    required this.greyPrimary,
    required this.greySecondary,
    required this.greyDark,
    required this.processing,
    required this.inDelivery,
    required this.delivered,
    required this.darkShadeGrey100,
    required this.darkShadeGrey60,
    required this.darkShadeGrey70,
    required this.darkShadeGrey80,
    required this.darkShadeGrey90,
    required this.lightShadeGrey10,
    required this.lightShadeGrey20,
    required this.lightShadeGrey30,
    required this.lightShadeGrey40,
    required this.lightShadeGrey50,
    required this.pureDark,
    required this.pureWhite,
    required this.divider,
    this.foodHomeAppBar,
  });

  /// Main primary color
  final Color primary;

  /// Main secondary color
  final Color secondary;

  /// Main tertiary color
  final Color tertiary;
  final Color transparent;

  final Color primaryText;
  final Color secondaryText;

  //purple
  final Color purpleLight;
  final Color purplePrimary;
  final Color purpleDark;
  //orange
  final Color orangeLight;
  final Color orangePrimary;
  //green
  final Color greenLight;
  final Color greenPrimary;
  final Color greenDark;
  //Blue
  final Color darkCyanBlue;
  final Color blueLight;
  //grey
  final Color greyLight;
  final Color greyPrimary;
  final Color greySecondary;
  final Color greyDark;
  //red
  final Color redPrimary;
  // order status
  final Color processing;
  final Color inDelivery;
  final Color delivered;

  // Shades
  final Color pureWhite;
  final Color lightShadeGrey10;
  final Color lightShadeGrey20;
  final Color lightShadeGrey30;
  final Color lightShadeGrey40;
  final Color lightShadeGrey50;

  final Color pureDark;
  final Color darkShadeGrey100;
  final Color darkShadeGrey90;
  final Color darkShadeGrey80;
  final Color darkShadeGrey70;
  final Color darkShadeGrey60;
  final Color divider;

  // Background
  final Color? foodHomeAppBar;

  @override
  ThemeExtension<AppColorScheme> lerp(
    covariant ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (identical(this, other)) {
      return this;
    }
    return AppColorScheme(
      primary: primary,
      primaryText: primaryText,
      secondary: secondary,
      secondaryText: secondaryText,
      transparent: transparent,
      tertiary: tertiary,
      purpleLight: purpleLight,
      purplePrimary: purplePrimary,
      purpleDark: purpleDark,
      orangeLight: orangeLight,
      orangePrimary: orangePrimary,
      greenLight: greenLight,
      greenPrimary: greenPrimary,
      greenDark: greenDark,
      darkCyanBlue: darkCyanBlue,
      blueLight: blueLight,
      greyLight: greyLight,
      redPrimary: redPrimary,
      greyPrimary: greyPrimary,
      greySecondary: greySecondary,
      greyDark: greyDark,
      processing: processing,
      inDelivery: inDelivery,
      delivered: delivered,
      darkShadeGrey100: darkShadeGrey100,
      darkShadeGrey60: darkShadeGrey60,
      darkShadeGrey70: darkShadeGrey70,
      darkShadeGrey80: darkShadeGrey80,
      darkShadeGrey90: darkShadeGrey90,
      pureDark: pureDark,
      pureWhite: pureWhite,
      lightShadeGrey10: lightShadeGrey10,
      lightShadeGrey20: lightShadeGrey20,
      lightShadeGrey30: lightShadeGrey30,
      lightShadeGrey40: lightShadeGrey40,
      lightShadeGrey50: lightShadeGrey50,
      foodHomeAppBar: foodHomeAppBar,
      divider: divider,
    );
  }

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryText,
    Color? secondaryText,
    Color? purpleLight,
    Color? purplePrimary,
    Color? purpleDark,
    Color? orangeLight,
    Color? orangePrimary,
    Color? greenLight,
    Color? greenPrimary,
    Color? greenDark,
    Color? transparent,
    Color? darkCyanBlue,
    Color? blueLight,
    Color? greyLight,
    Color? redPrimary,
    Color? greyPrimary,
    Color? greySecondary,
    Color? greyDark,
    Color? processing,
    Color? inDelivery,
    Color? delivered,
    Color? darkShadeGrey100,
    Color? darkShadeGrey60,
    Color? darkShadeGrey70,
    Color? darkShadeGrey80,
    Color? darkShadeGrey90,
    Color? lightShadeGrey10,
    Color? lightShadeGrey20,
    Color? lightShadeGrey30,
    Color? lightShadeGrey40,
    Color? lightShadeGrey50,
    Color? pureDark,
    Color? pureWhite,
    Color? mainBgPath,
    Color? divider,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiary: tertiary ?? this.tertiary,
      orangePrimary: orangeLight ?? this.orangePrimary,
      purpleLight: purpleLight ?? this.purpleLight,
      purplePrimary: purplePrimary ?? this.purplePrimary,
      purpleDark: purpleDark ?? this.purpleDark,
      orangeLight: orangeLight ?? this.orangeLight,
      greenLight: greenLight ?? this.greenLight,
      greenPrimary: greenPrimary ?? this.greenPrimary,
      greenDark: greenDark ?? this.greenDark,
      transparent: transparent ?? this.transparent,
      darkCyanBlue: darkCyanBlue ?? this.darkCyanBlue,
      blueLight: blueLight ?? this.blueLight,
      greyLight: greyLight ?? this.greyLight,
      redPrimary: redPrimary ?? this.redPrimary,
      greyPrimary: greyPrimary ?? this.greyPrimary,
      greySecondary: greySecondary ?? this.greySecondary,
      greyDark: greyDark ?? this.greyDark,
      processing: processing ?? this.processing,
      inDelivery: inDelivery ?? this.inDelivery,
      delivered: delivered ?? this.delivered,
      darkShadeGrey100: darkShadeGrey100 ?? this.darkShadeGrey100,
      darkShadeGrey60: darkShadeGrey60 ?? this.darkShadeGrey60,
      darkShadeGrey70: darkShadeGrey70 ?? this.darkShadeGrey70,
      darkShadeGrey80: darkShadeGrey80 ?? this.darkShadeGrey80,
      darkShadeGrey90: darkShadeGrey90 ?? this.darkShadeGrey90,
      lightShadeGrey10: lightShadeGrey10 ?? this.lightShadeGrey10,
      lightShadeGrey20: lightShadeGrey20 ?? this.lightShadeGrey20,
      lightShadeGrey30: lightShadeGrey30 ?? this.lightShadeGrey30,
      lightShadeGrey40: lightShadeGrey40 ?? this.lightShadeGrey40,
      lightShadeGrey50: lightShadeGrey50 ?? this.lightShadeGrey50,
      pureDark: pureDark ?? this.pureDark,
      pureWhite: pureWhite ?? this.pureWhite,
      foodHomeAppBar: mainBgPath ?? foodHomeAppBar,
      divider: divider ?? this.divider,
    );
  }
}
