import 'package:flutter/material.dart';
import 'package:smart_note/src/core/app/light_theme.dart';
import 'package:smart_note/src/features/home/view/home_screen.dart';

import 'src/core/routing/route_generator.dart';
import 'src/core/states/states.dart';

class SmartNoteApp extends StatelessWidget {
  const SmartNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      navigatorKey: rootNavigatorKey,
      home: const HomeScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: appTheme,
    );
  }
}
