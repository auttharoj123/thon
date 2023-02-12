import 'package:slpod/controllers/AppController.dart';
import 'package:slpod/controllers/TabMainController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/views/SLState.dart';

class AdminTabMainScreenPage extends StatefulWidget {
  const AdminTabMainScreenPage({Key? key}) : super(key: key);

  @override
  _AdminTabMainScreenPageState createState() => _AdminTabMainScreenPageState();
}

class _AdminTabMainScreenPageState extends SLState<AdminTabMainScreenPage>
    with SingleTickerProviderStateMixin {
  late TabMainController controller;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(TabMainController(this));
    theme = AppTheme.sailomLightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<TabMainController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                    child: TabBarView(
                  controller: controller.tabController,
                  children: appController.adminScreenItems,
                )),
                FxContainer(
                  bordered: true,
                  enableBorderRadius: false,
                  border: Border(
                      top: BorderSide(
                          color: theme.dividerColor,
                          width: 1,
                          style: BorderStyle.solid)),
                  padding: FxSpacing.xy(12, 16),
                  color: theme.scaffoldBackgroundColor,
                  child: TabBar(
                    controller: controller.tabController,
                    indicator: FxTabIndicator(
                        indicatorColor: theme.colorScheme.primary,
                        indicatorHeight: 3,
                        radius: 3,
                        indicatorStyle: FxTabIndicatorStyle.circle),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: theme.colorScheme.primary,
                    tabs: buildTab(),
                  ),
                )
              ],
            ),
          );
        });
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < appController.adminNavItems.length; i++) {
      bool selected = controller.currentIndex == i;
      tabs.add(Icon(appController.adminNavItems[i].iconData,
          size: 20,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground));
    }
    return tabs;
  }
}
