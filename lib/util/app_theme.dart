
import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: Colors.white,
      textTheme: _appTextTheme(base.textTheme),
      snackBarTheme: _appSnackBarTheme(base.snackBarTheme),
      appBarTheme: _appBarTheme(base.appBarTheme),
      elevatedButtonTheme: _elevatedButtonTheme(base.elevatedButtonTheme),
      floatingActionButtonTheme:
      _floatingActionButtonTheme(base.floatingActionButtonTheme),
      checkboxTheme: _checkBoxTheme(base.checkboxTheme),
      buttonTheme: _buttonTheme(base.buttonTheme), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryGreen)
    // dialogTheme: _dialogTheme(base.dialogTheme)
  );
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

CheckboxThemeData _checkBoxTheme(CheckboxThemeData base) {
  return base.copyWith(
    fillColor: MaterialStateProperty.all(primaryGreen),
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
    backgroundColor: primaryGreen,
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