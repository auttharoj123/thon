import 'dart:async';
import 'dart:ui';

import 'package:rive/rive.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../controllers/LoginController.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenPage> {
  late ThemeData theme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;
  late StreamSubscription<bool> keyboardSubscription;
  late double? test = 0;
  late bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.sailomLightTheme;
    controller = FxControllerStore.putOrFind(LoginController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if (mounted) {
        _isKeyboardVisible = visible;
        // final viewInsets = EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets,WidgetsBinding.instance.window.devicePixelRatio);
        // setState(() {
        //   test = visible ? 50 : -50;
        // });
      }
    });
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    test = _isKeyboardVisible && viewInsets.bottom > 50
        ? viewInsets.bottom - 100
        : 0;
    return FxBuilder<LoginController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
              //resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  // Image.asset('assets/images/sailom/logo_white.jpg'),
                  Container(
                    // height: MediaQuery.of(context).size.height,
                    child: RiveAnimation.asset(
                            
                            'assets/animations/rive/background4.riv',
                            artboard: "Motion",
                            fit: BoxFit.fitHeight,
                            // controllers: [_controller],
                          ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10
                    ),
                    child: Container(
                              // color: Color.fromRGBO(2, 3, 13, 1),
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: AssetImage("assets/images/bulb.jpg"),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              //padding: FxSpacing.nBottom(20),
                              decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     SLColor.LIGHTBLUE1,
                    //     SLColor.LIGHTBLUE2,
                    //     SLColor.BLUE,
                    //   ],
                    // ),
                              ),
                              child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Positioned(
                      //   top: -test!,
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 200,
                      //   child: Transform.scale(
                      //       scale: 1.5,
                      //       child: Material(
                      //         elevation: 10.0,
                      //         borderRadius: BorderRadius.only(
                      //             bottomLeft: Radius.circular(200),
                      //             bottomRight: Radius.circular(200)),
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //               //color: Colors.white,
                      //               image: DecorationImage(
                      //                 image: AssetImage(
                      //                     'assets/images/sailom/logo_white.jpg'),
                      //                 fit: BoxFit.fitWidth,
                      //                 colorFilter: ColorFilter.mode(
                      //                     Colors.black45, BlendMode.darken),
                      //               ),
                      //               borderRadius: BorderRadius.only(
                      //                   bottomLeft: Radius.circular(200),
                      //                   bottomRight: Radius.circular(200))),
                      //         ),
                      //       )),
                      // ),
                      // Positioned(
                      //   top: 180 - test!,
                      //   child: Container(
                      //     //padding: FxSpacing.all(10),
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(
                      //             width: 2, color: Color.fromRGBO(47, 129, 229, 1)),
                      //         borderRadius: BorderRadius.all(Radius.circular(75))),
                      //     child: logo(),
                      //   ),
                      // ),
                      Container(
                        padding: FxSpacing.nBottom(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            
                            // FxSpacing.height(20),
                            //FxSpacing.height(180),
                            //SizedBox(height: 200),
                            // Expanded(child: Container(), flex: 3),
                            //welcomeTitle(),
                            loginTitle(),
                            logo(),
                            // FxSpacing.height(20),
                            loginForm(),
                            Expanded(child: Container()),
                            //forgotPassword(),
                            //FxSpacing.height(10),
                            loginBtn(),
                            FxSpacing.height(20),
                            //registerBtn()
                          ],
                        ),
                      )
                    ],
                              ),
                            ),
                  ),
                ],
              ));
        });
  }

  Widget welcomeTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FxText.headlineLarge(
        "ยินดีต้อนรับ",
        fontWeight: 700,
        color: Colors.white,
      ),
    );
  }

  Widget loginTitle() {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FxText.headlineLarge(
          "เข้าสู่ระบบ",
          fontWeight: 500,
          fontSize: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget logo() {
    return ClipRRect(
      child: Container(
        child: Center(
          child: Image.asset(
            'assets/images/sailom/logo_white-transparent.png',
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.labelSmall(
            "Username",
            color: Colors.white,
          ),
          FxSpacing.height(10),
          emailField(),
          FxSpacing.height(20),
          FxText.labelSmall(
            "Password",
            color: Colors.white,
          ),
          FxSpacing.height(10),
          passwordField()
        ],
      ),
    );
  }

  Widget emailField() {
    return Material(
      elevation: 10.0,
      shadowColor: Color.fromRGBO(89, 152, 229, 0.6),
      child: TextFormField(
        style: FxTextStyle.bodyMedium(color: Colors.blue),
        decoration: InputDecoration(
          hintText: "Login name",
          hintStyle: FxTextStyle.bodyMedium(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent)),
          //border: outlineInputBorder,
          //enabledBorder: outlineInputBorder,
          //focusedBorder: outlineInputBorder,
          prefixIcon: Icon(
            FeatherIcons.user,
            size: 22,
            color: Colors.blue,
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(0),
        ),
        controller: controller.emailController,
        //validator: controller.validateEmail,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget passwordField() {
    return Material(
      elevation: 10.0,
      shadowColor: Color.fromRGBO(89, 152, 229, 0.6),
      child: TextFormField(
        style: FxTextStyle.bodyMedium(color: Colors.blue),
        obscureText: controller.enable ? false : true,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: FxTextStyle.bodyMedium(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.transparent)),
          // border: outlineInputBorder,
          // enabledBorder: outlineInputBorder,
          // focusedBorder: outlineInputBorder,
          suffixIcon: InkWell(
              onTap: () {
                controller.toggle();
              },
              child: Icon(
                controller.enable
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: Colors.blue,
              )),
          prefixIcon: Icon(
            FeatherIcons.key,
            size: 22,
            color: Colors.blue,
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(0),
        ),
        controller: controller.passwordController,
        validator: controller.validatePassword,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget forgotPassword() {
    return Align(
      alignment: Alignment.topRight,
      child: FxButton.text(
        onPressed: () {
          controller.goToForgotPasswordScreen();
        },
        elevation: 0,
        padding: FxSpacing.right(0),
        borderRadiusAll: 4,
        child: FxText.bodySmall(
          "Forgot password?",
        ),
      ),
    );
  }

  Widget loginBtn() {
    return SafeArea(
      child: FxButton.block(
        padding: FxSpacing.y(12),
        onPressed: () {
          controller.login();
        },
        backgroundColor: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxText.bodyLarge("ลงชื่อเข้าใช้งาน".toUpperCase(),
                fontWeight: 700,
                color: Color.fromRGBO(47, 129, 229, 1),
                letterSpacing: 0.5),
            FxSpacing.width(8),
            Icon(
              FeatherIcons.chevronRight,
              size: 18,
              color: theme.colorScheme.onPrimary,
            )
          ],
        ),
        borderRadiusAll: 24,
      ),
    );
  }

  Widget registerBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToRegisterScreen();
      },
      elevation: 0,
      child: FxText.bodySmall("I haven't an account",
          decoration: TextDecoration.underline),
    );
  }
}
