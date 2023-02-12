import 'dart:convert';

import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/models/ResultResponse.dart';
import 'package:slpod/views/Admin/AdminTabMainScreenPage.dart';
import 'package:slpod/views/Driver/TabMainScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/views/SplashScreenPage.dart';
import 'package:workmanager/workmanager.dart';

// import '../shopping_cache.dart';
// import '../views/forgot_password_screen.dart';
// import '../views/full_app.dart';
// import '../views/register_screen.dart';

class LoginController extends BaseController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool enable = false;
  Map<String, String> headers = {};

  @override
  void initState() {
    super.initState();
    save = false;
    emailController = TextEditingController(text: 'test_user');
    passwordController = TextEditingController(text: '143756');
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter login name";
    } else if (FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateStringRange(text, 6, 10)) {
      return "Password must be between 6 to 10";
    }
    return null;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToRegisterScreen() {
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => RegisterScreen(),
    //   ),
    // );
  }

  void goToForgotPasswordScreen() {
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => ForgotPasswordScreen(),
    //   ),
    // );
  }

  void login() async {
    // final ImagePicker _picker = ImagePicker();
    // final List<XFile>? images = await _picker.pickMultiImage();
    // final paths = images!.map((e) => e.path);
    // Workmanager().registerOneOffTask(
    //   "update-job-1",
    //   "update-job-Task",
    //   inputData: {
    //     "images" : paths.join(',')
    //   }
    // );

    // //print("Test");
    // return;
    if (formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      var client = http.Client();
      try {
        var loginResponse = await appController.api
            .login(emailController.text, passwordController.text);

        var token = loginResponse["token"] as String;
        var refreshToken = loginResponse["refresh_token"] as String;
        await prefs.setString('accessToken', token);
        await prefs.setString('refreshToken', refreshToken);

        appController.accessToken = token;
        appController.refreshToken = refreshToken;
        //appController.roleAdmin = userInfoResponse["result"]["roleAdmin"];
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoadingScreenPage(),
            transitionDuration: Duration.zero,
          ),
        );

        // var userInfoResponse = await appController.api.fetchUserInfo();
        // if (userInfoResponse["isSuccess"]) {
        //   await prefs.setBool(
        //       'roleAdmin', userInfoResponse["result"]["roleAdmin"]);

        // }
      } catch (e) {
        print(e);
      } finally {
        client.close();
      }
    }
  }

  // void updateCookie(http.Response response) {
  //   String rawCookie = response.headers['set-cookie']!;
  //   if (rawCookie != null) {
  //     int index = rawCookie.indexOf(';');
  //     headers['cookie'] =
  //         (index == -1) ? rawCookie : rawCookie.substring(0, index);
  //   }
  // }

  @override
  String getTag() {
    return "login_controller";
  }
}
