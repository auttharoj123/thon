import 'dart:convert';
import 'dart:ffi';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/models/ResultResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/models/RouteLine.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:slpod/theme/constant.dart';
import 'package:slpod/widgets/syncfusion/data/charts_sample_data.dart';
import '../../apps/medicare/models/category.dart';
import '../../apps/medicare/models/doctor.dart';
import 'package:http/http.dart' as http;

import '../models/JobDetail.dart';
import '../views/TabScreen/HomeScreen.dart';
import '../views/TabScreen/ProfileScreen.dart';

class BaseController extends FxController {
  late AppController appController;

  @override
  void initState() {
    super.initState();

    appController = FxControllerStore.putOrFind(AppController());
  }
  
  @override
  String getTag() {
    throw UnimplementedError();
  }
}
