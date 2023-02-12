/*
* File : Main File
* Version : 1.0.0
* */

// import 'package:slpod/homes/homes_screen.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/homes/homes_screen.dart';
import 'package:slpod/localizations/app_localization_delegate.dart';
import 'package:slpod/localizations/language.dart';
import 'package:slpod/theme/app_notifier.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/Admin/AdminTabMainScreenPage.dart';
import 'package:slpod/views/Driver/TabMainScreenPage.dart';
import 'package:slpod/views/JobDetailScreenPage.dart';
import 'package:slpod/views/LoginScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:slpod/views/RootScreenPage.dart';
import 'package:slpod/views/SendJobScreenPage.dart';
import 'package:slpod/views/SplashScreenPage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(
        "Native called background task: Test"); //simpleTask will be emitted here.

    try {
      String? images = inputData!["images"] as String;
      List<String>? test = images.split(',');

      Map<String, String> headers = {
        "x-api-key": "2aed8b06-b9a1-4ae2-b1cd-849a3f15f686",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImxvZ2lubmFtZSI6InRlc3RfdXNlciIsInJvbGVzIjoiMTAsMTMsOSwxMiw1LDMsNCw4LDcsMiw2LDExLDE0LDEifSwiaWF0IjoxNjY5NjQxMTMxLCJleHAiOjE2NzIyMzMxMzF9.330ymw8iis_22BNxOCqaqR1DqpOdbECk5cQhgH30wqo"
      };
      var request = new http.MultipartRequest(
        "POST",
        Uri.http('192.168.1.109:3000', 'api/job/update-job'),
      );
      request.fields['user'] = 'blah';
      request.headers.addAll(headers);
      request.files.add(new http.MultipartFile.fromBytes(
          'images', await File(test[0]).readAsBytes(),
          filename: "test1.jpg", contentType: MediaType('image', 'jpeg')));

      var response = await request.send();
      response.stream.listen((value) {
        print(value.length);
      }).onDone(() {
        print("Test Done!!");
      });
    } catch (e) {
      print(e);
    }
    // .then((response) {

    // });

    // var client = http.Client();
    // var response = await client
    //     .send(http.Request('GET', Uri.parse('https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg')))//.post(Uri.http('192.168.1.109:3000', 'api/job/update-job'), headers: {
    //   'Content-Type': "application/json",
    //   'x-api-key': '2aed8b06-b9a1-4ae2-b1cd-849a3f15f686',
    //   'Authorization':
    //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImxvZ2lubmFtZSI6InRlc3RfdXNlciIsInJvbGVzIjoiMTAsMTMsOSwxMiw1LDMsNCw4LDcsMiw2LDExLDE0LDEifSwiaWF0IjoxNjY5NjQxMTMxLCJleHAiOjE2NzIyMzMxMzF9.330ymw8iis_22BNxOCqaqR1DqpOdbECk5cQhgH30wqo',
    // });

    // response.

    // var decodedResponse =
    //     jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    // print(decodedResponse);

    return Future.value(true);
  });
}

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  // Periodic task registration
  // Workmanager().registerPeriodicTask(
  //   "periodic-task-identifier",
  //   "simplePeriodicTask",
  //   // When no frequency is provided the default 15 minutes is set.
  //   // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //   frequency: Duration(minutes: 15),
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  @override
  void initState() {
    super.initState();
    _controller = FxControllerStore.putOrFind(AppController());
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
                  '/' :(context) => RootScreenPage(),
                  '/login': (context) => LoginScreenPage(),
                  '/home': (context) => HomesScreen(),
                  '/job_detail' : (context) => JobDetailScreenPage(),
                  '/pre_initialize': (context) => LoadingScreenPage(),
                  '/admin_home' : (context) => AdminTabMainScreenPage(),
                  '/send_job' : (context) => SendJobScreenPage(),
                  '/driver_home' : (context) => TabMainScreenPage(),
                },
                supportedLocales: Language.getLocales(),
              );
            },
          );
        });
  }
}
