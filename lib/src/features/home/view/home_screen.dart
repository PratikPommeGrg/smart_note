import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/app/medias.dart';
import 'package:smart_note/src/core/app/texts.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/core/enums/enums.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/features/note/models/note_model.dart';
import 'package:smart_note/src/providers/notes_provider/notes_provider.dart';
import 'package:smart_note/src/widgets/custom_network_image_widget.dart';
import 'package:smart_note/src/widgets/custom_snackbar.dart';

import '../../../core/app/colors.dart';
import '../../../widgets/custom_text.dart';

const String ppLink =
    "https://i.pinimg.com/236x/13/15/50/13155027fb68a268abe90b4b04d52aa5.jpg";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(notesProvider.notifier).getNotes();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      notesProvider,
      (previous, next) {
        if (next.status == NotesStateStatus.deleteLoading) {}
        if (next.status == NotesStateStatus.failure) {
          CustomSnackbar.showSnackBar(
              context: context, message: next.message ?? '', isSuccess: false);
        }
        if (next.status == NotesStateStatus.deleteSuccess) {
          ref
              .read(notesProvider.notifier)
              .getNotes(showLoadingIndicator: false);
          CustomSnackbar.showSnackBar(
              context: context, message: next.message ?? '');
        }
      },
    );

    final allNotes = ref.watch(notesProvider);
    final noteCategories = NoteCategoryEnum.values.map((e) => e.name).toList()
      ..insert(0, "All");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.ourText(
              appName,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.kNeutral100,
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.kBlueLightest,
                ),
                child: const CustomNetworkImage(
                  imageUrl: ppLink,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: AppColor.kNeutral200,
        ))),
        child: Padding(
          padding: screenLeftRightPadding,
          child: Column(
            children: [
              vSizedBox1,
              SizedBox(
                height: 40,
                child: ValueListenableBuilder(
                  valueListenable: selectedCategory,
                  builder: (context, value, child) => ListView.separated(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => hSizedBox0andHalf,
                    itemCount: noteCategories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = value == noteCategories[index];
                      return InkWell(
                        onTap: () {
                          selectedCategory.value = noteCategories[index];
                          ref.read(notesProvider.notifier).getNotes(
                                getByCategory: noteCategories[index] !=
                                    "All",
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.secondaryColor
                                : AppColor.tertiaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomText.ourText(
                            noteCategories[index],
                            color: isSelected ? AppColor.kWhite : null,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              vSizedBox1,
              SearchBar(
                constraints: BoxConstraints(
                  minWidth: appWidth(context),
                  minHeight: 52,
                ),
                elevation: const WidgetStatePropertyAll(0),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                backgroundColor:
                    const WidgetStatePropertyAll(Colors.transparent),
                hintText: "Search Notes ...",
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColor.kNeutral400,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
                hintStyle: WidgetStatePropertyAll(TextStyle(
                  fontSize: 16,
                  color: AppColor.kNeutral600,
                  fontFamily: fontFamily,
                )),
                onTapOutside: (event) => hideKeyboard(),
                trailing: [
                  Icon(
                    CupertinoIcons.search,
                    color: AppColor.kNeutral500,
                  ),
                ],
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.only(
                    right: 16,
                    left: 8,
                  ),
                ),
              ),
              vSizedBox1,
              Expanded(
                child: allNotes.status == NotesStateStatus.loading &&
                        allNotes.showLoadingIndicator == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : allNotes.status == NotesStateStatus.failure
                        ? Center(
                            child: Text(
                              allNotes.message.toString(),
                            ),
                          )
                        : allNotes.notes.isEmpty &&
                                allNotes.status == NotesStateStatus.success
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    navigateNamed(
                                        context, RouteConfig.addNoteScreen);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 22,
                                    children: [
                                      SvgPicture.asset(
                                        kAddNoteSvg,
                                        height: 260,
                                        width: 260,
                                      ),
                                      CustomText.ourText(
                                        "Haven't added any notes yet,\n let's add one",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.kNeutral500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  children: List.generate(
                                    allNotes.notes.length,
                                    (index) => StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount:
                                          generateMaxAxisCellCount(),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        onLongPress: () {
                                          _showNoteOptions(
                                            context,
                                            ref,
                                            allNotes.notes[index].id ?? 0,
                                          );
                                        },
                                        child: BackGroundTile(
                                          backgroundColor: getCardColor(
                                              allNotes.notes[index].category),
                                          note: allNotes.notes[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
              ),
              vSizedBox1andHalf,
            ],
          ),
        ),
      ),
      // floatingActionButton: const SitesFab()
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColor.kNeutral300,
        onPressed: () {
          navigateNamed(context, RouteConfig.addNoteScreen);
        },
        label: Row(
          children: [
            Icon(
              CupertinoIcons.add,
              color: AppColor.kNeutral800,
            ),
            hSizedBox0andHalf,
            CustomText.ourText(
              "New Note",
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        elevation: 4,
      ),
    );
  }
}

class BackGroundTile extends StatelessWidget {
  final Color backgroundColor;
  final NoteModel? note;

  const BackGroundTile({super.key, required this.backgroundColor, this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: backgroundColor.withAlpha(160),
      color: backgroundColor,
      child: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            CustomText.ourText(
              note?.title.toUpperCase() ?? '',
              fontWeight: FontWeight.w600,
              color: AppColor.kNeutral800,
            ),
            CustomText.ourText(note?.note ?? ''),
          ],
        ),
      ),
    );
  }
}

Color getCardColor(String category) {
  return category == "Personal"
      ? AppColor.kPersonalColor
      : category == "Work"
          ? AppColor.kWorkColor
          : category == "Grocery"
              ? AppColor.kGroceryColor
              : category == "Travel"
                  ? AppColor.kTravelColor
                  : category == "Health"
                      ? AppColor.kHealthColor
                      : category == "Ideas"
                          ? AppColor.kIdeasColor
                          : AppColor.kNeutral100;
}

num generateMaxAxisCellCount() {
  final Random random = Random();
  List<num> choices = [0.8, 1.0, 1.3];
  return choices[random.nextInt(choices.length)];
}

void _showNoteOptions(
  BuildContext context,
  WidgetRef ref,
  int noteId,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (_) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.pencil),
            title: const Text("Edit Note"),
            onTap: () {
              back(context);
              // Navigate to edit screen or show edit dialog
              // navigateNamed(
              //   context,
              //   RouteConfig.editNoteScreen,
              //   arguments: {
              //     'noteIndex': noteIndex,
              //   },
              // );
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.trash),
            title: const Text("Delete Note"),
            onTap: () {
              back(context);
              ref.read(notesProvider.notifier).deleteNote(noteId);
            },
          ),
        ],
      );
    },
  );
}
