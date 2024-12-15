import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/texts.dart';

final appTheme = ThemeData(
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColor.kNeutral100,
    primaryColor: AppColor.primaryColor,
    appBarTheme: AppBarTheme(
      foregroundColor: AppColor.kNeutral800,
      backgroundColor: AppColor.primaryColor,
      systemOverlayStyle: const SystemUiOverlayStyle(
          // statusBarColor: AppColor.backgroundColor,
          // statusBarBrightness: Brightness.dark,
          ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.tertiaryColor,
    ));
