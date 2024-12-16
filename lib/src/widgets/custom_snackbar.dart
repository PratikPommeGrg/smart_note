import 'package:flutter/material.dart';
import 'package:smart_note/src/core/app/colors.dart';

class CustomSnackbar {
  static showSnackBar({
    required BuildContext context,
    required String message,
    bool? isSuccess = true,
    bool? warningSnackBar = false,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: warningSnackBar ?? false
            ? AppColor.kOrangeMain
            : isSuccess ?? false
                ? AppColor.kGreenMain
                : AppColor.kRedMain,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
