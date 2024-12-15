import 'package:flutter/material.dart';

const double vBox0 = 5.0;
const double vBox0andHalf = 8.0;
const double vBox1 = 12.0;
const double vBox1andHalf = 16.0;
const double hBox1andHalf = 16.0;
const double vBox2 = 24.0;
const double vBox2andHalf = 32;
const double vBox3 = 40.0;
const double vBox4 = 80.0;
const double hBox0 = 5.0;
const double hBox0andHalf = 6.0;
const double hBox1 = 12.0;
const double hBox2 = 24.0;
const double hBox3 = 40.0;
const double hBox4 = 80.0;
const SizedBox vSizedBox0 = SizedBox(height: vBox0);
const SizedBox vSizedBox0andHalf = SizedBox(height: vBox0andHalf);
const SizedBox vSizedBox1 = SizedBox(height: vBox1);
const SizedBox vSizedBox1andHalf = SizedBox(height: vBox1andHalf);
const SizedBox vSizedBox2 = SizedBox(height: vBox2);
const SizedBox vSizedBox2andHalf = SizedBox(height: vBox2andHalf);
const SizedBox vSizedBox3 = SizedBox(height: vBox3);
const SizedBox vSizedBox4 = SizedBox(height: vBox4);
const SizedBox hSizedBox0 = SizedBox(width: hBox0);
const SizedBox hSizedBox0andHalf = SizedBox(width: hBox0andHalf);
const SizedBox hSizedBox1 = SizedBox(width: hBox1);
const SizedBox hSizedBox1andHalf = SizedBox(width: hBox1andHalf);
const SizedBox hSizedBox2 = SizedBox(width: hBox2);
const SizedBox hSizedBox3 = SizedBox(width: hBox3);
const SizedBox hSizedBox4 = SizedBox(width: hBox4);

double appHeight(BuildContext context) => MediaQuery.of(context).size.height;
double appWidth(BuildContext context) => MediaQuery.of(context).size.width;

//! padding
const screenPadding = EdgeInsets.all(8);
const screenLeftRightPadding = EdgeInsets.symmetric(horizontal: 16);
const screenTopBottomPadding = EdgeInsets.symmetric(vertical: 16);

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
