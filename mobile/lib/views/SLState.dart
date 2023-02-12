import 'package:flutter/material.dart';
import 'package:flutx/core/state_management/state_management.dart';
import 'package:slpod/controllers/AppController.dart';

class SLState<T extends StatefulWidget> extends State<T> {
  late AppController appController;

  @override
  void initState() {
    super.initState();

    appController = FxControllerStore.putOrFind(AppController());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
