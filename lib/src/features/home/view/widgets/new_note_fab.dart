import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app/colors.dart';
import '../../../../core/app/dimensions.dart';
import '../../../../core/states/states.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text.dart';

class SitesFab extends StatefulWidget {
  final Function()? onPressed;
  final String? tooltip;
  final IconData? icon;

  const SitesFab({super.key, this.onPressed, this.tooltip, this.icon});

  @override
  State<SitesFab> createState() => _SitesState();
}

class _SitesState extends State<SitesFab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double?> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 44.0;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: AppColor.primaryColor,
      end: AppColor.primaryColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate({Function()? callback}) {
    if (!(isFABOpened.value)) {
      _animationController.forward();
      isScreenBlurred.value = true;
    } else {
      if (callback != null) callback;

      _animationController.reverse().then(
        (value) {
          isScreenBlurred.value = false;
        },
      );
    }
    isFABOpened.value = !isFABOpened.value;
  }

  Widget voiceRecord() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ValueListenableBuilder(
          valueListenable: isFABOpened,
          builder: (context, value, child) => value
              ? Opacity(
                  opacity: _animateIcon.value,
                  child: CustomText.ourText(
                    "Voice Record",
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColor.kNeutral800,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        hSizedBox1,
        Container(
          decoration: BoxDecoration(
            color: AppColor.kGreenMain,
            shape: BoxShape.circle,
            boxShadow: isScreenBlurred.value == true
                ? [
                    BoxShadow(
                      color: AppColor.kBlueMain.withOpacity(0.72),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: CustomButton.customIconButton(
            height: 44,
            width: 44,
            backgroundColor: AppColor.kBlueMain,
            onPressed: () {
              print("object voice note");
              // animate(
              //   callback: navigatePushNamed(
              //       context, RouteConfigName.materialPurchaseScreenRouteName),
              // );
            },
            icon: Icon(
              CupertinoIcons.mic,
              color: AppColor.kWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget addNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ValueListenableBuilder(
          valueListenable: isFABOpened,
          builder: (context, value, child) => value
              ? Opacity(
                  opacity: _animateIcon.value,
                  child: CustomText.ourText(
                    "Add Note",
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColor.kNeutral800,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        hSizedBox1,
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isScreenBlurred.value == true
                ? [
                    BoxShadow(
                      color: AppColor.kBlueMain.withOpacity(0.72),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: CustomButton.customIconButton(
            height: 44,
            width: 44,
            backgroundColor: AppColor.kBlueMain,
            onPressed: () => isFABOpened.value = false,
            icon: Icon(
              Icons.note_add_outlined,
              color: AppColor.kWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget viewDetailsFab() {
    return GestureDetector(
      onTap: () {
        animate();
      },
      child: Container(
        padding: screenPadding,
        height: 56,
        decoration: BoxDecoration(
          color: AppColor.kGreenMain,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.kNeutral100.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: AnimatedBuilder(
          builder: (context, child) {
            // return child ?? Container();
            return FittedBox(
              child: Transform.rotate(
                angle: _animateIcon.value == 0.0
                    ? 0
                    : pi / (_animateIcon.value * 4),
                child: child,
              ),
            );
          },
          animation: _animateIcon,
          child: const Icon(
            CupertinoIcons.add,
            color: AppColor.kBlueLightest,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isScreenBlurred,
      builder: (context, isBlurred, child) => Container(
        color: isBlurred ? AppColor.kWhite.withOpacity(0.6) : null,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isBlurred ? 20 : 0,
            sigmaY: isBlurred ? 20 : 0,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // First sub FAB
                // First sub FAB
                Transform(
                  transform: Matrix4.translationValues(
                    -6, // No horizontal offset
                    isFABOpened.value
                        ? -(_fabHeight * 1.8)
                        : 0.0, // Control vertical movement
                    0.0,
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isFABOpened.value ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !isFABOpened.value,
                      child: addNote(),
                    ),
                  ),
                ),

// Second sub FAB
                Transform(
                  transform: Matrix4.translationValues(
                    -6, // No horizontal offset
                    isFABOpened.value
                        ? -(_fabHeight * 3.2)
                        : 0.0, // Control vertical movement
                    0.0,
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isFABOpened.value ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !isFABOpened.value,
                      child: voiceRecord(),
                    ),
                  ),
                ),

                // Main FAB
                viewDetailsFab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
