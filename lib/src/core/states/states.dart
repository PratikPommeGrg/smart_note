import 'package:flutter/material.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

ValueNotifier<bool> isVoiceRecording = ValueNotifier<bool>(false);

ValueNotifier<bool> isFABOpened = ValueNotifier<bool>(false);
ValueNotifier<bool> isScreenBlurred = ValueNotifier<bool>(false);

ValueNotifier<String> selectedCategory = ValueNotifier<String>("All");
