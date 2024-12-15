import 'package:flutter/material.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

ValueNotifier<bool> isVoiceRecording = ValueNotifier<bool>(false);

ValueNotifier<bool> isFABOpened = ValueNotifier<bool>(false);
ValueNotifier<bool> isScreenBlurred = ValueNotifier<bool>(false);

List<String> noteCategories = [
  "All",
  "Personal",
  "Work",
  "Grocery",
  "Travel",
  "Health",
  "Ideas"
];


 final TextEditingController titleController = TextEditingController();
    final TextEditingController noteController = TextEditingController();