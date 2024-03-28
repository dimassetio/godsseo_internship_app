import 'package:flutter/material.dart';

Color mainColor = Color(0XFF2D6D9A);
Color bgColor = Color(0XFFF2F8FF);
Color clr_white = Color(0XFFFFFFFF);

ThemeData mainTheme =
    ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: mainColor));

ThemeData theme(context) => Theme.of(context);
TextTheme textTheme(context) => Theme.of(context).textTheme;
Color primaryColor(context) => theme(context).primaryColor;
