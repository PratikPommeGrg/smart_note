import 'package:flutter/material.dart';
import 'package:smart_note/src/core/app/texts.dart';

import '../core/app/colors.dart';

class CustomText {
  static Text ourText(
    String? data, {
    Color? color,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? fontSize = 16,
    int? maxLines = 2,
    TextDecoration? textDecoration,
    Color? decorationColor,
    bool? isFontFamily = true,
    double? height,
    bool? clipOverflow = false,
  }) =>
      Text(
        data ?? '',
        maxLines: maxLines,
        overflow:
            clipOverflow ?? false ? TextOverflow.clip : TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(
          height: height,
          decoration: textDecoration ?? TextDecoration.none,
          decorationColor: decorationColor ?? AppColor.kNeutral800,
          fontSize: fontSize,
          fontFamily: isFontFamily == true ? fontFamily : null,
          fontStyle: fontStyle ?? FontStyle.normal,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? AppColor.kNeutral800,
        ),
      );
}
