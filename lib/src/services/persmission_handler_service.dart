import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  static Future<bool> getMicrophonePermission() async {
    try {
      PermissionStatus grantPermission = await Permission.microphone.request();

      bool isGranted = grantPermission == PermissionStatus.granted;

      if (isGranted == false &&
          grantPermission == PermissionStatus.permanentlyDenied) {
        await openAppSettings();
      }

      return isGranted;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
