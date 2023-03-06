import 'dart:isolate';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/managers/JobSyncManager.dart';
import 'package:slpod/utils/UpdateJobForegroundService.dart';

import '../models/NonUpdatedJob.dart';

class UpdateJobTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  bool _isUploading = false;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // if (_eventCount == 3) {
    //   _eventCount = 0;

    //   return;
    // }
    try {
      if (!_isUploading) {
        _isUploading = true;
        await JobSyncManager.syncNonUpdatedJob();

        // Send data to the main isolate.
        // sendPort?.send(_eventCount);

        _isUploading = false;
        await UpdateJobForegroundService.stopForegroundTask();
        // _eventCount++;
      }
    } catch (e) {
      _isUploading = false;
      await UpdateJobForegroundService.stopForegroundTask();
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}
