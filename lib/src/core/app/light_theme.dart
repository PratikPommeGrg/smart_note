import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_note/src/core/app/colors.dart';

final appTheme = ThemeData(
  scaffoldBackgroundColor: AppColor.backgroundColor,
  primaryColor: AppColor.primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.backgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColor.backgroundColor,
    ),
  ),
);
