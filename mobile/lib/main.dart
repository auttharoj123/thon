/*
* File : Main File
* Version : 1.0.0
* */

// import 'package:slpod/homes/homes_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/handler/UpdateJobTaskHandler.dart';
import 'package:slpod/localizations/app_localization_delegate.dart';
import 'package:slpod/localizations/language.dart';
import 'package:slpod/repositories/job_repostitory.dart';
import 'package:slpod/theme/app_notifier.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/utils/UpdateJobForegroundService.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/Admin/AdminTabMainScreenPage.dart';
import 'package:slpod/views/JobDetailScreenPage.dart';
import 'package:slpod/views/LoginScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slpod/views/RootScreenPage.dart';
import 'package:slpod/views/SendJobScreenPage.dart';
import 'package:slpod/views/SplashScreenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(UpdateJobTaskHandler());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await UpdateJobForegroundService.initlizeForegroundTask(startCallback);
      await UpdateJobForegroundService.startForegroundTask();
    } catch (err) {
      throw Exception(err);
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UpdateJobForegroundService.initlizeForegroundTask(startCallback);
  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  prefs.setString('fcmToken', fcmToken ?? "");

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: ChangeNotifierProvider<FxAppThemeNotifier>(
      create: (context) => FxAppThemeNotifier(),
      child: SLApp(),
    ),
  ));
}

class SLApp extends StatefulWidget {
  SLApp({Key? key}) : super(key: key);

  @override
  State<SLApp> createState() => _SLAppState();
}

class _SLAppState extends State<SLApp> {
  late AppController _controller;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    var prefs = await SharedPreferences.getInstance();
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceData["platform"] = "Android";
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        deviceData["platform"] = "IOS";
      }

      if (prefs.getString("deviceId") == null) {
        prefs.setString("deviceId", Uuid.v4().toString());
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      deviceData["packageInfo.appName"] = packageInfo.appName;
      deviceData["packageInfo.packageName"] = packageInfo.packageName;
      deviceData["packageInfo.version"] = packageInfo.version;
      deviceData["packageInfo.buildNumber"] = packageInfo.buildNumber;
      deviceData["app.version"] = SLAppl.VERSION;

      prefs.setString("deviceInfo", jsonEncode(deviceData));
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      // 'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      // 'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      // 'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      // 'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    super.initState();
    _controller = FxControllerStore.putOrFind(AppController());
    _handleLocationPermission();
    initPlatformState();
  }

  @override
  void dispose() {
    // _closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AppController>(
        controller: _controller,
        builder: (context) {
          return Consumer<AppNotifier>(
            builder: (BuildContext context, AppNotifier value, Widget? child) {
              return MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.theme,
                builder: (context, child) {
                  return Directionality(
                    textDirection: AppTheme.textDirection,
                    child: child!,
                  );
                },
                localizationsDelegates: [
                  AppLocalizationsDelegate(context),
                  // Add this line
                  // GlobalMaterialLocalizations.delegate,
                  // GlobalWidgetsLocalizations.delegate,
                  // GlobalCupertinoLocalizations.delegate,
                ],
                routes: {
                  '/': (context) => RootScreenPage(),
                  '/login': (context) => LoginScreenPage(),
                  // '/home': (context) => HomesScreen(),
                  '/job_detail': (context) => JobDetailScreenPage(),
                  '/pre_initialize': (context) => LoadingScreenPage(),
                  '/admin_home': (context) => AdminTabMainScreenPage(),
                  '/send_job': (context) => SendJobScreenPage(),
                  // '/driver_home': (context) => TabMainScreenPage(),
                },
                supportedLocales: Language.getLocales(),
              );
            },
          );
        });
  }
}
