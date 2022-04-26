
import 'package:flutter/material.dart';
import 'colors.dart';


ThemeData buildAppTheme({bool dark = false}) {
  final ThemeData base = dark?ThemeData.dark():ThemeData.light();

  return base.copyWith(
      brightness: dark?Brightness.dark:Brightness.light,
      primaryColor: dark?primaryGreenDark:primaryGreen,
      primaryColorDark: primaryGreenDark,
      primaryColorLight: primaryGreenLight,
      errorColor: dark?primaryRedDark:primaryRed,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryGreen),
      scaffoldBackgroundColor: dark?Color(0xFF303030):Colors.white,
      textTheme: base.textTheme,
      snackBarTheme: _appSnackBarTheme(base.snackBarTheme),
      appBarTheme: _appBarTheme(base.appBarTheme.copyWith(brightness: dark?Brightness.dark:Brightness.light)),
      elevatedButtonTheme: _elevatedButtonTheme(base.elevatedButtonTheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(base.floatingActionButtonTheme),
      checkboxTheme: _checkBoxTheme(base.checkboxTheme, dark),
      buttonTheme: _buttonTheme(base.buttonTheme), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryGreen),
      dividerColor: dark?Colors.grey.withOpacity(0.5):Colors.grey
    // dialogTheme: _dialogTheme(base.dialogTheme)
  ).copyWith(
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: primaryGreen,
              onPrimary: Colors.white,
              secondary: primaryGreen,
              onSecondary: Colors.black,
              error: Colors.redAccent,
              onError: Colors.white,
              background: Colors.white,
              onBackground: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black));
}

ButtonThemeData _buttonTheme(ButtonThemeData base){
  return base.copyWith(
    splashColor: Colors.white54,
    highlightColor: Colors.white24,
  );
}

DialogTheme _dialogTheme(DialogTheme base) {
  return base.copyWith(contentTextStyle: TextStyle(color: Colors.black));
}

TextTheme _appTextTheme(TextTheme base) {
  return base.copyWith(
    bodyText1: TextStyle(color: Colors.black87),
    subtitle1: TextStyle(color: Colors.black87),
  );
}

CheckboxThemeData _checkBoxTheme(CheckboxThemeData base, bool dark) {
  return base.copyWith(
    fillColor: MaterialStateProperty.all(dark?primaryGreenDark:primaryGreen),
    // checkColor: MaterialStateProperty.all(secodaryYellow),
  );
}

FloatingActionButtonThemeData _floatingActionButtonTheme(
    FloatingActionButtonThemeData base) {
  return FloatingActionButtonThemeData(
    backgroundColor: secondaryYellow,
  );
}

ElevatedButtonThemeData _elevatedButtonTheme(ElevatedButtonThemeData base) {
  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryGreen),
      textStyle: MaterialStateProperty.all(TextStyle(color: primaryGreenDark)),
    ),
  );
}

AppBarTheme _appBarTheme(AppBarTheme base) {
  return base.copyWith(
    centerTitle: true,
    backgroundColor: base.brightness==Brightness.dark?primaryGreenDark:primaryGreen,
    titleTextStyle: TextStyle(
        color: textOnPrimaryGreen, fontWeight: FontWeight.w600, fontSize: 24),
    // textTheme: TextTheme(
    //   headline6: TextStyle(
    //       color: textOnPrimaryGreen, fontWeight: FontWeight.w600, fontSize: 24),
    // ),
  );
}

SnackBarThemeData _appSnackBarTheme(SnackBarThemeData base) {
  return base.copyWith(contentTextStyle: TextStyle(color: Colors.white));
}