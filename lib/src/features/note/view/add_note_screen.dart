import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/features/note/models/note_model.dart';
import 'package:smart_note/src/features/note/models/note_options_model.dart';
import 'package:smart_note/src/providers/image_provider/image_provider.dart';
import 'package:smart_note/src/providers/image_to_text_provider/image_to_text_provider.dart';
import 'package:smart_note/src/services/local_storage_service.dart';
import 'package:smart_note/src/widgets/custom_dialogs.dart';
import 'package:smart_note/src/widgets/custom_text.dart';
import 'package:smart_note/src/widgets/custom_text_form_field_widget.dart';

import '../../../core/states/states.dart';

class AddNoteScreen extends ConsumerWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachedImagesProvider = ref.watch(attachedImageProvider);
    // final scannedImageProvider = ref.watch(scanImageProvider);
    // final imageToTextState = ref.watch(imageToTextProvider);
    final localStorageService = ref.watch(localStorageServiceProvider);

    ref.listen(imageToTextProvider, (previous, next) {
      if (next.status == ImageToTextStateStatus.loading) {
        CustomDialogs.fullLoadingDialog(context: context);
      }
      if (next.status == ImageToTextStateStatus.failure) {
        back(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Processing Image Failed'),
            backgroundColor: AppColor.kRedMain,
          ),
        );
      }
      if (next.status == ImageToTextStateStatus.success) {
        back(context);
        CustomDialogs.showExtractedTextDialog(
          context: context,
          extractedText: next.extractedText,
          textEditingController: noteController,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async {
                localStorageService.insertToTable(
                  NoteModel(
                    title: "test",
                    note: "test note",
                    category: noteCategories[3],
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.kNeutral800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText.ourText(
                  "Save",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.kWhite,
                ),
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(),
        child: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              ref.read(imagePickerProvider).resetImage(ref);
              noteController.clear();
              titleController.clear();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: screenLeftRightPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox1andHalf,
                  CustomText.ourText(
                    "Title:",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  vSizedBox0andHalf,
                  CustomTextFormField(
                    controller: titleController,
                  ),
                  vSizedBox1andHalf,
                  CustomText.ourText(
                    "Write Note:",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  vSizedBox0andHalf,
                  CustomTextFormField(
                    minLine: 15,
                    maxLine: 15,
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: noteController,
                  ),
                  vSizedBox1andHalf,
                  if (attachedImagesProvider.isNotEmpty) ...[
                    Row(
                      children: [
                        Transform.rotate(
                            angle: pi / -3,
                            child: const Icon(Icons.attachment_rounded)),
                        CustomText.ourText(
                          "Attached Images:",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    vSizedBox0andHalf,
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: attachedImagesProvider.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            CustomDialogs.showImageDialog(
                              context: context,
                              imageUrl: attachedImagesProvider[index].path,
                              isLocal: true,
                            );
                          },
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 80,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: appHeight(context),
                                  width: appWidth(context),
                                  child: Image.file(
                                    File(attachedImagesProvider[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(imagePickerProvider)
                                          .removeImage(index, ref);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.kWhite,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: AppColor.kNeutral800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  vSizedBox1andHalf,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          // height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: noteOptions
                .map(
                  (e) => InkWell(
                    onTap: () {
                      if (e.title.toLowerCase() == "voice") {
                        CustomDialogs.showVoiceRecordDialog(context: context);
                      }
                      if (e.title.toLowerCase() == "scan") {
                        CustomDialogs.imageBottomSheet(
                          context: context,
                          imageIndex: 0,
                          ref: ref,
                        );
                      }
                      if (e.title.toLowerCase() == "attach") {
                        CustomDialogs.imageBottomSheet(
                          context: context,
                          imageIndex: 1,
                          ref: ref,
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                  color: AppColor.kNeutral100,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: SvgPicture.asset(
                                e.icon,
                                height: 20,
                                width: 20,
                              )),
                          CustomText.ourText(
                            e.title,
                            fontSize: 12,
                            color: AppColor.kWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
