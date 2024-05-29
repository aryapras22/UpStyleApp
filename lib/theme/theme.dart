import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color.fromARGB(255, 238, 99, 56),
    secondary: Color.fromARGB(255, 150, 150, 150),
    surface: Colors.white,
    onSurface: Colors.black,
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
  ),
);
