import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/widgets/custom_text.dart';

class VoiceRecordScreen extends StatelessWidget {
  const VoiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ValueListenableBuilder(
          valueListenable: isVoiceRecording,
          builder: (context, value, child) => GestureDetector(
            onTap: () => isVoiceRecording.value = !isVoiceRecording.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (value) ...[
                  CustomText.ourText(
                    "Tap to Stop!",
                    fontWeight: FontWeight.w500,
                    // fontSize: 18,
                  ),
                  vSizedBox1andHalf,
                ],
                AnimatedBuilder(
                  animation: isVoiceRecording,
                  builder: (context, child) => Center(
                    child: value
                        ? LottieBuilder.asset(
                            "assets/json/voice_record_active.json")
                        : Image.asset(
                            "assets/images/voice_record_inactive.png",
                            height: appHeight(context) * 0.2,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                  ),
                ),
                vSizedBox1andHalf,
                CustomText.ourText(value ? "Recording..." : "Tap to record",
                    color: value ? Colors.lightBlue : null),
                vSizedBox1andHalf,
                CustomText.ourText(
                  value
                      ? "After finishing recording you will be prompted to add note page"
                      : "",
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  color: AppColor.kNeutral600,
                ),
              ],
            ),
          ),
        ));
  }
}
