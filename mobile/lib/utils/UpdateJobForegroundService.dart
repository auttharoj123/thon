// import 'dart:isolate';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// class ForegroundTask {
//   static const String TASK_ID = 'my_foreground_task';
//   static const String TASK_NAME = 'My Foreground Task';
//   static const String TASK_TEXT = 'Running my foreground task';

//   Isolate? _isolate;
//   SendPort? _sendPort;

//   Future<void> start() async {
//     if (_isolate != null) {
//       return;
//     }

//     final callbackHandle = PluginUtilities.getCallbackHandle(_isolateMain)!;
//     await FlutterForegroundTask.initialize(TASK_ID, TASK_NAME, TASK_TEXT);
//     _isolate = await Isolate.spawn(_isolateMain, callbackHandle.toRawHandle());
//   }

//   Future<void> stop() async {
//     if (_isolate == null) {
//       return;
//     }

//     _sendPort!.send('stop');
//     await FlutterForegroundTask.stop();
//     _isolate!.kill();
//     _isolate = null;
//   }

//   static void _isolateMain(int callbackHandle) {
//     final port = ReceivePort();
//     final sendPort = IsolateNameServer.lookupPortByName(TASK_ID);
//     sendPort!.send(port.sendPort);
//     final callback = PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(callbackHandle))!;
//     port.listen((message) {
//       if (message == 'stop') {
//         return;
//       }
//       final result = callback(message);
//       sendPort.send(result);
//     });
//   }

//   Future<dynamic> run(Function callback) async {
//     if (_isolate == null) {
//       throw Exception('Foreground task is not running');
//     }

//     final completer = Completer<dynamic>();
//     final receivePort = ReceivePort();
//     _sendPort = await IsolateNameServer.lookupPortByName(TASK_ID);
//     _sendPort!.send(receivePort.sendPort);
//     receivePort.listen((message) {
//       completer.complete(message);
//     });
//     _sendPort!.send(callback);
//     return completer.future;
//   }
// }

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class UpdateJobForegroundService {
  static Function? _callback;
  static ReceivePort? _receivePort;

  static Future<void> initlizeForegroundTask(Function? callback) async {
    _callback = callback;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        // interval: 10000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<bool> startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    // if (!await FlutterForegroundTask.canDrawOverlays) {
    //   final isGranted =
    //       await FlutterForegroundTask.openSystemAlertWindowSettings();
    //   if (!isGranted) {
    //     print('SYSTEM_ALERT_WINDOW permission denied!');
    //     return false;
    //   }
    // }

    // You can save data using the saveData function.
    //await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Send job Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: _callback,
      );
    }
  }

  static Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  static bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is int) {
        // print('eventCount: $message');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          //Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (message is DateTime) {
        // print('timestamp: ${message.toString()}');
      }
    });

    return _receivePort != null;
  }

  static void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  // T? _ambiguate<T>(T? value) => value;
}
