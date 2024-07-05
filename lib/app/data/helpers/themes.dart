import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color mainColor = Color(0XFF2D6D9A);

Color mainColor = Color(0XFF3888FF);
Color secondaryColor = Color(0XFFFFBC38);
Color bgColor = Color(0XFFF5F5F5);
// Color surfaceColor = Color(0XFFF2F8FF);
Color surfaceColor = Color(0XFFEDF5FF);
Color clrWhite = Color(0XFFFFFFFF);
Color textColor = Color(0XFF484848);
Color textColorSecondary = Color(0XFF6D6D6D);
// Color clr_white = Color(0XFFFFFFFF);

// ThemeData mainTheme =
//     ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: mainColor));

ThemeData mainTheme = ThemeData.from(
    colorScheme: ColorScheme(
  brightness: Brightness.light,
  primary: mainColor,
  onPrimary: clrWhite,
  secondary: secondaryColor,
  onSecondary: textColor,
  error: Colors.red[600]!,
  onError: clrWhite,
  background: bgColor,
  onBackground: textColor,
  surface: surfaceColor,
  onSurface: textColor,
)).copyWith(
    textTheme: GoogleFonts.robotoTextTheme().apply(bodyColor: textColor),
    dividerColor: textColor);

ThemeData theme(context) => Theme.of(context);
ColorScheme colorScheme(context) => Theme.of(context).colorScheme;
TextTheme textTheme(context) => Theme.of(context).textTheme;
Color primaryColor(context) => theme(context).primaryColor;
