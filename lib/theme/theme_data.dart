import 'package:flutter/material.dart';
import 'package:twitter_x_three/theme/theme.dart';

ThemeData darkTheme() {
  return ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: PallateColor.BackGoundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: PallateColor.BackGoundColor,
    ),
    tabBarTheme: const TabBarTheme(
      labelPadding: EdgeInsets.only(bottom: 20),
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      unselectedLabelColor: PallateColor.unselectColor,
      labelColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorColor: PallateColor.blue,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: PallateColor.blue,
    ),
  );
}
