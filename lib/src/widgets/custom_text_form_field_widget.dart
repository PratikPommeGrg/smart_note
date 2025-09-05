import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_note/src/core/app/texts.dart';

import '../core/app/colors.dart';
import '../core/configs/regex_config.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final dynamic formKey;
  final String? hintText;
  final TextInputType textInputType;
  final String? labelText;
  final Widget? suffix;
  final bool? isEnabled;
  final bool readOnly;
  final bool obscureText;

  final Function? validator;
  final bool onlyText;
  final bool onlyNumber;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final String? prefixText;
  final bool? filled;
  final Color? fillColor;
  final IconData? prefixIcon;
  final Function()? onTap;
  final Function? onChanged;
  final Function? onFieldSubmitted;
  final String? initialValue;
  final bool? isSearch;
  final bool? autoFocus;
  final AutovalidateMode? autovalidateMode;
  final List<String> autoFillHint;
  final bool searchString;
  final bool fullNameString;
  final bool allowMultipleSpace;
  final bool? showBorder;
  final TextInputAction? textInputAction;
  final double borderRadius;
  final double? hintTextSize;
  final FontWeight? hintTextWeight;
  final double? enteredTextSize;
  final FontWeight? enteredTextWeight;
  final TextAlign? textAlignment;
  final bool? notFromFormType;
  final bool? allowDouble;
  final bool? onlyPhoneNumber;
  final dynamic prefixIconSize;
  final bool? isPrefixText;
  final Widget? prefix;
  final FocusNode? focusNode;
  final ScrollController? scrollController;

  const CustomTextFormField({
    super.key,
    this.formKey,
    this.prefix,
    this.controller,
    this.onlyPhoneNumber = false,
    this.hintText,
    this.textInputType = TextInputType.text,
    this.labelText,
    this.suffix,
    this.isEnabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.onlyText = false,
    this.onlyNumber = false,
    this.maxLine = 1,
    this.minLine = 1,
    this.isPrefixText,
    this.maxLength,
    this.prefixText,
    this.filled = true,
    this.fillColor = Colors.white,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.isSearch = false,
    this.autoFocus = false,
    this.autovalidateMode,
    this.autoFillHint = const [],
    this.searchString = false,
    this.fullNameString = false,
    this.allowMultipleSpace = true,
    this.textInputAction,
    this.showBorder = true,
    this.borderRadius = 12,
    this.hintTextSize,
    this.hintTextWeight,
    this.enteredTextSize,
    this.enteredTextWeight,
    this.textAlignment,
    this.notFromFormType = false,
    this.allowDouble,
    this.prefixIconSize = 22.0,
    this.focusNode,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollController: scrollController,
      autofocus: autoFocus ?? false,
      textAlign: textAlignment ?? TextAlign.left,
      minLines: minLine,
      maxLines: maxLine,
      maxLength: maxLength,
      textInputAction: textInputAction ?? TextInputAction.done,
      autofillHints: autoFillHint,
      // autofocus: autoFocus ?? false,
      focusNode: focusNode,
      validator: (value) {
        return validator == null ? null : validator!(value);
      },
      style: TextStyle(
        // color: readOnly ? Colors.grey : null,
        fontSize: enteredTextSize ?? 16,
        fontFamily: fontFamily,
        fontWeight: enteredTextWeight ?? FontWeight.w400,
      ),
      inputFormatters: onlyNumber
          ? [
              FilteringTextInputFormatter.allow(RegexConfig.numberRegex),
              FilteringTextInputFormatter.deny(
                RegexConfig.stopConsecutiveSpace,
              ),
            ]
          : onlyText
              ? [
                  FilteringTextInputFormatter.allow(RegexConfig.textRegex),
                  FilteringTextInputFormatter.deny(
                    RegexConfig.stopConsecutiveSpace,
                  ),
                ]
              : searchString
                  ? [
                      FilteringTextInputFormatter.allow(
                          RegexConfig.searchRegrex),
                      FilteringTextInputFormatter.deny(
                        RegexConfig.stopConsecutiveSpace,
                      ),
                    ]
                  : fullNameString
                      ? [
                          FilteringTextInputFormatter.allow(
                              RegexConfig.fullNameTextRegrex),
                          FilteringTextInputFormatter.deny(
                            RegexConfig.stopConsecutiveSpace,
                          ),
                        ]
                      : allowMultipleSpace == false
                          ? [
                              FilteringTextInputFormatter.deny(
                                RegExp(r'\s{2}'),
                              ),
                            ]
                          : allowDouble == false
                              ? [
                                  FilteringTextInputFormatter.allow(
                                    RegexConfig.doubleRegExp,
                                  ),
                                ]
                              : onlyPhoneNumber == true
                                  ? [FilteringTextInputFormatter.digitsOnly]
                                  : [
                                      FilteringTextInputFormatter.deny(
                                        RegexConfig.stopConsecutiveSpace,
                                      ),
                                    ],
      readOnly: readOnly,
      initialValue: initialValue,
      enabled: isEnabled,
      onTap: onTap,
      onChanged: (val) => isSearch == true ? onChanged!(val) : null,
      onFieldSubmitted: (val) =>
          isSearch == true ? onFieldSubmitted!(val) : null,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        isDense: true,
        prefixText: isPrefixText == true ? prefixText : null,
        // prefix: prefix,
        prefixStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColor.kNeutral500,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        filled: filled,
        contentPadding: notFromFormType == true
            ? EdgeInsets.zero
            : const EdgeInsets.all(15),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColor.kNeutral500,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          fontSize: 10.0,
          fontFamily: fontFamily,
        ),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          // fontSize: 16.0,
          color: AppColor.kNeutral500,
          fontSize: hintTextSize ?? 15,
          fontWeight: hintTextWeight ?? FontWeight.w400,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.grey,
                size: prefixIconSize,
              )
            : prefix,
        fillColor: filled == true ? fillColor : null,
        hintText: hintText,
        labelText: labelText,
        // suffix: suffix,
        suffixIcon: suffix,
        enabledBorder: filled == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: AppColor.kNeutral400,
                  width: 2,
                ),
              )
            : showBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
        border: filled == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: AppColor.kNeutral400,
                  width: 2,
                ),
              ),
        focusedBorder: filled == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: AppColor.kNeutral900,
                  width: 2,
                ),
              )
            : showBorder == false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
      ),
    );
  }
}
