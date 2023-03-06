/*
* File : Main File
* Version : 1.0.0
* */

// import 'package:slpod/homes/homes_screen.dart';
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/handler/UpdateJobTaskHandler.dart';
import 'package:slpod/homes/homes_screen.dart';
import 'package:slpod/localizations/app_localization_delegate.dart';
import 'package:slpod/localizations/language.dart';
import 'package:slpod/theme/app_notifier.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/utils/UpdateJobForegroundService.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/Admin/AdminTabMainScreenPage.dart';
import 'package:slpod/views/Driver/TabMainScreenPage.dart';
import 'package:slpod/views/JobDetailScreenPage.dart';
import 'package:slpod/views/LoginScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:slpod/views/RootScreenPage.dart';
import 'package:slpod/views/SendJobScreenPage.dart';
import 'package:slpod/views/SplashScreenPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(UpdateJobTaskHandler());
}

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await UpdateJobForegroundService.initlizeForegroundTask(startCallback);

  AppTheme.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final fcmToken = await FirebaseMessaging.instance.getToken();

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

  @override
  void initState() {
    super.initState();
    _controller = FxControllerStore.putOrFind(AppController());
    _handleLocationPermission();
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
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routes: {
                  '/': (context) => RootScreenPage(),
                  '/login': (context) => LoginScreenPage(),
                  '/home': (context) => HomesScreen(),
                  '/job_detail': (context) => JobDetailScreenPage(),
                  '/pre_initialize': (context) => LoadingScreenPage(),
                  '/admin_home': (context) => AdminTabMainScreenPage(),
                  '/send_job': (context) => SendJobScreenPage(),
                  '/driver_home': (context) => TabMainScreenPage(),
                },
                supportedLocales: Language.getLocales(),
              );
            },
          );
        });
  }
}
