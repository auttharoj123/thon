import 'dart:convert';
import 'dart:ffi';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:slpod/api/API.dart';
import 'package:slpod/api/RequestInterceptor.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/models/MstType.dart';
import 'package:slpod/models/ResultResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/models/RouteLine.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:slpod/theme/constant.dart';
import 'package:slpod/widgets/syncfusion/data/charts_sample_data.dart';
import '../../apps/medicare/models/category.dart';
import '../../apps/medicare/models/doctor.dart';
import 'package:http/http.dart' as http;

import '../models/JobDetail.dart';
import '../views/TabScreen/HomeScreen.dart';
import '../views/TabScreen/ProfileScreen.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class AppController extends FxController {
  String? accessToken;
  String? refreshToken;
  bool? roleAdmin;

  late List<NavItem> driverNavItems = [
    NavItem('Home', FontAwesomeIcons.clipboardList),
    NavItem('Profile', FontAwesomeIcons.gear),
  ];
  late List<Widget> driverScreenItems = [HomeScreen(), ProfileScreen()];

  late List<NavItem> adminNavItems = [
    NavItem('Home', FontAwesomeIcons.clipboardList),
    NavItem('Profile', FontAwesomeIcons.gear),
  ];
  late List<Widget> adminScreenItems = [
    HomeScreen(),
    ProfileScreen(),
  ];

  late List<RouteLine> routelines = [];
  late List<MstType> mstTypes = [];
  late RouteLine selectedRouteLine;
  late DateTime fromDate = DateTime.now().subtract(Duration(days: 15));
  late DateTime toDate = DateTime.now().add(Duration(days: 15));
  late API api;

  @override
  void initState() {
    super.initState();

    api = API(InterceptedClient.build(
      interceptors: [
        RequestInterceptor(),
        //LoggerInterceptor(),
      ],
      //retryPolicy: ExpiredTokenRetryPolicy(),
    ));
  }

  @override
  void onReady() async {
    super.onReady();
    await initializeData();
  }

  Future initializeData() async {
    var prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("accessToken");
    refreshToken = prefs.getString("refreshToken");
    //roleAdmin = prefs.getBool("roleAdmin");

    var fromDateStr = prefs.getString("fromDate");
    var toDateStr = prefs.getString("toDate");
    fromDate = (fromDateStr != null) ? DateTime.parse(fromDateStr) : fromDate;
    toDate = (toDateStr != null) ? DateTime.parse(toDateStr) : toDate;
    update();
  }

  Future onSelectedRouteLine(RouteLine item) async {
    selectedRouteLine = item;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("routelineId", item.routelineId);
  }

  Future<void> onSelectedDateRange(DateTime? fromDate, DateTime? toDate) async {
    var prefs = await SharedPreferences.getInstance();
    fromDate = fromDate;
    toDate = toDate;
    await prefs.setString("fromDate", fromDate.toString());
    await prefs.setString("toDate", toDate.toString());
  }

  Future logout() async {
    await clearData();
    Navigator.pushReplacementNamed(
        NavigationService.navigatorKey.currentContext!, '/');
  }

  Future clearData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
    await prefs.remove("roleAdmin");

    accessToken = null;
    refreshToken = null;
    roleAdmin = null;
  }

  @override
  String getTag() {
    return "app_controller";
  }
}
