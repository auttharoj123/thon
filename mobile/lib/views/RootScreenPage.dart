import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/controllers/RootController.dart';

class RootScreenPage extends StatefulWidget {
  RootScreenPage({Key? key}) : super(key: key);

  @override
  State<RootScreenPage> createState() => _RootScreenPageState();
}

class _RootScreenPageState extends State<RootScreenPage> {
  late AppController appController;

  @override
  void initState() {
    super.initState();

    appController = FxControllerStore.putOrFind(AppController());
  }

  @override
  Widget build(BuildContext context) {
    if (!appController.initialized) {
      return FxContainer();
    }
    return FxBuilder(
        controller: RootController(),
        builder: (controller) {
          return FxContainer();
        });
  }
}
