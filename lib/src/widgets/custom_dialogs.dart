import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_note/src/providers/image_provider/image_provider.dart';
import 'package:smart_note/src/widgets/custom_button.dart';
import 'package:smart_note/src/widgets/custom_network_image_widget.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../core/routing/route_navigation.dart';
import '../core/states/states.dart';
import 'custom_text.dart';

class CustomDialogs {
  static void cancelDialog(context) {
    back(context);
  }

  static fullLoadingDialog({String? data, required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xff141A31).withOpacity(0.3),
      barrierLabel: data ?? "Loading...",
      pageBuilder: (context, anim1, anim2) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        AppColor.kWhite,
                      ),
                    ),
                  ),
                  vSizedBox0,
                  Text(
                    data ?? "Loading...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showExtractedTextDialog({
    required BuildContext context,
    bool? isLocal = false,
    String? imageUrl,
    String? extractedText,
    TextEditingController? textEditingController,
  }) async {
    showDialog(
        context: context,
        builder: (_) {
          return PopScope(
            canPop: true,
            child: Dialog(
              elevation: 0.0,
              // insetPadding: const EdgeInsets.symmetric(
              //   horizontal: 50,
              //   vertical: 100,
              // ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSizedBox0andHalf,
                    CustomText.ourText("Image To Text Preview",
                        fontSize: 18, fontWeight: FontWeight.w600),
                    vSizedBox1andHalf,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomText.ourText(
                              extractedText,
                              maxLines: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    vSizedBox1andHalf,
                    CustomButton.elevatedButton(
                      "Confirm",
                      () {
                        textEditingController?.text = extractedText ?? "";
                        back(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showVoiceRecordDialog({
    required BuildContext context,
    bool? isLocal = false,
    String? imageUrl,
  }) async {
    showDialog(
        context: context,
        builder: (_) {
          return PopScope(
            canPop: true,
            child: Dialog(
              elevation: 0.0,
              // insetPadding: const EdgeInsets.symmetric(
              //   horizontal: 50,
              //   vertical: 100,
              // ),
              backgroundColor: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: isVoiceRecording,
                builder: (context, value, child) => GestureDetector(
                  onTap: () => isVoiceRecording.value = !isVoiceRecording.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (value) ...[
                        CustomText.ourText(
                          "Tap to Stop!",
                          fontWeight: FontWeight.w600,
                          color: AppColor.kWhite,
                          fontSize: 18,
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
                      CustomText.ourText(
                        value
                            ? "After finishing recording you will be prompted to add note page"
                            : "",
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: AppColor.kWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showImageDialog({
    required BuildContext context,
    bool? isLocal = false,
    String? imageUrl,
  }) async {
    showDialog(
        context: context,
        builder: (_) {
          return PopScope(
            canPop: true,
            child: Dialog(
              elevation: 0.0,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 100,
              ),
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        isLocal ?? false
                            ? InteractiveViewer(
                                clipBehavior: Clip.none,
                                child: Image.file(File(imageUrl ?? "")))
                            : imageUrl != null
                                ? InteractiveViewer(
                                    clipBehavior: Clip.none,
                                    child: CustomNetworkImage(
                                      isAutoHeight: true,
                                      imageUrl: imageUrl,
                                      width: appWidth(context),
                                      boxFit: BoxFit.contain,
                                    ),
                                  )
                                : Container(),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              back(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: AppColor.kRedMain,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static imageBottomSheet({
    required BuildContext context,
    XFile? pickedImage,
    required int imageIndex,
    required WidgetRef ref,
    bool? isMultiImage,
  }) {
    final imagePicker = ref.read(imagePickerProvider);
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        builder: (_) {
          return Container(
            padding: screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                vSizedBox2,
                CustomButton.elevatedButton(
                  "Choose from gallery",
                  () async {
                    back(context);
                    imagePicker.pickImage(
                      source: 1,
                      imageIndex: imageIndex,
                      ref: ref,
                      isMultiImage: imageIndex == 1,
                    );
                  },
                ),
                vSizedBox1andHalf,
                CustomButton.elevatedButton(
                  "Take Photo",
                  () async {
                    back(context);
                    imagePicker.pickImage(
                      source: 0,
                      imageIndex: imageIndex,
                      ref: ref,
                    );
                  },
                ),
                vSizedBox2,
              ],
            ),
          );
        });
  }
}
