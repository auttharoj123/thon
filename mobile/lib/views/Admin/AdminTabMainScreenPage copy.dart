// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:slpod/controllers/AppController.dart';
// import 'package:slpod/controllers/TabMainController.dart';
// import 'package:flutter/material.dart';
// import 'package:flutx/flutx.dart';
// import 'package:slpod/localizations/language.dart';
// import 'package:slpod/screens/other/page_not_found_screen.dart';
// import 'package:slpod/theme/app_notifier.dart';
// import 'package:slpod/theme/app_theme.dart';
// import 'package:slpod/views/SLState.dart';
// import 'package:slpod/widgets/custom/navigation/custom_bottom_navigation.dart';

// import '../TabScreen/HomeScreen.dart';
// import '../TabScreen/ProfileScreen.dart';

// class AdminTabMainScreenPage1 extends StatefulWidget {
//   const AdminTabMainScreenPage1({Key? key}) : super(key: key);

//   @override
//   _AdminTabMainScreenPageState createState() => _AdminTabMainScreenPageState();
// }

// class _AdminTabMainScreenPageState extends SLState<AdminTabMainScreenPage1>
//     with SingleTickerProviderStateMixin {
//   late TabMainController controller;
//   late ThemeData theme;
//   late PageController _pageController;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     controller = FxControllerStore.putOrFind(TabMainController());
//     _pageController = PageController();
//     theme = AppTheme.sailomLightTheme;
//   }

//   @override
//   void dispose() {
//     FxControllerStore.delete(controller);
//     super.dispose();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return FxBuilder<TabMainController>(
//   //       controller: controller,
//   //       theme: theme,
//   //       builder: (controller) {
//   //         return Scaffold(
//   //           body: Column(
//   //             children: [
//   //               Expanded(
//   //                   child: TabBarView(
//   //                 controller: controller.tabController,
//   //                 children: appController.driverScreenItems,
//   //               )),
//   //               FxContainer(
//   //                 bordered: true,
//   //                 enableBorderRadius: false,
//   //                 border: Border(
//   //                     top: BorderSide(
//   //                         color: theme.dividerColor,
//   //                         width: 1,
//   //                         style: BorderStyle.solid)),
//   //                 padding: FxSpacing.xy(12, 16),
//   //                 color: theme.scaffoldBackgroundColor,
//   //                 child: TabBar(
//   //                   controller: controller.tabController,
//   //                   indicator: FxTabIndicator(
//   //                       indicatorColor: theme.colorScheme.primary,
//   //                       indicatorHeight: 3,
//   //                       radius: 3,
//   //                       indicatorStyle: FxTabIndicatorStyle.circle),
//   //                   indicatorSize: TabBarIndicatorSize.tab,
//   //                   indicatorColor: theme.colorScheme.primary,
//   //                   tabs: buildTab(),
//   //                 ),
//   //               )
//   //             ],
//   //           ),
//   //         );
//   //       });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: theme.copyWith(
//           colorScheme: theme.colorScheme
//               .copyWith(secondary: theme.primaryColor.withAlpha(10))),
//       child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: theme,
//           home: Scaffold(
//             body: SizedBox.expand(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(() => _currentIndex = index);
//                 },
//                 children: <Widget>[HomeScreen(), PageNotFoundScreen(), PageNotFoundScreen(), ProfileScreen()],
//               ),
//             ),
//             bottomNavigationBar: CustomBottomNavigation(
//               animationDuration: Duration(milliseconds: 350),
//               selectedItemOverlayColor: Colors.blue.shade300.withAlpha(200),
//               backgroundColor: Colors.blue,
//               selectedIndex: _currentIndex,
//               // textStyle: TextStyle(
//               //   fontSize: 12,
//               // ),
//               onItemSelected: (index) {
//                 setState(() => _currentIndex = index);
//                 _pageController!.jumpToPage(index);
//               },
//               items: <CustomBottomNavigationBarItem>[
//                 CustomBottomNavigationBarItem(
//                     title: "Jobs",
//                     icon: Icon(FontAwesomeIcons.businessTime, size: 20),
//                     activeIcon: Icon(FontAwesomeIcons.businessTime, size: 20),
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.white),
//                 CustomBottomNavigationBarItem(
//                     title: "แชท",
//                     icon: Icon(MdiIcons.chatOutline, size: 30),
//                     activeIcon: Icon(MdiIcons.chat, size: 30),
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.white),                    
//                 CustomBottomNavigationBarItem(
//                     title: "แจ้งเตือน",
//                     icon: Icon(MdiIcons.bellRingOutline, size: 30),
//                     activeIcon: Icon(MdiIcons.bellRing, size: 30),
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.white),
//                 CustomBottomNavigationBarItem(
//                     title: "ตั้งค่า",
//                     icon: Icon(MdiIcons.accountOutline, size: 30),
//                     activeIcon: Icon(MdiIcons.account, size: 30),
//                     activeColor: Colors.white,
//                     inactiveColor: Colors.white),
//               ],
//             ),
//           )),
//     );
//   }

//   List<Widget> buildTab() {
//     List<Widget> tabs = [];

//     for (int i = 0; i < appController.driverNavItems.length; i++) {
//       bool selected = controller.currentIndex == i;
//       tabs.add(Icon(appController.driverNavItems[i].iconData,
//           size: 20,
//           color: selected
//               ? theme.colorScheme.primary
//               : theme.colorScheme.onBackground));
//     }
//     return tabs;
//   }
// }
