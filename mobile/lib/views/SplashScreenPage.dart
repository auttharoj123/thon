// /*
// This is splash screen page
// Don't forget to add all images and sound used in this pages at the pubspec.yaml
//  */

// import 'dart:async';
// import 'dart:io';
// //import 'package:slpod/apps/muvi/controllers/login_controller.dart';
// import 'package:slpod/constants/SLConsts.dart';
// import 'package:slpod/views/LoginScreenPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SplashScreenPage extends StatefulWidget {
//   @override
//   _SplashScreenPageState createState() => _SplashScreenPageState();
// }

// class _SplashScreenPageState extends State<SplashScreenPage> {
//   Timer? _timer;
//   int _second = 3; // set timer for 3 second and then direct to next page

//   void _startTimer() {
//     const period = const Duration(seconds: 1);
//     _timer = Timer.periodic(period, (timer) {
//       setState(() {
//         _second--;
//       });
//       if (_second == 0) {
//         _cancelFlashsaleTimer();
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreenPage()), (Route<dynamic> route) => false);
//       }
//     });
//   }

//   void _cancelFlashsaleTimer() {
//     if (_timer != null) {
//       _timer!.cancel();
//       _timer = null;
//     }
//   }

//   @override
//   void initState() {
//     // set status bar color to transparent and navigation bottom color to black21
//     SystemChrome.setSystemUIOverlayStyle(
//       Platform.isIOS?SystemUiOverlayStyle.light:SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         systemNavigationBarColor: Colors.transparent,
//         systemNavigationBarIconBrightness: Brightness.light
//       ),
//     );

//     if(_second != 0){
//       _startTimer();
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cancelFlashsaleTimer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   SLColor.LIGHTBLUE1,
//                   SLColor.LIGHTBLUE2,
//                   SLColor.BLUE
//                 ]
//               )
//             ),
//             child: Center(
//               child: Image.asset('assets/images/sailom/logo1.png', height: 200),
//             ),
//           ),
//         )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/controller.dart';
import 'package:flutx/core/state_management/state_management.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:slpod/controllers/PreLoadingController.dart';

class LoadingScreenPage extends StatefulWidget {
  LoadingScreenPage({Key? key}) : super(key: key);

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder(
        controller: PreLoadingController(),
        builder: (controller) {
          return Scaffold(
              body: Center(
                  child: FxContainer(
                      color: Colors.white, child: FxText("กำลังโหลดข้อมูลสายส่ง..."))));
        });
  }
}
