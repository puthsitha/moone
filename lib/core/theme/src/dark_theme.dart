import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monee/core/theme/colors.dart';
import 'package:monee/core/theme/fonts.dart';

const ColorScheme colorSchemeDark = ColorScheme(
  surface: AppColors.pureDark,
  onSurface: AppColors.pureWhite,
  //
  primary: AppColors.primary,
  // primaryContainer: Color(0xFFEE3075),
  onPrimary: AppColors.greySecondary,
  secondary: AppColors.secondary,
  secondaryContainer: Color(0xFF1A1A1A),
  onSecondary: Color(0xFF1A1A1A),
  //
  error: Color(0xFFFF6B6B),
  onError: Color(0xFF000000),
  brightness: Brightness.dark,
  //neutrals
);

final colorSchemeDarkExt = AppColorScheme(
  primary: AppColors.primary,
  secondary: AppColors.secondary,
  tertiary: AppColors.tertiary,
  primaryText: AppColors.greySecondary,
  secondaryText: AppColors.secondaryTextLight,
  purpleLight: AppColors.purpleDark,
  purplePrimary: AppColors.purplePrimary,
  purpleDark: AppColors.purpleLight,
  orangeLight: AppColors.orangePrimary,
  orangePrimary: AppColors.orangePrimary,
  greenLight: AppColors.greenDark,
  greenPrimary: AppColors.greenPrimary,
  greenDark: AppColors.greenLight,
  transparent: const Color.fromARGB(0, 0, 0, 0),
  darkCyanBlue: AppColors.blueLight,
  blueLight: AppColors.darkCyanBlue,
  greyLight: AppColors.greyDark,
  redPrimary: AppColors.redPrimary,
  greyPrimary: AppColors.greyPrimary,
  greyDark: AppColors.greyLight,
  greySecondary: AppColors.greySecondary,
  processing: AppColors.processing,
  inDelivery: AppColors.inDelivery,
  delivered: AppColors.delivered,
  darkShadeGrey100: AppColors.lightShadeGrey10,
  darkShadeGrey60: AppColors.lightShadeGrey40,
  darkShadeGrey70: AppColors.lightShadeGrey30,
  darkShadeGrey80: AppColors.lightShadeGrey20,
  darkShadeGrey90: AppColors.lightShadeGrey10,
  lightShadeGrey10: AppColors.darkShadeGrey90,
  lightShadeGrey20: AppColors.darkShadeGrey80,
  lightShadeGrey30: AppColors.darkShadeGrey70,
  lightShadeGrey40: AppColors.darkShadeGrey60,
  lightShadeGrey50: AppColors.lightShadeGrey50,
  pureDark: AppColors.pureWhite,
  pureWhite: AppColors.darkShadeGrey100,
  foodHomeAppBar: const Color(0xFF01131A),
  divider: AppColors.darkShadeGrey80,
);

final darkTheme = ThemeData(
  extensions: [
    colorSchemeDarkExt,
    const FlashToastTheme(),
    const FlashBarTheme(),
  ],
  useMaterial3: false,
  chipTheme: ChipThemeData(
    secondaryLabelStyle: const TextStyle(
      color: Colors.black,
      fontFamily: Fonts.en,
      fontFamilyFallback: [Fonts.kh],
      fontSize: 12,
    ),
    deleteIconColor: Colors.black,
    backgroundColor: colorSchemeDarkExt.primary,
    checkmarkColor: Colors.black,
    labelStyle: const TextStyle(
      color: Colors.black,
      fontFamily: Fonts.en,
      fontFamilyFallback: [Fonts.kh],
      fontSize: 12,
    ),
  ),

  scaffoldBackgroundColor: colorSchemeDarkExt.lightShadeGrey10,

  dividerTheme: DividerThemeData(
    thickness: 0.5,
    color: colorSchemeDarkExt.lightShadeGrey20,
  ),
  textTheme: Typography.material2021().white
      .copyWith(
        displayLarge: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        displayMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        displaySmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        headlineLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        headlineMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        headlineSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        labelSmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        labelMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: Fonts.en,
          fontFamilyFallback: [Fonts.kh],
        ),
      )
      .apply(
        bodyColor: colorSchemeDarkExt.primaryText,
        displayColor: colorSchemeDarkExt.primaryText,
        fontFamily: Fonts.en,
        fontFamilyFallback: [Fonts.kh, Fonts.en],
      ),
  colorScheme: colorSchemeDark,
  primaryColor: colorSchemeDarkExt.primary,
  tabBarTheme: const TabBarThemeData(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.secondary, strokeAlign: 6),
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: Fonts.en,
      fontFamilyFallback: [Fonts.kh],
      color: AppColors.pureWhite,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: Fonts.en,
      fontFamilyFallback: [Fonts.kh],
      color: AppColors.lightShadeGrey40,
    ),
  ),

  // primaryColorDark: colorSchemeDarkExt.primary900,
  // primaryColorLight: colorSchemeDarkExt.primary400,
  datePickerTheme: const DatePickerThemeData(),
  fontFamily: Fonts.en,
  fontFamilyFallback: const [Fonts.kh, Fonts.en],
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: Colors.transparent,
    childrenPadding: const EdgeInsets.all(16),
    iconColor: colorSchemeDarkExt.primary,
    textColor: colorSchemeDarkExt.primaryText,
    collapsedTextColor: colorSchemeDarkExt.primaryText,
    collapsedIconColor: colorSchemeDarkExt.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: colorSchemeDarkExt.lightShadeGrey50,
      fontFamilyFallback: const [Fonts.en, Fonts.kh],
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    fillColor: Colors.transparent,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        width: 2,
        color: colorSchemeDarkExt.primary,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        width: 2,
        // color: Colors.red,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: colorSchemeDarkExt.lightShadeGrey30,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: colorSchemeDarkExt.lightShadeGrey30,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  // cupertinoOverrideTheme: CupertinoThemeData(textTheme: ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    enableFeedback: false,
    elevation: 1,
    backgroundColor: colorSchemeDarkExt.lightShadeGrey10,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: colorSchemeDarkExt.darkShadeGrey80,
    selectedIconTheme: const IconThemeData(size: 24),
    unselectedIconTheme: const IconThemeData(size: 24),
    selectedLabelStyle: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.primary,
      fontFamily: Fonts.en,
      fontFamilyFallback: [Fonts.kh],
      height: 1.6,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      fontFamily: Fonts.en,
      color: colorSchemeDarkExt.lightShadeGrey30,
      fontFamilyFallback: const [Fonts.kh],
      height: 1.6,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: Fonts.en,
        fontFamilyFallback: [Fonts.kh],
      ),
      shape: const StadiumBorder(),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      padding: const EdgeInsets.all(10),
      iconSize: 20,
      backgroundColor: colorSchemeDark.surface,
      foregroundColor: colorSchemeDark.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamilyFallback: const [Fonts.kh],
      color: colorSchemeDark.onSurface,
      fontFamily: Fonts.en,
    ),
    iconTheme: IconThemeData(
      color: colorSchemeDark.onSurface,
    ),
    elevation: 0,
    backgroundColor: colorSchemeDarkExt.primary,
    actionsIconTheme: IconThemeData(
      size: 24,
      color: colorSchemeDark.onSurface,
    ),
    centerTitle: true,
  ),
);
