import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/app/texts.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/services/local_storage_service.dart';
import 'package:smart_note/src/widgets/custom_network_image_widget.dart';

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

  }

  @override
  Widget build(BuildContext context) {
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
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => hSizedBox0andHalf,
                  itemCount: noteCategories.length,
                  itemBuilder: (context, index) => Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColor.secondaryColor
                          : AppColor.tertiaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText.ourText(
                      noteCategories[index],
                      color: index == 0 ? AppColor.kWhite : null,
                      fontWeight: index == 0 ? FontWeight.w600 : null,
                    ),
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
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: List.generate(
                      10,
                      (index) => StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: generateMaxAxisCellCount(),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          onLongPress: () {
                            _showNoteOptions(
                              context,
                            );
                          },
                          child: BackGroundTile(
                              backgroundColor: generateRandomColor()),
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

  const BackGroundTile({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
    );
  }
}

Color generateRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha (fully opaque)
    random.nextInt(256), // Red (0-255)
    random.nextInt(256), // Green (0-255)
    random.nextInt(256), // Blue (0-255)
  );
}

num generateMaxAxisCellCount() {
  final Random random = Random();
  List<num> choices = [0.8, 1.0, 1.3];
  return choices[random.nextInt(choices.length)];
}

void _showNoteOptions(BuildContext context) {
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
              // _showDeleteConfirmationDialog(context, noteIndex);
            },
          ),
        ],
      );
    },
  );
}
