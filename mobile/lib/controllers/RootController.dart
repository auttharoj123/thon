import 'package:flutter/material.dart';
import 'package:slpod/controllers/BaseController.dart';

class RootController extends BaseController {
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
    if(appController.accessToken != null)
    {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/pre_initialize');
    }
    else
    {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
    }
  }

  @override
  String getTag() {
    return "root_controller";
  }
}
