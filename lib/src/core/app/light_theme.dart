import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/texts.dart';

final appTheme = ThemeData(
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColor.kNeutral50,
    primaryColor: AppColor.primaryColor,
    appBarTheme: AppBarTheme(
      foregroundColor: AppColor.kNeutral800,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // statusBarColor: AppColor.backgroundColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.secondaryColor,
    ));
