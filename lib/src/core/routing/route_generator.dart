import 'package:flutter/material.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/features/home/view/home_screen.dart';
import 'package:smart_note/src/features/note/view/add_note_screen.dart';
import 'package:smart_note/src/features/splash/view/splash_screen.dart';
import 'package:smart_note/src/features/voice_record/view/voice_record_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConfig.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteConfig.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteConfig.voiceRecordScreen:
        return MaterialPageRoute(builder: (_) => const VoiceRecordScreen());

      case RouteConfig.addNoteScreen:
        var args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
            builder: (_) =>
                AddNoteScreen(isForEdit: args?['isForEdit'] ?? false));

      default:
        return MaterialPageRoute(builder: (_) => const RouteErrorScreen());
    }
  }
}

class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Error"),
      ),
      body: const Center(
        child: Text("Invalid Route Name"),
      ),
    );
  }
}
