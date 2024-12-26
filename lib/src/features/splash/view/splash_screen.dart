import 'package:flutter/material.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/app/medias.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
        if (mounted) {

        navigateOffAllNamed(context, RouteConfig.homeScreen);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColor.kWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kAppIcon2Image,
              height: 192,
              width: 192,
            ),
            vSizedBox1andHalf,
            CustomText.ourText(
              "SMART NOTE",
              color: AppColor.secondaryColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ],
        ),
      ),
    );
  }
}
