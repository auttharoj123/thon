import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:slpod/controllers/TabMainController.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/screens/other/page_not_found_screen.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/utils/UpdateJobForegroundService.dart';
import 'package:slpod/views/SLState.dart';
import 'package:slpod/views/TabScreen/NonUpdateJobLogHistoryScreen.dart';
import '../TabScreen/HomeScreen.dart';
import '../TabScreen/ProfileScreen.dart';

class AdminTabMainScreenPage extends StatefulWidget {
  const AdminTabMainScreenPage({Key? key}) : super(key: key);

  @override
  _AdminTabMainScreenPageState createState() => _AdminTabMainScreenPageState();
}

class _AdminTabMainScreenPageState extends SLState<AdminTabMainScreenPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabMainController controller;
  late ThemeData theme;
  late PageController _pageController;
  int _currentIndex = 0;

  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late AppLifecycleState _appLifecycleState;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });

    if (state == AppLifecycleState.resumed) {
      UpdateJobForegroundService.startForegroundTask();
    } else {
      UpdateJobForegroundService.stopForegroundTask();
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    theme = AppTheme.sailomLightTheme;
    controller = FxControllerStore.putOrFind(TabMainController());
    controller.openMenuStreamController.stream.listen((event) {
      setState(() {});
    });
    _connectivity
        .checkConnectivity()
        .then((value) => _connectionStatus = value);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: theme.primaryColor.withAlpha(10))),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            body: Stack(
              children: [
                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  children: <Widget>[
                    HomeScreen(),
                    PageNotFoundScreen(),
                    PageNotFoundScreen(),
                    NonUpdateJobLogHistoryScreen(),
                    ProfileScreen()
                  ],
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 10,
                //   right: 10,
                //   child: PhysicalModel(
                //     color: Colors.transparent,
                //     child: CustomBottomNavigation(
                //       animationDuration: Duration(milliseconds: 350),
                //       selectedItemOverlayColor: Colors.blue.shade600,
                //       backgroundColor: Colors.transparent,
                //       selectedIndex: _currentIndex,
                //       // textStyle: TextStyle(
                //       //   fontSize: 12,
                //       // ),
                //       onItemSelected: (index) {
                //         setState(() => _currentIndex = index);
                //         _pageController!.jumpToPage(index);
                //       },
                //       items: <CustomBottomNavigationBarItem>[
                //         CustomBottomNavigationBarItem(
                //             title: "Jobs",
                //             icon: Icon(FontAwesomeIcons.businessTime, size: 20),
                //             activeIcon:
                //                 Icon(FontAwesomeIcons.businessTime, size: 20),
                //             activeColor: Colors.white,
                //             inactiveColor: Colors.white),
                //         // CustomBottomNavigationBarItem(
                //         //     title: "แชท",
                //         //     icon: Icon(MdiIcons.chatOutline, size: 20),
                //         //     activeIcon: Icon(MdiIcons.chat, size: 20),
                //         //     activeColor: Colors.white,
                //         //     inactiveColor: Colors.white),
                //         // CustomBottomNavigationBarItem(
                //         //     title: "แจ้งเตือน",
                //         //     icon: Icon(MdiIcons.bellRingOutline, size: 20),
                //         //     activeIcon: Icon(MdiIcons.bellRing, size: 20),
                //         //     activeColor: Colors.white,
                //         //     inactiveColor: Colors.white),
                //         // CustomBottomNavigationBarItem(
                //         //     title: "งานรออัปโหลด",
                //         //     icon: Icon(MdiIcons.uploadOutline, size: 20),
                //         //     activeIcon: Icon(MdiIcons.upload, size: 20),
                //         //     activeColor: Colors.white,
                //         //     inactiveColor: Colors.white),
                //         CustomBottomNavigationBarItem(
                //             title: "ตั้งค่า",
                //             icon: Icon(MdiIcons.accountOutline, size: 20),
                //             activeIcon: Icon(MdiIcons.account, size: 20),
                //             activeColor: Colors.white,
                //             inactiveColor: Colors.white),
                //       ],
                //     ),
                //   ),
                // ),
                (controller.toggleMenu)
                    ? FxContainer.transparent(
                        onTap: () {
                          controller.handleToggleMenu();
                        },
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      )
                    : Container(),
                AnimatedPositioned(
                  width: 80,
                  height: MediaQuery.of(context).size.height,
                  left: controller.toggleMenu ? 0 : -80,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.shade200],
                      )),
                      child: Column(
                        children: [
                          FxSpacing.height(20),
                          FxContainer.transparent(
                            onTap: () {
                              controller.handleToggleMenu();
                            },
                            child: Icon(Icons.arrow_back_ios_new,
                                color: Colors.white),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.selectedMenu = 1;
                              });
                              _pageController.jumpToPage(0);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedMenu == 1
                                    ? Colors.blue.shade600
                                    : Colors.transparent,
                              ),
                              child: Icon(FontAwesomeIcons.boxOpen,
                                  color: Colors.white),
                            ),
                          ),
                          FxSpacing.height(20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.selectedMenu = 2;
                              });
                              _pageController.jumpToPage(1);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedMenu == 2
                                    ? Colors.blue.shade600
                                    : Colors.transparent,
                              ),
                              child: Icon(FontAwesomeIcons.bell,
                                  color: Colors.white),
                            ),
                          ),
                          FxSpacing.height(20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.selectedMenu = 3;
                              });
                              _pageController.jumpToPage(2);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedMenu == 3
                                    ? Colors.blue.shade600
                                    : Colors.transparent,
                              ),
                              child: Icon(MdiIcons.chatOutline,
                                  color: Colors.white),
                            ),
                          ),
                          FxSpacing.height(20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.selectedMenu = 4;
                              });
                              _pageController.jumpToPage(3);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedMenu == 4
                                    ? Colors.blue.shade600
                                    : Colors.transparent,
                              ),
                              child:
                                  Icon(MdiIcons.history, color: Colors.white),
                            ),
                          ),
                          FxSpacing.height(20),
                          Expanded(child: Container()),
                          FxContainer(
                            onTap: () {
                              setState(() {
                                controller.selectedMenu = 5;
                              });
                              _pageController.jumpToPage(4);
                            },
                            color: controller.selectedMenu == 5
                                ? Colors.blue.shade600
                                : Colors.transparent,
                            child: Icon(FontAwesomeIcons.gear,
                                color: Colors.white),
                          ),
                          FxSpacing.height(20),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: FxContainer(
                    color: Colors.red.withAlpha(200),
                    marginAll: 0,
                    paddingAll: 0,
                    bordered: false,
                    borderRadiusAll: 0,
                    width: double.infinity,
                    height:
                        _connectionStatus == ConnectivityResult.none ? 20 : 0,
                    child: Center(
                        child: FxText(
                      "Connection is offline",
                      fontSize: 14,
                      color: Colors.white,
                    )),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < appController.driverNavItems.length; i++) {
      bool selected = controller.currentIndex == i;
      tabs.add(Icon(appController.driverNavItems[i].iconData,
          size: 20,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground));
    }
    return tabs;
  }
}
