import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_note/src/core/app/colors.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/app/medias.dart';
import 'package:smart_note/src/core/app/texts.dart';
import 'package:smart_note/src/core/enums/enums.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/features/note/models/note_options_model.dart';
import 'package:smart_note/src/providers/image_provider/image_provider.dart';
import 'package:smart_note/src/providers/image_to_text_provider/image_to_text_provider.dart';
import 'package:smart_note/src/providers/notes_provider/notes_provider.dart';
import 'package:smart_note/src/providers/notes_provider/single_note_provider.dart';
import 'package:smart_note/src/providers/text_to_speech_provider/text_to_speech_provider.dart';
import 'package:smart_note/src/widgets/custom_dialogs.dart';
import 'package:smart_note/src/widgets/custom_snackbar.dart';
import 'package:smart_note/src/widgets/custom_text.dart';
import 'package:smart_note/src/widgets/custom_text_form_field_widget.dart';

class AddNoteScreen extends ConsumerWidget {
  const AddNoteScreen({super.key, this.isForEdit = false});

  final bool? isForEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attachedImagesProviderService = ref.watch(attachedImageProvider);
    final textToImageProviderService = ref.watch(textToSpeechProvider);

    bool isSaving = false;

    ref.listen(imageToTextProvider, (previous, next) {
      if (next.status == ImageToTextStateStatus.loading) {
        CustomDialogs.fullLoadingDialog(context: context);
      }
      if (next.status == ImageToTextStateStatus.failure) {
        back(context);
        CustomSnackbar.showSnackBar(
            context: context,
            message: "Failed to process image",
            isSuccess: false);
      }
      if (next.status == ImageToTextStateStatus.success) {
        back(context);
        CustomDialogs.showExtractedTextDialog(
          context: context,
          extractedText: next.extractedText,
          textEditingController:
              ref.read(notesProvider.notifier).noteController,
        );
      }
    });

    ref.listen(notesProvider, (previous, next) {
      if (next.status == NotesStateStatus.addNoteLoading) {
        CustomDialogs.fullLoadingDialog(context: context, data: next.message);
      }
      if (next.status == NotesStateStatus.addNoteFailure) {
        back(context);
        CustomSnackbar.showSnackBar(
            context: context, message: next.message ?? '', isSuccess: false);
      }
      if (next.status == NotesStateStatus.addNoteSuccess) {
        ref.read(notesProvider.notifier).getNotes();
        back(context);
        back(context);
        CustomSnackbar.showSnackBar(
            context: context, message: next.message ?? '');
      }
    });

    ref.listen(
      singleNoteProvider,
      (previous, next) {
        if (next.status == SingleNoteProviderStatus.editNoteLoading) {
          CustomDialogs.fullLoadingDialog(context: context);
        }
        if (next.status == SingleNoteProviderStatus.editNoteFailure) {
          back(context);
          CustomSnackbar.showSnackBar(
              context: context, message: next.message ?? '');
        }
        if (next.status == SingleNoteProviderStatus.editNoteSuccess) {
          back(context);
          back(context);
          ref.read(notesProvider.notifier).getNotes(
                getByCategory: (selectedCategory.value != "All"),
                showLoadingIndicator: false,
              );
          CustomSnackbar.showSnackBar(
              context: context, message: next.message ?? '');
        }
      },
    );

    ref.listen(
      textToSpeechProvider,
      (previous, next) {
        if (next.status == TextToSpeechStatus.failure) {
          CustomSnackbar.showSnackBar(
              context: context, message: next.message ?? '');
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async {
                if (isSaving == true) return;
                isSaving = true;
                hideKeyboard();
                await Future.delayed(const Duration(milliseconds: 700));
                if (ref
                    .read(notesProvider.notifier)
                    .noteFormKey
                    .currentState!
                    .validate()) {
                  if (ref.read(selectNoteCategoryProvider) == null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        CustomSnackbar.showSnackBar(
                          context: context,
                          message: "Please select a category!",
                          warningSnackBar: true,
                        );
                      },
                    );
                  } else {
                    isForEdit ?? false
                        ? await ref.read(singleNoteProvider.notifier).editNote()
                        : await ref.read(notesProvider.notifier).addNote();
                  }
                  isSaving = false;
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText.ourText(
                  isForEdit ?? false ? "Save" : "Add",
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
              ref.read(notesProvider.notifier).reset();
              ref
                  .read(selectNoteCategoryProvider.notifier)
                  .update((state) => null);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: screenLeftRightPadding,
              child: Form(
                key: ref.read(notesProvider.notifier).noteFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSizedBox1andHalf,
                    CustomText.ourText(
                      "Category:",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    vSizedBox0andHalf,
                    DropdownButton(
                      value: ref.watch(selectNoteCategoryProvider),
                      hint: CustomText.ourText(
                        "Select Category",
                        fontWeight: FontWeight.w500,
                        color: AppColor.kNeutral400,
                      ),
                      isExpanded: true,
                      enableFeedback: true,
                      dropdownColor: AppColor.kWhite,
                      items: NoteCategoryEnum.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: CustomText.ourText(
                                  e.name,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.kNeutral800,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(selectNoteCategoryProvider.notifier)
                              .update((state) => value);
                        }
                      },
                    ),
                    vSizedBox1andHalf,
                    CustomText.ourText(
                      "Title:",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    vSizedBox0andHalf,
                    CustomTextFormField(
                      controller:
                          ref.read(notesProvider.notifier).titleController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return emptyTextFormField;
                        }
                      },
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
                      controller:
                          ref.read(notesProvider.notifier).noteController,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return emptyTextFormField;
                        }
                      },
                    ),
                    vSizedBox1andHalf,
                    if (attachedImagesProviderService.isNotEmpty) ...[
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
                        itemCount: attachedImagesProviderService.length,
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
                                imageUrl:
                                    attachedImagesProviderService[index].path,
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
                                      File(attachedImagesProviderService[index]
                                          .path),
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
                    Container(
                      height: 80,
                      width: appWidth(context),
                      decoration: BoxDecoration(
                          color: AppColor.kBlueLighter,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all()),
                      padding: screenLeftRightPadding,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              ref
                                  .read(textToSpeechProvider.notifier)
                                  .textToSpeech(ref
                                      .read(notesProvider.notifier)
                                      .noteController
                                      .text);
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              size: 32,
                            ),
                          ),
                          hSizedBox1,
                          Expanded(
                            child: textToImageProviderService.status ==
                                    TextToSpeechStatus.success
                                ? FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: LottieBuilder.asset(
                                      kVoicePlayJson,
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                    ),
                                  )
                                : textToImageProviderService.status ==
                                        TextToSpeechStatus.loading
                                    ? CustomText.ourText(
                                        "Loading.................................................................",
                                        maxLines: 1,
                                        clipOverflow: true,
                                        fontWeight: FontWeight.w500,
                                      )
                                    : CustomText.ourText(
                                        "Click to Play Note in Voice",
                                        maxLines: 1,
                                        clipOverflow: true,
                                        fontWeight: FontWeight.w500,
                                      ),
                          ),
                        ],
                      ),
                    ),
                    vSizedBox1andHalf,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.secondaryColor,
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
