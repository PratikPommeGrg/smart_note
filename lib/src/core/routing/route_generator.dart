import 'package:flutter/material.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/features/home/view/home_screen.dart';
import 'package:smart_note/src/features/voice_record/view/voice_record_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConfig.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteConfig.voiceRecordScreen:
        return MaterialPageRoute(builder: (_) => const VoiceRecordScreen());

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
