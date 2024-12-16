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
import 'package:smart_note/src/services/local_storage_service.dart';
import 'package:smart_note/src/widgets/custom_network_image_widget.dart';
import 'package:smart_note/src/widgets/custom_snackbar.dart';

import '../../../core/app/colors.dart';
import '../../../widgets/custom_text.dart';

part 'widgets/categories_list.dart';
part 'widgets/note_card.dart';

const String ppLink =
    "https://i.pinimg.com/236x/13/15/50/13155027fb68a268abe90b4b04d52aa5.jpg";

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      ref.read(localStorageServiceProvider).closeDatabase();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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
          ref.read(notesProvider.notifier).getNotes(
                showLoadingIndicator: false,
                getByCategory: selectedCategory.value != "All",
              );
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
          color: AppColor.kNeutral300,
        ))),
        child: Padding(
          padding: screenLeftRightPadding,
          child: Column(
            children: [
              vSizedBox1andHalf,
              CategoriesList(noteCategories: noteCategories, ref: ref),
              vSizedBox1andHalf,
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
              vSizedBox1andHalf,
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
                                        height: 200,
                                        width: 200,
                                      ),
                                      CustomText.ourText(
                                        "No Notes Found",
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
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 8,
                                  children: List.generate(
                                    allNotes.notes.length,
                                    (index) => StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount:
                                          allNotes.notes[index].cardSize ?? 1,
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
                                        child: noteCard(
                                          note: allNotes.notes[index],
                                          ref: ref,
                                          context: context,
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
              color: AppColor.kWhite,
            ),
            hSizedBox0andHalf,
            CustomText.ourText(
              "New Note",
              fontWeight: FontWeight.w600,
              color: AppColor.kWhite,
            ),
          ],
        ),
        elevation: 4,
      ),
    );
  }
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.pencil),
              title: CustomText.ourText(
                "Edit Note",
                fontWeight: FontWeight.w500,
              ),
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
              title: CustomText.ourText(
                "Delete Note",
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                back(context);
                ref.read(notesProvider.notifier).deleteNote(noteId);
              },
            ),
          ],
        ),
      );
    },
  );
}
