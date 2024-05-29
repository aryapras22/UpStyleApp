import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 238, 99, 56),
    secondary: Color.fromARGB(255, 150, 150, 150),
    surface: Color.fromARGB(255, 246, 246, 246),
    onSurface: Colors.black,
    tertiary: Color.fromARGB(255, 106, 112, 124),
    onSecondary: Color.fromARGB(255, 225, 225, 225),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: 'ProductSansMedium',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 150, 150, 150),
      fontFamily: 'ProductSansMedium',
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 150, 150, 150),
      fontFamily: 'ProductSansMedium',
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    iconColor: Color.fromARGB(255, 106, 112, 124),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide.none,
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 150, 150, 150),
      fontFamily: 'ProductSansMedium',
    ),
    hintStyle: TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 150, 150, 150),
      fontWeight: FontWeight.normal,
      fontFamily: 'ProductSansMedium',
    ),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Color.fromARGB(255, 150, 150, 150),
    elevation: 0,
    shape: CircularNotchedRectangle(),
    height: 60,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.black,
    padding: EdgeInsets.symmetric(horizontal: 16),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color.fromARGB(255, 238, 99, 56),
    unselectedItemColor: Color.fromARGB(255, 157, 157, 157),
    selectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'ProductSansMedium',
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'ProductSansMedium',
    ),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    elevation: 5,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        const Color.fromARGB(255, 238, 99, 56),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'ProductSansMedium',
        ),
      ),
    ),
  ),
);
