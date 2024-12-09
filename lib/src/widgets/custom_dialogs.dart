import 'dart:io';

import 'package:flutter/material.dart';

import '../core/app/colors.dart';
import '../core/app/dimensions.dart';
import '../core/routing/route_navigation.dart';
import 'custom_network_image_widget.dart';

class CustomDialogs {
  static void cancelDialog(context) {
    back(context);
  }

  // static fullLoadingDialog({String? data, BuildContext? context}) {
  //   showGeneralDialog(
  //     context: context ?? navigatorKey.currentContext!,
  //     barrierDismissible: false,
  //     barrierColor: const Color(0xff141A31).withOpacity(0.3),
  //     barrierLabel: data ?? loadingText,
  //     pageBuilder: (context, anim1, anim2) {
  //       return PopScope(
  //         canPop: false,
  //         child: Scaffold(
  //           backgroundColor: Colors.black.withOpacity(0.2),
  //           body: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Center(
  //                   child: CircularProgressIndicator(
  //                     valueColor: AlwaysStoppedAnimation(
  //                       AppColor.kPrimaryMain,
  //                     ),
  //                   ),
  //                 ),
  //                 vSizedBox0,
  //                 Text(
  //                   data ?? loadingText,
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 11,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                              color: AppColor.primaryColor,
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

  // static imageBottomSheet({
  //   required BuildContext context,
  //   XFile? pickedImage,
  //   required int source,
  //   required int imageIndex,
  // }) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       )),
  //       builder: (_) {
  //         return Container(
  //           padding: screenPadding,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               vSizedBox2,
  //               CustomButton.elevatedButton(
  //                 "Choose from gallery",
  //                 () async {
  //                   back(context);
  //                   sl.get<LocalImageCubits>().pickImage(source, imageIndex);
  //                 },
  //               ),
  //               vSizedBox2,
  //               CustomButton.elevatedButton(
  //                 "Take Photo",
  //                 () async {
  //                   back(context);
  //                   sl.get<LocalImageCubits>().pickImage(source, imageIndex);
  //                 },
  //               ),
  //               vSizedBox2,
  //             ],
  //           ),
  //         );
  //       });
  // }
}
