import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

class FocusModeService {
  static const platform = MethodChannel('com.zenith.app/focus_mode');

  Future<List<String>> getFocusModes() async {
    if (Platform.isAndroid) {
      try {
        final List<dynamic> result = await platform.invokeMethod('getFocusModes');
        return result.cast<String>();
      } on PlatformException catch (e) {
        print("Failed to get focus modes: '${e.message}'.");
        return [];
      }
    } else if (Platform.isIOS) {
      try {
        final List<dynamic> result = await platform.invokeMethod('getFocusModes');
        return result.cast<String>();
      } on PlatformException catch (e) {
        print("Failed to get focus modes: '${e.message}'.");
        return [];
      }
    }
    return [];
  }

  Future<bool> get isNotificationPermissionGranted async {
    return await Permission.notification.isGranted;
  }
}
