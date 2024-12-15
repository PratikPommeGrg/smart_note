import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_note/src/core/app/texts.dart';

import '../core/app/colors.dart';
import '../core/configs/regex_config.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  dynamic formKey;
  String? hintText;
  TextInputType textInputType;
  String? labelText;
  Widget? suffix;
  bool? isEnabled;
  bool readOnly;
  bool obscureText;

  final Function? validator;
  bool onlyText;
  bool onlyNumber;
  int? maxLine;
  int? minLine;
  int? maxLength;
  String? prefixText;
  bool? filled;
  Color? fillColor;
  IconData? prefixIcon;
  Function()? onTap;
  Function? onChanged;
  Function? onFieldSubmitted;
  String? initialValue;
  bool? isSearch;
  bool? autoFocus;
  AutovalidateMode? autovalidateMode;
  List<String> autoFillHint;
  bool searchString;
  bool fullNameString;
  bool allowMultipleSpace;
  bool? showBorder;
  TextInputAction? textInputAction;
  double borderRadius;
  double? hintTextSize;
  FontWeight? hintTextWeight;
  double? enteredTextSize;
  FontWeight? enteredTextWeight;
  TextAlign? textAlignment;
  bool? notFromFormType = false;
  bool? allowDouble;
  bool? onlyPhoneNumber;
  dynamic prefixIconSize;
  bool? isPrefixText;
  Widget? prefix;
  FocusNode? focusNode;
  ScrollController? scrollController;

  CustomTextFormField({
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
    this.notFromFormType,
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
