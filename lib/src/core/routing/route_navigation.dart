import 'package:flutter/material.dart';

back(BuildContext context, [dynamic result]) {
  Navigator.pop(context, result);
}

navigate(BuildContext context, dynamic pageRoute, {bool isFullDialog = false}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: ((context) => pageRoute),
      fullscreenDialog: isFullDialog,
    ),
  );
}

navigateNamed(BuildContext context, String routeName, {dynamic arguments}) {
  Navigator.pushNamed(
    context,
    routeName,
    arguments: arguments,
  );
}

navigateAsyncNamed(BuildContext context, String routeName,
    {dynamic arguments, Function()? returnBackFunction}) async {
  bool? value =
      await Navigator.pushNamed(context, routeName, arguments: arguments);
  if (value == true) returnBackFunction;
}

navigateOffAllNamed(BuildContext context, String routeName,
    {Object? args, bool isFullDialog = false}) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    routeName,
    (route) => false,
    arguments: args,
  );
}

navigateOffAll(
  BuildContext context,
  dynamic routeName, {
  Object? args,
  bool isFullDialog = false,
}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: ((context) => routeName),
        fullscreenDialog: isFullDialog,
      ),
      (route) => false);
}

navigateOff(BuildContext context, Widget page, {bool isFullDialog = false}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: ((context) => page),
      fullscreenDialog: isFullDialog,
    ),
  );
}

navigateOffNamed(BuildContext context, String routeName,
    {Object? args, bool isFullDialog = false}) {
  Navigator.pushReplacementNamed(
    context,
    routeName,
    arguments: args,
  );
}

void navigateAsync(BuildContext context, Widget Function() pageBuilder,
    {bool isFullDialog = false}) {
  Future<void>.delayed(
    Duration.zero,
    () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageBuilder(),
          fullscreenDialog: isFullDialog,
        ),
      );
    },
  );
}
