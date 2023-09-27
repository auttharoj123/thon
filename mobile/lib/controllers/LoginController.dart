import 'package:slpod/controllers/BaseController.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';
import 'package:slpod/views/SplashScreenPage.dart';

class LoginController extends BaseController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool enable = false;
  Map<String, String> headers = {};
  var globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
    save = false;
    emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
  }

  @override
  void onReady() async {
    final prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("username");
    var password = prefs.getString("password");
    emailController.text = username ?? '';
    passwordController.text = password ?? '';
    super.onReady();
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
    }
    return null;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToRegisterScreen() {}

  void goToForgotPasswordScreen() {}

  void login() async {
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
        await prefs.setString('username', emailController.text);
        await prefs.setString('password', passwordController.text);

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
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => globalWidget.errorDialog(
                context, "Username หรือ Password ไม่ถูกต้อง"));
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
