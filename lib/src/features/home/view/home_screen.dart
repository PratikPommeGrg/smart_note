import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_note/src/core/app/dimensions.dart';
import 'package:smart_note/src/core/app/texts.dart';
import 'package:smart_note/src/core/configs/route_config.dart';
import 'package:smart_note/src/core/routing/route_navigation.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/features/home/widgets/new_note_fab.dart';
import 'package:smart_note/src/widgets/custom_network_image_widget.dart';

import '../../../core/app/colors.dart';
import '../../../widgets/custom_text.dart';

const String ppLink =
    "https://i.pinimg.com/236x/13/15/50/13155027fb68a268abe90b4b04d52aa5.jpg";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          toolbarHeight: 64,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.ourText(
                appName,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColor.kNeutral800,
              ),
              // Icon(
              //   Icons.more_vert_sharp,
              //   color: AppColor.kNeutral800,
              // )
              Row(
                children: [
                  GestureDetector(
                      onTap: () =>
                          navigateNamed(context, RouteConfig.voiceRecordScreen),
                      child: const Icon(Icons.voice_chat)),
                  hSizedBox1,
                  Container(
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
                ],
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: index == 1
                            ? AppColor.kBlueMain
                            : AppColor.kBlueLighter,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomText.ourText(
                        noteCategories[index],
                        color: index == 1 ? AppColor.kNeutral700 : null,
                        fontWeight: index == 1 ? FontWeight.w500 : null,
                      ),
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
                          child: BackGroundTile(
                              backgroundColor: generateRandomColor()),
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
        floatingActionButton: const SitesFab()
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {},
        //   label: Row(
        //     children: [
        //       const Icon(CupertinoIcons.add),
        //       hSizedBox0andHalf,
        // CustomText.ourText(
        //   "New Note",
        //   color: AppColor.kNeutral800,
        //   fontWeight: FontWeight.w500,
        // ),
        //     ],
        //   ),
        //   elevation: 4,
        //   backgroundColor: AppColor.kBlueLighter,
        // ),
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
