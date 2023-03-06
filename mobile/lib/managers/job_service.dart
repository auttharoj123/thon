// import 'dart:isolate';

// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// class JobForegroundService {
//   static void initForegroundTask() {
//     FlutterForegroundTask.init(
//       androidNotificationOptions: AndroidNotificationOptions(
//         channelId: 'notification_channel_id',
//         channelName: 'Foreground Notification',
//         channelDescription:
//             'This notification appears when the foreground service is running.',
//         channelImportance: NotificationChannelImportance.LOW,
//         priority: NotificationPriority.LOW,
//         iconData: const NotificationIconData(
//           resType: ResourceType.mipmap,
//           resPrefix: ResourcePrefix.ic,
//           name: 'launcher',
//           backgroundColor: Colors.orange,
//         ),
//         buttons: [
//           const NotificationButton(id: 'sendButton', text: 'Send'),
//           const NotificationButton(id: 'testButton', text: 'Test'),
//         ],
//       ),
//       iosNotificationOptions: const IOSNotificationOptions(
//         showNotification: true,
//         playSound: false,
//       ),
//       foregroundTaskOptions: const ForegroundTaskOptions(
//         interval: 5000,
//         isOnceEvent: false,
//         autoRunOnBoot: true,
//         allowWakeLock: true,
//         allowWifiLock: true,
//       ),
//     );
//   }

//   static Future<bool> startForegroundTask() async {
//     // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//     // onNotificationPressed function to be called.
//     //
//     // When the notification is pressed while permission is denied,
//     // the onNotificationPressed function is not called and the app opens.
//     //
//     // If you do not use the onNotificationPressed or launchApp function,
//     // you do not need to write this code.
//     // if (!await FlutterForegroundTask.canDrawOverlays) {
//     //   final isGranted =
//     //       await FlutterForegroundTask.openSystemAlertWindowSettings();
//     //   if (!isGranted) {
//     //     print('SYSTEM_ALERT_WINDOW permission denied!');
//     //     return false;
//     //   }
//     // }

//     // You can save data using the saveData function.
//     await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

//     // Register the receivePort before starting the service.
//     final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
//     final bool isRegistered = _registerReceivePort(receivePort);
//     if (!isRegistered) {
//       print('Failed to register receivePort!');
//       return false;
//     }

//     if (await FlutterForegroundTask.isRunningService) {
//       return FlutterForegroundTask.restartService();
//     } else {
//       return FlutterForegroundTask.startService(
//         notificationTitle: 'Foreground Service is running',
//         notificationText: 'Tap to return to the app',
//         callback: startCallback,
//       );
//     }
//   }

//   ReceivePort? _receivePort;

//   Future<bool> _stopForegroundTask() {
//     return FlutterForegroundTask.stopService();
//   }

//   bool _registerReceivePort(ReceivePort? newReceivePort) {
//     if (newReceivePort == null) {
//       return false;
//     }

//     _closeReceivePort();

//     _receivePort = newReceivePort;
//     _receivePort?.listen((message) {
//       if (message is int) {
//         print('eventCount: $message');
//       } else if (message is String) {
//         if (message == 'onNotificationPressed') {
//           // Navigator.of(context).pushNamed('/resume-route');
//         }
//       } else if (message is DateTime) {
//         print('timestamp: ${message.toString()}');
//       }
//     });

//     return _receivePort != null;
//   }

//   void _closeReceivePort() {
//     _receivePort?.close();
//     _receivePort = null;
//   }
// }
