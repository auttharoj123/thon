import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/views/TabScreen/ProfileScreen.dart';

import '../views/TabScreen/HomeScreen.dart';

// import '../views/dashboard_screen.dart';
// import '../views/orders_screen.dart';
// import '../views/products_screen.dart';
// import '../views/profile_screen.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class TabMainController extends BaseController {
  int currentIndex = 0;
  int pages = 2;
  late TabController tabController;

  final TickerProvider tickerProvider;

  TabMainController(this.tickerProvider) {
    tabController =
        TabController(length: pages, vsync: tickerProvider, initialIndex: 0);
  }

  @override
  void initState() {
    super.initState();

    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }
  

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return "tab_main_controller";
  }
}
