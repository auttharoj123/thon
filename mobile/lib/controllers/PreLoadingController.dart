import 'package:flutter/material.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/models/RouteLine.dart';
import 'package:slpod/views/Admin/AdminTabMainScreenPage.dart';
import 'package:slpod/views/Driver/TabMainScreenPage.dart';

class PreLoadingController extends BaseController {
  // late List<RouteLine> routelines = [];
  // late RouteLine selectedRouteLine;

  @override
  void initState() {
    super.initState();
  }

  @override
  void onReady() async {
    super.onReady();
    await initializeData();
  }

  Future initializeData() async {
    var prefs = await SharedPreferences.getInstance();
    if (appController.accessToken != null) {
      // appController.routelines = await appController.api.fetchAllRouteLine();
      // var routelineId = prefs.getInt("routelineId");
      // if (routelineId != null) {
      //   appController.selectedRouteLine = appController.routelines
      //       .where((element) => element.routelineId == routelineId)
      //       .first;
      // } else {
      //   appController.selectedRouteLine = appController.routelines[0];
      // }
      //appController.mstTypes = await appController.api.fetchRemark();

      var userInfoResp = await appController.api.fetchUserInfo();
      appController.loginName = userInfoResp["result"]["loginname"];
      appController.fName = userInfoResp["result"]["fname"];
      appController.lName = userInfoResp["result"]["lname"];
      appController.roleAdmin = userInfoResp["result"]["roleAdmin"];

      Navigator.of(context).pushReplacementNamed("/admin_home");
      // if (appController.roleAdmin!) {
      //   Navigator.of(context).pushReplacementNamed("/admin_home");
      // } else {
      //   Navigator.of(context).pushReplacementNamed("/driver_home");
      // }
    }
  }

  @override
  String getTag() {
    return "preloading_controller";
  }
}
