// import 'dart:ui';

// import 'package:date_format/date_format.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:slpod/components/expansion_tile_partial.dart';
// import 'package:slpod/constants/SLConsts.dart';
// import 'package:slpod/models/JobDetail.dart';
// import 'package:slpod/models/JobDetailWrapper.dart';
// import 'package:slpod/theme/app_theme.dart';
// import 'package:flutter/services.dart';
// import 'package:flutx/flutx.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:slpod/utils/navigation_helper.dart';
// import 'package:slpod/views/Reuseable/GlobalWidget.dart';
// import 'package:slpod/views/SLState.dart';
// // import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// import 'package:timezone/data/latest.dart' as tz;
// // import 'single_doctor_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../controllers/HomeController.dart';
// import '../../loading_effect.dart';

// // import 'models/category.dart';
// // import 'models/doctor.dart';

// class ScannerOverlay extends CustomPainter {
//   ScannerOverlay(this.scanWindow);

//   final Rect scanWindow;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final backgroundPath = Path()..addRect(Rect.largest);
//     final cutoutPath = Path()..addRect(scanWindow);

//     final backgroundPaint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill
//       ..blendMode = BlendMode.dstOut;

//     final backgroundWithCutout = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       cutoutPath,
//     );
//     canvas.drawPath(backgroundWithCutout, backgroundPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends SLState<HomeScreen>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   int selectedCategory = 0;
//   late ThemeData theme;
//   late CustomTheme customTheme;
//   late HomeController controller;
//   late ScrollController _scrollController;
//   late TextEditingController _searchTextController;
//   late TextEditingController _customerSearchController;
//   // late SuggestionsBoxController _suggestBoxController;
//   late DateRangePickerController _dateRangePickerController;
//   late AnimationController _appBarAnimationController;
//   late Animation<double> _appBarAnimation;
//   late MobileScannerController _mobileScannerController;
//   late GlobalWidget _globalWidget;
//   // dynamic color;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimateAppbar();
//     tz.initializeTimeZones();
//     theme = AppTheme.theme;
//     customTheme = AppTheme.customTheme;
//     controller = FxControllerStore.putOrFind(HomeController());
//     _dateRangePickerController = DateRangePickerController();
//     _searchTextController = TextEditingController();
//     _customerSearchController = TextEditingController();
//     _mobileScannerController =
//         MobileScannerController(detectionSpeed: DetectionSpeed.unrestricted);
//     // _suggestBoxController = SuggestionsBoxController();
//     _scrollController = ScrollController();
//     _globalWidget = GlobalWidget();
//   }

//   void _setupAnimateAppbar() {
//     // use this function and paramater to animate top bar
//     _appBarAnimationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 0));
//     _appBarAnimation = Tween<double>(
//       begin: 0.0,
//       end: 60.0,
//     ).animate(_appBarAnimationController);
//   }

//   Widget _buildCall(JobDetail job) {
//     return (job.contactTelephone.isNotEmpty)
//         ? FxContainer.roundBordered(
//             onTap: () async {
//               await launchUrl(Uri(scheme: 'tel', path: job.contactTelephone));
//             },
//             color: (job.contactTelephone.isNotEmpty)
//                 ? Colors.green.shade300
//                 : Colors.grey,
//             paddingAll: 5,
//             child: Icon(Icons.call, color: Colors.white),
//           )
//         : Container();
//   }

//   Widget clearSelectionDialog(context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       child: Container(
//         padding: FxSpacing.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: FxSpacing.right(16),
//                   child: Icon(
//                     Icons.warning,
//                     size: 28,
//                     color: Colors.yellow.shade700,
//                   ),
//                 ),
//                 FxSpacing.width(8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                         style: FxTextStyle.bodyLarge(
//                             fontWeight: 500, letterSpacing: 0.2),
//                         children: <TextSpan>[
//                           TextSpan(text: "ยกเลิกรายการที่เลือกทั้งหมดหรือไม่?"),
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//                 margin: FxSpacing.top(8),
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     FxButton.text(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: FxText.bodyMedium("ปิด",
//                             fontWeight: 700, letterSpacing: 0.4)),
//                     FxSpacing.width(10),
//                     FxButton(
//                         backgroundColor: SLColor.LIGHTBLUE2,
//                         borderRadiusAll: 4,
//                         elevation: 0,
//                         onPressed: () {
//                           Navigator.pop(context);
//                           if (controller.selectionJobType ==
//                               SelectionJobTypes.camera) {
//                             controller.filteredJobs = [];
//                           }
//                           controller.clearAllSelection();
//                         },
//                         child: FxText.bodyMedium("ยืนยัน",
//                             letterSpacing: 0.4,
//                             color: theme.colorScheme.onPrimary)),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget showConfirmScanBarcode(context, jobDetail) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       child: Container(
//         padding: FxSpacing.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: FxSpacing.right(16),
//                   child: Icon(
//                     FontAwesomeIcons.circleCheck,
//                     size: 28,
//                     color: Colors.green.shade700,
//                   ),
//                 ),
//                 FxSpacing.width(8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                         style: FxTextStyle.bodyLarge(
//                             fontWeight: 500, letterSpacing: 0.2),
//                         children: <TextSpan>[
//                           TextSpan(text: "พบหมายเลขบาร์โค้ด "),
//                           TextSpan(
//                               text: "${jobDetail[0].barcode}",
//                               style: TextStyle(fontWeight: FontWeight.w600)),
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//                 margin: FxSpacing.top(8),
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     FxButton.text(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           controller.isShowList = true;
//                           setState(() {});
//                         },
//                         child: FxText.bodyMedium("ยกเลิก",
//                             fontWeight: 700, letterSpacing: 0.4)),
//                     FxSpacing.width(10),
//                     FxButton(
//                         backgroundColor: SLColor.LIGHTBLUE2,
//                         borderRadiusAll: 4,
//                         elevation: 0,
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           controller.selectJobByBarcode(jobDetail);
//                           _mobileScannerController.start();
//                         },
//                         child: FxText.bodyMedium("ยืนยันรายการ",
//                             letterSpacing: 0.4,
//                             color: theme.colorScheme.onPrimary)),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget showSendJobRequired(context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       child: Container(
//         padding: FxSpacing.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: FxSpacing.right(16),
//                   child: Icon(
//                     FontAwesomeIcons.xmark,
//                     size: 28,
//                     color: Colors.red.shade700,
//                   ),
//                 ),
//                 FxSpacing.width(8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                         style: FxTextStyle.bodyLarge(
//                             fontWeight: 500, letterSpacing: 0.2),
//                         children: <TextSpan>[
//                           TextSpan(text: "กรุณาเลือกงานที่ต้องการส่ง")
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//                 margin: FxSpacing.top(8),
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     FxButton.text(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: FxText.bodyMedium("ตกลง",
//                             fontWeight: 700, letterSpacing: 0.4)),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget showDuplicateScanBarcode(context, jobDetail) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       child: Container(
//         padding: FxSpacing.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: FxSpacing.right(16),
//                   child: Icon(
//                     FontAwesomeIcons.xmark,
//                     size: 28,
//                     color: Colors.red.shade700,
//                   ),
//                 ),
//                 FxSpacing.width(8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                         style: FxTextStyle.bodyLarge(
//                             fontWeight: 500, letterSpacing: 0.2),
//                         children: <TextSpan>[
//                           TextSpan(text: "หมายเลขบาร์โค้ด "),
//                           TextSpan(
//                               text: "${jobDetail[0].barcode}",
//                               style: TextStyle(fontWeight: FontWeight.w600)),
//                           TextSpan(text: " ได้ถูกเลือกแล้ว"),
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//                 margin: FxSpacing.top(8),
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     FxButton.text(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           controller.isShowList = true;
//                           setState(() {});
//                         },
//                         child: FxText.bodyMedium("ยกเลิก",
//                             fontWeight: 700, letterSpacing: 0.4)),
//                     FxSpacing.width(10),
//                     FxButton(
//                         backgroundColor: SLColor.LIGHTBLUE2,
//                         borderRadiusAll: 4,
//                         elevation: 0,
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _mobileScannerController.start();
//                         },
//                         child: FxText.bodyMedium("ทำรายการต่อ",
//                             letterSpacing: 0.4,
//                             color: theme.colorScheme.onPrimary)),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget showSelectionTypeDialog(context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//       child: Container(
//         padding: FxSpacing.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   margin: FxSpacing.right(16),
//                   child: Icon(
//                     FontAwesomeIcons.barcode,
//                     size: 28,
//                   ),
//                 ),
//                 FxSpacing.width(8),
//                 Expanded(
//                   child: RichText(
//                     text: TextSpan(
//                         style: FxTextStyle.bodyLarge(
//                             fontWeight: 500, letterSpacing: 0.2),
//                         children: <TextSpan>[
//                           TextSpan(text: "เปิดใช้งานเลือกงานโดยสแกนบาร์โค้ด?"),
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//                 margin: FxSpacing.top(8),
//                 alignment: AlignmentDirectional.centerEnd,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     FxButton.text(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: FxText.bodyMedium("ปิด",
//                             fontWeight: 700, letterSpacing: 0.4)),
//                     FxSpacing.width(10),
//                     FxButton(
//                         backgroundColor: SLColor.LIGHTBLUE2,
//                         borderRadiusAll: 4,
//                         elevation: 0,
//                         onPressed: () async {
//                           Navigator.pop(context);
//                           try {
//                             controller.toggleSendJobButtonFunc(
//                                 SelectionJobTypes.camera);
//                           } on PlatformException {}
//                         },
//                         child: FxText.bodyMedium("ยืนยัน",
//                             letterSpacing: 0.4,
//                             color: theme.colorScheme.onPrimary)),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildJobDetailWrapperItem(JobDetailWrapper wrapper) {
//     var titleFontSize = 14.0;
//     if (wrapper.items.length == 1) {
//       return _buildJobDetailItem(wrapper.items[0]);
//     }

//     return FxContainer.transparent(
//       onTap: () {
//         if (!wrapper.isChecked) {
//           wrapper.isChecked = true;
//           wrapper.items.forEach((element) {
//             element.isChecked = true;
//             if (!controller.selectedJobIds.contains(element)) {
//               controller.selectedJobIds.add(element);
//             }
//           });
//         } else {
//           wrapper.isChecked = false;
//           wrapper.items.forEach((element) {
//             element.isChecked = false;
//             controller.selectedJobIds.remove(element);
//           });
//         }
//         setState(() {});
//       },
//       paddingAll: 0,
//       margin: FxSpacing.only(left: 10, right: 10),
//       bordered: false,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.white.withOpacity(0.9),
//                       Colors.white.withOpacity(0.8)
//                     ])),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         FxSpacing.height(10),
//                         ExpansionTileNew(
//                           backgroundColor: Colors.transparent,
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Row(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       FxContainer.roundBordered(
//                                         paddingAll: 0,
//                                         child: wrapper.isChecked
//                                             ? Icon(
//                                                 Icons.check_circle,
//                                                 size: 30,
//                                                 color: Colors.blue,
//                                               )
//                                             : Icon(
//                                                 Icons.circle,
//                                                 size: 30,
//                                                 color: Colors.blue.shade300,
//                                               ),
//                                       ),
//                                       FxSpacing.width(10),
//                                     ],
//                                   ),
//                                   FxSpacing.width(10),
//                                   Expanded(
//                                     child: Container(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   FxText.titleLarge(
//                                                     "${wrapper.title}",
//                                                     fontWeight: 600,
//                                                     color: Colors.blue,
//                                                   ),
//                                                   FxSpacing.width(20),
//                                                   _buildCall(wrapper.items[0])
//                                                 ],
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               FxSpacing.height(10),
//                               Row(
//                                 children: [
//                                   FxText(
//                                     "จำนวนสินค้าทั้งหมด: ",
//                                     fontWeight: 600,
//                                     fontSize: titleFontSize,
//                                     color: Colors.grey,
//                                   ),
//                                   FxSpacing.width(10),
//                                   FxText(
//                                     "${wrapper.totalQty}",
//                                     fontWeight: 600,
//                                     fontSize: titleFontSize,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                               FxSpacing.height(10),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.route,
//                                     color: Colors.blue,
//                                     size: 20,
//                                   ),
//                                   FxSpacing.width(10),
//                                   FxText(
//                                     "${wrapper.items[0].routeName}",
//                                     fontWeight: 600,
//                                     fontSize: titleFontSize,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                               FxSpacing.height(10),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     FontAwesomeIcons.calendar,
//                                     color: Colors.blue,
//                                     size: 20,
//                                   ),
//                                   FxSpacing.width(10),
//                                   FxText(
//                                     "${formatDate(wrapper.items[0].deliveryDateEx, [
//                                           dd,
//                                           '/',
//                                           mm,
//                                           '/',
//                                           yyyy,
//                                           ' ',
//                                           HH,
//                                           ':',
//                                           nn
//                                         ])}",
//                                     fontWeight: 600,
//                                     fontSize: titleFontSize,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           tilePadding: EdgeInsets.zero,
//                           childrenPadding: EdgeInsets.all(10),
//                           children: wrapper.items.map((e) {
//                             return _buildJobDetailItemByGroup(wrapper, e);
//                           }).toList(),
//                         ),
//                         FxSpacing.height(10),
//                         (wrapper.items[0].remark.isNotEmpty)
//                             ? FxContainer(
//                                 color: Colors.red.shade100,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     FxText(
//                                       "หมายเหตุ : ",
//                                       xMuted: false,
//                                       fontSize: titleFontSize,
//                                       color: Colors.red,
//                                     ),
//                                     FxSpacing.width(2),
//                                     FxText(
//                                       wrapper.items[0].remark,
//                                       xMuted: false,
//                                       color: Colors.red,
//                                       fontSize: titleFontSize,
//                                       maxLines: 5,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Container(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildJobDetailItem(JobDetail job) {
//     var titleFontSize = 14.0;
//     return FxContainer.transparent(
//       onTap: () {
//         if (!job.isChecked) {
//           job.isChecked = true;
//           if (!controller.selectedJobIds.contains(job)) {
//             controller.selectedJobIds.add(job);
//           }
//         } else {
//           job.isChecked = false;
//           controller.selectedJobIds.remove(job);
//         }
//         setState(() {});
//       },
//       paddingAll: 0,
//       margin: FxSpacing.only(left: 10, right: 10),
//       bordered: false,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.white.withOpacity(0.9),
//                       Colors.white.withOpacity(0.8)
//                     ])),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // FxContainer(
//                         //     child: FxText.titleSmall(
//                         //         controller.getOrderStatusTitle(job.orderStatus),
//                         //         fontWeight: 600,
//                         //         color: Colors.white),
//                         //     paddingAll: 8,
//                         //     color: controller.getOrderStatusColor(job.orderStatus)),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     FxContainer.roundBordered(
//                                       paddingAll: 0,
//                                       child: job.isChecked
//                                           ? Icon(
//                                               Icons.check_circle,
//                                               size: 30,
//                                               color: Colors.blue,
//                                             )
//                                           : Icon(
//                                               Icons.circle,
//                                               size: 30,
//                                               color: Colors.blue.shade300,
//                                             ),
//                                     ),
//                                     FxSpacing.width(10),
//                                   ],
//                                 ),
//                                 FxSpacing.width(10),
//                                 Expanded(
//                                   child: Container(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 FxText.titleLarge(
//                                                   "${job.barcode}",
//                                                   fontWeight: 600,
//                                                   color: Colors.blue,
//                                                 ),
//                                                 FxSpacing.width(20),
//                                                 _buildCall(job)
//                                               ],
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             FxSpacing.height(10),
//                             Row(
//                               children: [
//                                 FxText(
//                                   "จำนวนสินค้า: ",
//                                   fontWeight: 600,
//                                   fontSize: titleFontSize,
//                                   color: Colors.grey,
//                                 ),
//                                 FxSpacing.width(10),
//                                 FxText(
//                                   "${job.qty}",
//                                   fontWeight: 600,
//                                   fontSize: titleFontSize,
//                                   color: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                             FxSpacing.height(10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         FontAwesomeIcons.route,
//                                         color: Colors.blue,
//                                         size: 20,
//                                       ),
//                                       FxSpacing.width(10),
//                                       FxText(
//                                         "${job.routeName}",
//                                         fontWeight: 600,
//                                         fontSize: titleFontSize,
//                                         color: Colors.grey,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             FxSpacing.height(10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         FontAwesomeIcons.calendar,
//                                         color: Colors.blue,
//                                         size: 20,
//                                       ),
//                                       FxSpacing.width(10),
//                                       FxText(
//                                         "${formatDate(job.deliveryDateEx, [
//                                               dd,
//                                               '/',
//                                               mm,
//                                               '/',
//                                               yyyy,
//                                               ' ',
//                                               HH,
//                                               ':',
//                                               nn
//                                             ])}",
//                                         fontWeight: 600,
//                                         fontSize: titleFontSize,
//                                         color: Colors.grey,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 FxContainer.transparent(
//                                   onTap: () {
//                                     controller.goToJobDetailPage(job);
//                                   },
//                                   paddingAll: 0,
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         FontAwesomeIcons.eye,
//                                         color: Colors.blue,
//                                         size: 20,
//                                       ),
//                                       FxSpacing.width(10),
//                                       FxText(
//                                         "View",
//                                         fontWeight: 600,
//                                         fontSize: titleFontSize,
//                                         color: Colors.blue,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                         FxSpacing.height(10),
//                         (job.remark.isNotEmpty)
//                             ? FxContainer(
//                                 color: Colors.red.shade100,
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     FxText(
//                                       "หมายเหตุ : ",
//                                       xMuted: false,
//                                       fontSize: titleFontSize,
//                                       color: Colors.red,
//                                     ),
//                                     FxSpacing.width(2),
//                                     FxText(
//                                       job.remark,
//                                       xMuted: false,
//                                       color: Colors.red,
//                                       fontSize: titleFontSize,
//                                       maxLines: 5,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Container(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _buildJobDetailItem(JobDetail job) {
//   //   var titleFontSize = 18.0;
//   //   return FxContainer.transparent(
//   //     onTap: () {
//   //       if (!job.isChecked) {
//   //         job.isChecked = true;
//   //         if (!controller.selectedJobIds.contains(job)) {
//   //           controller.selectedJobIds.add(job);
//   //         }
//   //       } else {
//   //         job.isChecked = false;
//   //         controller.selectedJobIds.remove(job);
//   //       }
//   //       setState(() {});
//   //     },
//   //     paddingAll: 0,
//   //     margin: FxSpacing.only(left: 10, right: 10),
//   //     bordered: false,
//   //     child: ClipRRect(
//   //       borderRadius: BorderRadius.circular(20),
//   //       child: BackdropFilter(
//   //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//   //         child: Container(
//   //           decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.circular(20),
//   //               gradient: LinearGradient(
//   //                   begin: Alignment.topLeft,
//   //                   end: Alignment.bottomRight,
//   //                   colors: [
//   //                     Colors.white.withOpacity(0.9),
//   //                     Colors.white.withOpacity(0.8)
//   //                   ])),
//   //           child: Padding(
//   //             padding: const EdgeInsets.all(20.0),
//   //             child: Row(
//   //               children: [
//   //                 Expanded(
//   //                   child: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       // FxContainer(
//   //                       //     child: FxText.titleSmall(
//   //                       //         controller.getOrderStatusTitle(job.orderStatus),
//   //                       //         fontWeight: 600,
//   //                       //         color: Colors.white),
//   //                       //     paddingAll: 8,
//   //                       //     color: controller.getOrderStatusColor(job.orderStatus)),
//   //                       FxSpacing.height(10),
//   //                       ExpansionTileNew(
//   //                         backgroundColor: Colors.transparent,
//   //                         title: Column(
//   //                           crossAxisAlignment: CrossAxisAlignment.stretch,
//   //                           children: [
//   //                             Row(
//   //                               children: [
//   //                                 Row(
//   //                                   children: [
//   //                                     FxContainer.roundBordered(
//   //                                       paddingAll: 0,
//   //                                       child: job.isChecked
//   //                                           ? Icon(
//   //                                               Icons.check_circle,
//   //                                               size: 30,
//   //                                               color: Colors.blue,
//   //                                             )
//   //                                           : Icon(
//   //                                               Icons.circle,
//   //                                               size: 30,
//   //                                               color: Colors.blue.shade300,
//   //                                             ),
//   //                                     ),
//   //                                     FxSpacing.width(10),
//   //                                   ],
//   //                                 ),
//   //                                 FxSpacing.width(10),
//   //                                 Expanded(
//   //                                   child: Container(
//   //                                     child: Row(
//   //                                       mainAxisAlignment:
//   //                                           MainAxisAlignment.spaceBetween,
//   //                                       crossAxisAlignment:
//   //                                           CrossAxisAlignment.start,
//   //                                       children: [
//   //                                         Column(
//   //                                           crossAxisAlignment:
//   //                                               CrossAxisAlignment.start,
//   //                                           children: [
//   //                                             Row(
//   //                                               children: [
//   //                                                 FxText.titleLarge(
//   //                                                   "${job.barcode}",
//   //                                                   fontWeight: 600,
//   //                                                   color: Colors.blue,
//   //                                                 ),
//   //                                                 // FxSpacing.width(10),
//   //                                                 // (job.remark.isNotEmpty)
//   //                                                 //     ? FxContainer.roundBordered(
//   //                                                 //         paddingAll: 0,
//   //                                                 //         color: Colors.red,
//   //                                                 //         child: Row(
//   //                                                 //           children: [
//   //                                                 //             Icon(
//   //                                                 //               FontAwesomeIcons
//   //                                                 //                   .exclamation,
//   //                                                 //               color: Colors.white,
//   //                                                 //               size: 15,
//   //                                                 //             ),
//   //                                                 //           ],
//   //                                                 //         ),
//   //                                                 //       )
//   //                                                 //     : Container(),
//   //                                               ],
//   //                                             ),
//   //                                           ],
//   //                                         )
//   //                                       ],
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                             FxSpacing.height(10),
//   //                             Row(
//   //                               mainAxisAlignment:
//   //                                   MainAxisAlignment.spaceBetween,
//   //                               children: [
//   //                                 Container(
//   //                                   child: Row(
//   //                                     children: [
//   //                                       Icon(
//   //                                         FontAwesomeIcons.calendar,
//   //                                         color: Colors.blue,
//   //                                         size: 20,
//   //                                       ),
//   //                                       FxSpacing.width(10),
//   //                                       FxText(
//   //                                         "${formatDate(job.deliveryDateEx, [
//   //                                               dd,
//   //                                               '/',
//   //                                               mm,
//   //                                               '/',
//   //                                               yyyy,
//   //                                               ' ',
//   //                                               HH,
//   //                                               ':',
//   //                                               nn
//   //                                             ])}",
//   //                                         fontWeight: 600,
//   //                                         fontSize: titleFontSize,
//   //                                         color: Colors.grey,
//   //                                       ),
//   //                                     ],
//   //                                   ),
//   //                                 ),
//   //                                 FxContainer.transparent(
//   //                                   onTap: () {
//   //                                     controller.goToJobDetailPage(job);
//   //                                   },
//   //                                   paddingAll: 0,
//   //                                   child: Row(
//   //                                     children: [
//   //                                       Icon(
//   //                                         FontAwesomeIcons.eye,
//   //                                         color: Colors.blue,
//   //                                         size: 20,
//   //                                       ),
//   //                                       FxSpacing.width(10),
//   //                                       FxText(
//   //                                         "View",
//   //                                         fontWeight: 600,
//   //                                         fontSize: titleFontSize,
//   //                                         color: Colors.blue,
//   //                                       ),
//   //                                     ],
//   //                                   ),
//   //                                 )
//   //                               ],
//   //                             ),
//   //                           ],
//   //                         ),
//   //                         tilePadding: EdgeInsets.zero,
//   //                         childrenPadding: EdgeInsets.all(10),
//   //                         children: [
//   //                           (job.reference3.isNotEmpty)
//   //                               ? Row(
//   //                                   crossAxisAlignment:
//   //                                       CrossAxisAlignment.start,
//   //                                   children: [
//   //                                     FxText(
//   //                                       "อ้างอิง3 : ",
//   //                                       fontSize: titleFontSize,
//   //                                       xMuted: false,
//   //                                     ),
//   //                                     FxSpacing.width(2),
//   //                                     Flexible(
//   //                                       child: FxText(
//   //                                         job.reference3,
//   //                                         xMuted: true,
//   //                                         maxLines: 2,
//   //                                         fontSize: titleFontSize,
//   //                                         overflow: TextOverflow.ellipsis,
//   //                                       ),
//   //                                     ),
//   //                                   ],
//   //                                 )
//   //                               : Container(),
//   //                           Row(
//   //                             children: [
//   //                               FxText(
//   //                                 "วันที่บิล : ",
//   //                                 fontSize: titleFontSize,
//   //                                 xMuted: false,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 "${formatDate(job.receiveDateEx, [
//   //                                       dd,
//   //                                       '/',
//   //                                       mm,
//   //                                       '/',
//   //                                       yyyy,
//   //                                       ' ',
//   //                                       HH,
//   //                                       ':',
//   //                                       nn
//   //                                     ])}",
//   //                                 xMuted: true,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           Row(
//   //                             children: [
//   //                               FxText(
//   //                                 "วันที่ใบคุม : ",
//   //                                 fontSize: titleFontSize,
//   //                                 xMuted: false,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText.titleMedium(
//   //                                 "${formatDate(job.deliveryDocumentDateEx, [
//   //                                       dd,
//   //                                       '/',
//   //                                       mm,
//   //                                       '/',
//   //                                       yyyy,
//   //                                       ' ',
//   //                                       HH,
//   //                                       ':',
//   //                                       nn
//   //                                     ])}",
//   //                                 xMuted: true,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           Row(
//   //                             children: [
//   //                               FxText(
//   //                                 "วันที่สร้าง : ",
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 "${formatDate(job.createdDateFromServerEx, [
//   //                                       dd,
//   //                                       '/',
//   //                                       mm,
//   //                                       '/',
//   //                                       yyyy,
//   //                                       ' ',
//   //                                       HH,
//   //                                       ':',
//   //                                       nn
//   //                                     ])}",
//   //                                 xMuted: true,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           Row(
//   //                             crossAxisAlignment: CrossAxisAlignment.start,
//   //                             children: [
//   //                               FxText(
//   //                                 "หมายเลขงาน : ",
//   //                                 fontSize: titleFontSize,
//   //                                 xMuted: false,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               Flexible(
//   //                                 child: FxText(
//   //                                   job.jobNumber,
//   //                                   xMuted: true,
//   //                                   maxLines: 2,
//   //                                   fontSize: titleFontSize,
//   //                                   overflow: TextOverflow.ellipsis,
//   //                                 ),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           Row(
//   //                             children: [
//   //                               FxText(
//   //                                 "จำนวนสินค้า : ",
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 job.qty.toString(),
//   //                                 xMuted: true,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           FxSpacing.height(10),
//   //                           Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.stretch,
//   //                             children: [
//   //                               FxText(
//   //                                 "ลูกค้า : ",
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 job.customerName,
//   //                                 xMuted: true,
//   //                                 maxLines: 2,
//   //                                 fontSize: titleFontSize,
//   //                                 overflow: TextOverflow.ellipsis,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           FxSpacing.height(5),
//   //                           Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.stretch,
//   //                             children: [
//   //                               FxText(
//   //                                 "รายละเอียดสินค้า : ",
//   //                                 textAlign: TextAlign.start,
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               // FxSpacing.width(2),
//   //                               FxText(
//   //                                 (job.goodsDetails.isNotEmpty)
//   //                                     ? job.goodsDetails
//   //                                     : 'ไม่มี',
//   //                                 xMuted: true,
//   //                                 maxLines: 2,
//   //                                 overflow: TextOverflow.ellipsis,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           FxSpacing.height(10),
//   //                           // FxDashedDivider(),
//   //                           // FxSpacing.height(10),
//   //                           Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.stretch,
//   //                             children: [
//   //                               FxText(
//   //                                 "ชื่อผู้รับ : ",
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 job.receiverName,
//   //                                 xMuted: true,
//   //                                 fontSize: titleFontSize,
//   //                                 maxLines: 2,
//   //                                 overflow: TextOverflow.ellipsis,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                           FxSpacing.height(5),
//   //                           Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.stretch,
//   //                             children: [
//   //                               FxText(
//   //                                 "ที่อยู่ผู้รับ : ",
//   //                                 xMuted: false,
//   //                                 fontSize: titleFontSize,
//   //                               ),
//   //                               FxSpacing.width(2),
//   //                               FxText(
//   //                                 job.receiverFullAddress,
//   //                                 xMuted: true,
//   //                                 maxLines: 10,
//   //                                 fontSize: titleFontSize,
//   //                                 overflow: TextOverflow.ellipsis,
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       FxSpacing.height(10),
//   //                       (job.remark.isNotEmpty)
//   //                           ? FxContainer(
//   //                               color: Colors.red.shade100,
//   //                               child: Column(
//   //                                 crossAxisAlignment:
//   //                                     CrossAxisAlignment.stretch,
//   //                                 children: [
//   //                                   FxText(
//   //                                     "หมายเหตุ : ",
//   //                                     xMuted: false,
//   //                                     fontSize: titleFontSize,
//   //                                     color: Colors.red,
//   //                                   ),
//   //                                   FxSpacing.width(2),
//   //                                   FxText(
//   //                                     job.remark,
//   //                                     xMuted: false,
//   //                                     color: Colors.red,
//   //                                     fontSize: titleFontSize,
//   //                                     maxLines: 5,
//   //                                     overflow: TextOverflow.ellipsis,
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                             )
//   //                           : Container(),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildJobDetailItemByGroup(JobDetailWrapper wrapper, JobDetail job) {
//     var titleFontSize = 14.0;
//     return FxContainer.transparent(
//       onTap: () {
//         if (!job.isChecked) {
//           job.isChecked = true;
//           if (!controller.selectedJobIds.contains(job))
//             controller.selectedJobIds.add(job);
//         } else {
//           job.isChecked = false;
//           controller.selectedJobIds.remove(job);
//         }
//         wrapper.isChecked =
//             wrapper.items.where((element) => element.isChecked).length ==
//                 wrapper.items.length;
//         setState(() {});
//       },
//       paddingAll: 0,
//       margin: FxSpacing.only(left: 10, right: 10),
//       bordered: false,
//       child: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   FxSpacing.height(10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Row(
//                         children: [
//                           Row(
//                             children: [
//                               FxContainer.roundBordered(
//                                 paddingAll: 0,
//                                 child: job.isChecked
//                                     ? Icon(
//                                         Icons.check_circle,
//                                         size: 30,
//                                         color: Colors.blue,
//                                       )
//                                     : Icon(
//                                         Icons.circle,
//                                         size: 30,
//                                         color: Colors.blue.shade300,
//                                       ),
//                               ),
//                               FxSpacing.width(10),
//                             ],
//                           ),
//                           FxSpacing.width(10),
//                           Expanded(
//                             child: Container(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Flexible(
//                                         child: Column(
//                                           children: [
//                                             FxText(
//                                               "${job.receiverName}",
//                                               fontWeight: 600,
//                                               fontSize: titleFontSize,
//                                               color: Colors.blue,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Column(
//                                         children: [
//                                           (job.directionType == 1)
//                                               ? FxContainer.bordered(
//                                                   bordered: false,
//                                                   color: Colors.red.shade300,
//                                                   paddingAll: 5,
//                                                   child: FxText("จัดส่ง",
//                                                       fontSize: titleFontSize,
//                                                       color: Colors.white))
//                                               : FxContainer.bordered(
//                                                   bordered: false,
//                                                   color: Colors.red.shade300,
//                                                   paddingAll: 5,
//                                                   child: FxText("รับคืน",
//                                                       fontSize: titleFontSize,
//                                                       color: Colors.white)),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       FxSpacing.height(10),
//                       Row(
//                         children: [
//                           FxText(
//                             "จำนวนสินค้า: ",
//                             fontWeight: 600,
//                             fontSize: titleFontSize,
//                             color: Colors.grey,
//                           ),
//                           FxSpacing.width(10),
//                           FxText(
//                             "${job.qty}",
//                             fontWeight: 600,
//                             fontSize: titleFontSize,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           FxText(
//                             "รายละเอียดสินค้า: ",
//                             fontWeight: 600,
//                             fontSize: titleFontSize,
//                             color: Colors.grey,
//                           ),
//                           FxSpacing.width(10),
//                           FxText(
//                             "${job.goodsDetails}",
//                             fontWeight: 600,
//                             fontSize: titleFontSize,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             FxSpacing.width(10),
//             FxContainer.transparent(
//                 onTap: () {
//                   controller.goToJobDetailPage(job);
//                 },
//                 paddingAll: 0,
//                 child: Icon(
//                   FontAwesomeIcons.eye,
//                   color: Colors.blue,
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildJobList() {
//     // if (controller.selectedJobType == SendJobTypes.customer ||
//     //     controller.selectedJobType == SendJobTypes.receiver) {
//     //   return ListView.builder(
//     //       controller: _scrollController,
//     //       padding: FxSpacing.top(200),
//     //       itemCount: controller.filteredJobs.length,
//     //       itemBuilder: (context, index) {
//     //         return Column(
//     //           children: [
//     //             _buildJobDetailWrapperItem(controller.filteredJobs[index]),
//     //             FxSpacing.height(10)
//     //           ],
//     //         );
//     //       });
//     // } else
//     if (controller.selectedJobType == SendJobTypes.group_barcode) {
//       //var groupListItems = controller.filteredJobs.toJobDetailWrapper(JobDetailGroupBy.barcode);
//       return ListView.builder(
//           controller: _scrollController,
//           padding: FxSpacing.top(160),
//           itemCount: controller.filteredJobs.length,
//           itemBuilder: (context, index) {
//             return Column(
//               children: [
//                 _buildJobDetailWrapperItem(controller.filteredJobs[index]),
//                 FxSpacing.height(10)
//               ],
//             );
//           });
//       // return GroupedListView<JobDetail, String>(
//       //   padding: FxSpacing.top(40),
//       //   controller: _scrollController,
//       //   elements: controller.filteredJobs,
//       //   groupBy: (element) => element.barcode,
//       //   groupSeparatorBuilder: (String groupByValue) {
//       //     return Column(
//       //       crossAxisAlignment: CrossAxisAlignment.stretch,
//       //       children: [
//       //         FxContainer(
//       //           color: SLColor.LIGHTBLUE2,
//       //           child: FxText('# $groupByValue',
//       //               color: Colors.white, fontSize: 21),
//       //         ),
//       //         FxSpacing.height(20)
//       //       ],
//       //     );
//       //   },
//       //   itemBuilder: (context, element) {
//       //     return Column(
//       //       children: [
//       //         _buildJobDetailWrapperItem(element),
//       //         FxSpacing.height(20)
//       //       ],
//       //     );
//       //   },
//       //   // itemComparator: (item1, item2) =>
//       //   //     item1['name'].compareTo(item2['name']), // optional
//       //   useStickyGroupSeparators: false, // optional
//       //   floatingHeader: true, // optional
//       //   order: GroupedListOrder.ASC, // optional
//       // );
//     }
//     return Container();
//     // return ListView.builder(
//     //     controller: _scrollController,
//     //     padding: FxSpacing.top(200),
//     //     itemCount: controller.filteredJobs.length,
//     //     itemBuilder: (context, index) {
//     //       return Column(
//     //         children: [
//     //           _buildJobDetailWrapperItem(controller.filteredJobs[index]),
//     //           FxSpacing.height(10)
//     //         ],
//     //       );
//     //     });
//     // if (controller.toggleSendJobButton) {
//     //   var jobs = controller.jobs.toJobDetailList();
//     //   return ListView.builder(
//     //       controller: _scrollController,
//     //       padding: FxSpacing.top(295),
//     //       itemCount: controller.jobs.length,
//     //       itemBuilder: (context, index) {
//     //         return Column(
//     //           children: [
//     //             _buildJobDetailWrapperItem(jobs[index], false),
//     //             FxSpacing.height(10)
//     //           ],
//     //         );
//     //       });
//     // }

//     // return ListView.builder(
//     //     controller: _scrollController,
//     //     padding: FxSpacing.top(295),
//     //     itemCount: controller.jobs.length,
//     //     itemBuilder: (context, index) {
//     //       return Column(
//     //         children: [
//     //           _buildJobDetailWrapperItem(controller.jobs[index].items[0],
//     //               controller.jobs[index].items.length > 1),
//     //           FxSpacing.height(10)
//     //         ],
//     //       );
//     //     });
//   }

//   Widget _buildBody() {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if ((_scrollController.hasClients)) {
//     //     _scrollController.addListener(() {
//     //       _appBarAnimationController.animateTo(_scrollController.offset / 60);
//     //     });
//     //     _scrollController.position.isScrollingNotifier.addListener(() {
//     //       if (!_scrollController.position.isScrollingNotifier.value) {
//     //         if (_scrollController.offset > 30 &&
//     //             _scrollController.offset < 60) {
//     //           _appBarAnimationController.animateTo(1,
//     //               duration: Duration(milliseconds: 300), curve: Curves.ease);
//     //           _scrollController.animateTo(60,
//     //               duration: Duration(milliseconds: 300), curve: Curves.ease);
//     //         } else {
//     //           if (_scrollController.offset < 30) {
//     //             _appBarAnimationController.animateTo(0,
//     //                 duration: Duration(milliseconds: 300), curve: Curves.ease);
//     //             _scrollController.animateTo(0,
//     //                 duration: Duration(milliseconds: 300), curve: Curves.ease);
//     //           }
//     //         }
//     //       } else {
//     //         print('scroll is started');
//     //       }
//     //     });
//     //   }
//     // });
//     final scanWindow = Rect.fromCenter(
//       center: MediaQuery.of(context).size.center(Offset.zero),
//       width: 300,
//       height: 200,
//     );

//     var color = controller.getOrderStatusColor(controller.selectedJobStatus);

//     return Stack(children: [
//       (controller.showLoading)
//           ? SingleChildScrollView(
//               padding: FxSpacing.top(160),
//               child: LoadingEffect.getSearchLoadingScreen(
//                 context,
//               ))
//           : (controller.selectionJobType == SelectionJobTypes.camera &&
//                   !controller.isShowList)
//               ? Stack(
//                   children: [
//                     MobileScanner(
//                         controller: _mobileScannerController,
//                         onDetect: (barcode) async {
//                           if (barcode.barcodes.length > 0) {
//                             final String? code = barcode.barcodes[0].rawValue;
//                             _mobileScannerController.stop();

//                             var items =
//                                 await controller.searchJobByBarcode(code!);

//                             if (items.length > 0) {
//                               var foundItem = items.where((item1) {
//                                 return controller.selectedJobIds
//                                     .contains(item1);
//                               });
//                               if (foundItem.length > 0) {
//                                 showDialog(
//                                     context: context,
//                                     builder: (context) =>
//                                         showDuplicateScanBarcode(
//                                             context, items));
//                               } else {
//                                 showDialog(
//                                     context: context,
//                                     builder: (context) =>
//                                         showConfirmScanBarcode(context, items));
//                               }
//                             } else {}
//                           }
//                         }),
//                     CustomPaint(
//                       painter: ScannerOverlay(scanWindow),
//                     )
//                   ],
//                 )
//               : Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/sailom/login_bg.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Container(
//                       color: Colors.black.withOpacity(0.5),
//                       child: _buildJobList())),
//       Container(
//         height: 160,
//         child: Column(
//           children: [
//             ClipRect(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: FxContainer.transparent(
//                   bordered: false,
//                   borderRadiusAll: 10,
//                   margin:
//                       FxSpacing.only(top: 10, left: 10, right: 10, bottom: 10),
//                   // color: SLColor.LIGHTBLUE2.withOpacity(0.7),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: FxSpacing.all(10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     color.withAlpha(255),
//                                     color.withAlpha(160),
//                                   ],
//                                   stops: [
//                                     1,
//                                     0.1
//                                   ]),
//                             ),
//                             // onTap: () {
//                             //   _selectSizeSheet();
//                             // },
//                             child: Row(
//                               children: [
//                                 (controller.selectedJobStatus ==
//                                         JobStatus.SENDING)
//                                     ? Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 10),
//                                         child: Icon(
//                                           FontAwesomeIcons.boxesPacking,
//                                           color: Colors.white,
//                                           size: 15,
//                                         ),
//                                       )
//                                     : Container(),
//                                 (controller.selectedJobStatus == JobStatus.SENT)
//                                     ? Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 15),
//                                         child: Icon(FontAwesomeIcons.paperPlane,
//                                             color: Colors.white),
//                                       )
//                                     : Container(),
//                                 (controller.selectedJobStatus ==
//                                         JobStatus.REJECT_SENDING)
//                                     ? Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 10),
//                                         child: Icon(FontAwesomeIcons.ban,
//                                             color: Colors.white),
//                                       )
//                                     : Container(),
//                                 FxText.titleSmall(
//                                     '${controller.getOrderStatusTitle(controller.selectedJobStatus)} (${controller.jobs.length})',
//                                     color: Colors.white),
//                               ],
//                             ),
//                             // paddingAll: 8,
//                             // color: controller.getOrderStatusColor(
//                             //     controller.selectedJobStatus)
//                           ),
//                           Row(
//                             children: [
//                               // FxSpacing.width(10),
//                               // FxContainer.bordered(
//                               //   onTap: () {
//                               //     showDialog(
//                               //         context: context,
//                               //         builder: (context) =>
//                               //             clearSelectionDialog(context));
//                               //   },
//                               //   color: Colors.red.shade100,
//                               //   paddingAll: 4,
//                               //   child: Row(
//                               //     children: [
//                               //       Icon(FontAwesomeIcons.circleXmark,
//                               //           color: Colors.red),
//                               //       FxSpacing.width(10),
//                               //       FxContainer.transparent(
//                               //         paddingAll: 2,
//                               //         child: FxText.titleMedium(
//                               //           '${controller.selectedJobIds.length}',
//                               //           fontWeight: 700,
//                               //           fontSize: 16,
//                               //           color: Colors.red,
//                               //         ),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//                               // FxSpacing.width(10),
//                               // FxContainer.transparent(
//                               //     onTap: () {
//                               //       _selectQuickAction();
//                               //     },
//                               //     paddingAll: 0,
//                               //     child: Icon(FontAwesomeIcons.list,
//                               //         color: Colors.white)),
//                             ],
//                           ),
//                         ],
//                       ),
//                       // FxSpacing.height(10),
//                       // Row(
//                       //   children: [
//                       //     // Expanded(child: _buildSearchWidget()),
//                       //     // FxSpacing.width(10),
//                       //     FxContainer.transparent(
//                       //         onTap: () {
//                       //           if (controller.selectionJobType !=
//                       //               SelectionJobTypes.camera) {
//                       //             showDialog(
//                       //                 context: context,
//                       //                 builder: (context) =>
//                       //                     showSelectionTypeDialog(context));
//                       //           } else {
//                       //             controller.toggleSendJobButtonFunc(
//                       //                 SelectionJobTypes.list);
//                       //           }
//                       //         },
//                       //         paddingAll: 0,
//                       //         child: Icon(FontAwesomeIcons.camera,
//                       //             color: (controller.selectionJobType ==
//                       //                     SelectionJobTypes.camera)
//                       //                 ? Colors.green.shade200
//                       //                 : Colors.white)),
//                       //     FxSpacing.width(10),
//                       //     FxContainer.transparent(
//                       //         onTap: () {
//                       //           controller.reloadAllJobs(forceReload: true);
//                       //         },
//                       //         paddingAll: 0,
//                       //         child: Icon(FontAwesomeIcons.arrowRotateRight,
//                       //             color: Colors.white)),
//                       //   ],
//                       // )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       )
//       // Container(
//       //   child: AnimatedBuilder(
//       //     animation: _appBarAnimationController,
//       //     builder: (context, child) {
//       //       return FxContainer(
//       //           padding: FxSpacing.all(10),
//       //           borderRadius: BorderRadius.only(
//       //               bottomLeft: Radius.circular(20),
//       //               bottomRight: Radius.circular(20)),
//       //           color: SLColor.LIGHTBLUE2,
//       //           child: _appBar(),
//       //           height: 160 - _appBarAnimation.value);
//       //     },
//       //   ),
//       // )
//     ]);
//   }

//   Widget _buildSearchWidget() {
//     // if (controller.selectedJobType == SendJobTypes.group_barcode) {
//     //   var jobs = controller.jobs.toJobDetailWrapper(JobDetailGroupBy.barcode);
//     //   return Card(
//     //     margin: FxSpacing.zero,
//     //     child: TypeAheadField(
//     //       suggestionsBoxController: _suggestBoxController,
//     //       hideOnEmpty: true,
//     //       keepSuggestionsOnSuggestionSelected: true,
//     //       hideKeyboard: true,
//     //       textFieldConfiguration: TextFieldConfiguration(
//     //         style: TextStyle(fontFamily: 'Kanit'),
//     //         controller: _customerSearchController,
//     //         decoration: InputDecoration(
//     //             contentPadding: FxSpacing.only(left: 20),
//     //             labelStyle: TextStyle(fontFamily: 'Kanit'),
//     //             hintStyle: TextStyle(fontFamily: 'Kanit'),
//     //             counterStyle: TextStyle(fontFamily: 'Kanit'),
//     //             suffixIcon: FxContainer.transparent(
//     //               padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
//     //               onTap: () async {
//     //                 controller.selectedJobIds = [];
//     //                 _suggestBoxController.close();
//     //               },
//     //               child: Icon(FontAwesomeIcons.xmark,
//     //                   color: customTheme.medicarePrimary, size: 20),
//     //             ),
//     //             border: OutlineInputBorder(),
//     //             hintText: 'ค้นหาบาร์โค้ด'),
//     //       ),
//     //       suggestionsCallback: (pattern) {
//     //         return jobs.where((data) =>
//     //             data.title.toLowerCase().contains(pattern.toLowerCase()));
//     //       },
//     //       noItemsFoundBuilder: (context) {
//     //         return Container(
//     //             color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
//     //       },
//     //       itemBuilder: (context, JobDetailWrapper suggestion) {
//     //         return StatefulBuilder(builder: (context, setState) {
//     //           return Container(
//     //             color: Colors.white,
//     //             child: Column(
//     //               crossAxisAlignment: CrossAxisAlignment.stretch,
//     //               children: [
//     //                 ListTile(
//     //                     title: Column(
//     //                   crossAxisAlignment: CrossAxisAlignment.start,
//     //                   children: [
//     //                     Row(
//     //                       children: [
//     //                         Checkbox(
//     //                           value: suggestion.isChecked,
//     //                           onChanged: (value) {},
//     //                         ),
//     //                         FxText('# ${suggestion.title}',
//     //                             fontSize: 21, color: Colors.blue),
//     //                       ],
//     //                     ),
//     //                     FxText(suggestion.items[0].receiverAddress,
//     //                         fontSize: 18, muted: true)
//     //                   ],
//     //                 )),
//     //                 Divider(height: 2)
//     //               ],
//     //             ),
//     //           );
//     //         });
//     //       },
//     //       onSuggestionSelected: (JobDetailWrapper suggestion) {
//     //         // if (!controller.selectedGroupBarcode.contains(suggestion)) {
//     //         //   controller.selectedGroupBarcode.add(suggestion);
//     //         // } else {
//     //         //   controller.selectedGroupBarcode.remove(suggestion);
//     //         // }

//     //         // controller.filteredJobs = controller.jobs.where((element) {
//     //         //   var foundItem = controller.selectedGroupBarcode
//     //         //       .where((element2) => element.barcode == element2.title);
//     //         //   return foundItem.length > 0;
//     //         // }).toList();

//     //         // setState(() {
//     //         //   suggestion.isChecked = suggestion.isChecked;
//     //         // });
//     //       },
//     //     ),
//     //   );
//     // } else if (controller.selectedJobType == SendJobTypes.customer) {
//     //   var customers =
//     //       controller.jobs.toJobDetailWrapper(JobDetailGroupBy.customer);
//     //   return Card(
//     //     margin: FxSpacing.zero,
//     //     child: TypeAheadField(
//     //       textFieldConfiguration: TextFieldConfiguration(
//     //         style: TextStyle(fontFamily: 'Kanit'),
//     //         controller: _customerSearchController,
//     //         decoration: InputDecoration(
//     //             contentPadding: FxSpacing.only(left: 20),
//     //             labelStyle: TextStyle(fontFamily: 'Kanit'),
//     //             hintStyle: TextStyle(fontFamily: 'Kanit'),
//     //             counterStyle: TextStyle(fontFamily: 'Kanit'),
//     //             suffixIcon: FxContainer.transparent(
//     //               padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
//     //               onTap: () async {
//     //                 _customerSearchController.clear();
//     //                 controller.selectedJobIds = [];
//     //                 controller.searchJobs("", controller.selectedJobStatus);
//     //               },
//     //               child: Icon(FontAwesomeIcons.xmark,
//     //                   color: customTheme.medicarePrimary, size: 20),
//     //             ),
//     //             border: OutlineInputBorder(),
//     //             hintText: 'ค้นหาลูกค้า'),
//     //       ),
//     //       suggestionsCallback: (pattern) {
//     //         return customers.where((data) =>
//     //             data.title.toLowerCase().contains(pattern.toLowerCase()));
//     //       },
//     //       noItemsFoundBuilder: (context) {
//     //         return Container(
//     //             color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
//     //       },
//     //       itemBuilder: (context, JobDetailWrapper suggestion) {
//     //         return Container(
//     //           color: Colors.white,
//     //           child: ListTile(title: FxText(suggestion.title)),
//     //         );
//     //       },
//     //       onSuggestionSelected: (JobDetailWrapper suggestion) {
//     //         _customerSearchController.text = suggestion.title;
//     //         controller.searchJobs(
//     //             _customerSearchController.text, controller.selectedJobStatus);
//     //       },
//     //     ),
//     //   );
//     // } else if (controller.selectedJobType == SendJobTypes.receiver) {
//     //   var receivers =
//     //       controller.jobs.toJobDetailWrapper(JobDetailGroupBy.receiver);
//     //   return Card(
//     //     margin: FxSpacing.zero,
//     //     child: TypeAheadField(
//     //       textFieldConfiguration: TextFieldConfiguration(
//     //         style: TextStyle(fontFamily: 'Kanit'),
//     //         controller: _customerSearchController,
//     //         decoration: InputDecoration(
//     //             contentPadding: FxSpacing.only(left: 20),
//     //             labelStyle: TextStyle(fontFamily: 'Kanit'),
//     //             hintStyle: TextStyle(fontFamily: 'Kanit'),
//     //             counterStyle: TextStyle(fontFamily: 'Kanit'),
//     //             suffixIcon: FxContainer.transparent(
//     //               padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
//     //               onTap: () async {
//     //                 _customerSearchController.clear();
//     //                 controller.selectedJobIds = [];
//     //                 controller.searchJobs("", controller.selectedJobStatus);
//     //               },
//     //               child: Icon(FontAwesomeIcons.xmark,
//     //                   color: customTheme.medicarePrimary, size: 20),
//     //             ),
//     //             border: OutlineInputBorder(),
//     //             hintText: 'ค้นหาลูกค้าปลายทาง'),
//     //       ),
//     //       suggestionsCallback: (pattern) {
//     //         return receivers.where((data) =>
//     //             data.title.toLowerCase().contains(pattern.toLowerCase()));
//     //       },
//     //       noItemsFoundBuilder: (context) {
//     //         return Container(
//     //             color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
//     //       },
//     //       itemBuilder: (context, JobDetailWrapper suggestion) {
//     //         return Container(
//     //           color: Colors.white,
//     //           child: ListTile(title: FxText(suggestion.title)),
//     //         );
//     //       },
//     //       onSuggestionSelected: (JobDetailWrapper suggestion) {
//     //         _customerSearchController.text = suggestion.title;
//     //         controller.searchJobs(
//     //             _customerSearchController.text, controller.selectedJobStatus);
//     //       },
//     //     ),
//     //   );
//     // }
//     return FxTextField(
//       controller: _searchTextController,
//       contentPadding: EdgeInsets.zero,
//       focusedBorderColor: customTheme.medicarePrimary,
//       cursorColor: customTheme.medicarePrimary,
//       textFieldStyle: FxTextFieldStyle.outlined,
//       labelText: 'หมายเลขออเดอร์ , อ้างอิง3',
//       autofocus: false,
//       labelStyle: FxTextStyle.bodyMedium(
//           color: theme.colorScheme.onBackground, xMuted: true),
//       floatingLabelBehavior: FloatingLabelBehavior.never,
//       filled: true,
//       fillColor: customTheme.card,
//       prefixIcon: Icon(
//         FeatherIcons.search,
//         color: customTheme.medicarePrimary,
//         size: 20,
//       ),
//       onChanged: (value) {
//         controller.searchJobs(value, controller.selectedJobStatus);
//       },
//       suffixIcon: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           (_searchTextController.text.isEmpty)
//               ? Container()
//               : FxContainer.transparent(
//                   padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
//                   onTap: () async {
//                     FocusScope.of(context).unfocus();
//                     _searchTextController.clear();
//                     controller.searchJobs(_searchTextController.text,
//                         controller.selectedJobStatus);
//                     //controller.reloadAllJobs();
//                   },
//                   child: Icon(FontAwesomeIcons.xmark,
//                       color: customTheme.medicarePrimary, size: 20),
//                 ),
//           FxContainer.transparent(
//             padding: FxSpacing.only(right: 10),
//             onTap: () async {
//               try {
//                 _searchTextController.text =
//                     await FlutterBarcodeScanner.scanBarcode(
//                         "#ff6666", "Cancel", true, ScanMode.BARCODE);
//                 //print(barcodeScanRes);
//                 controller.searchJobs(
//                     _searchTextController.text, controller.selectedJobStatus);
//               } on PlatformException {
//                 // barcodeScanRes =
//                 //     'Failed to get platform version.';
//               }
//             },
//             child: Icon(FontAwesomeIcons.barcode,
//                 color: customTheme.medicarePrimary, size: 20),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _appBar() {
//     return Stack(
//       children: [
//         AnimatedBuilder(
//           animation: _appBarAnimationController,
//           builder: (context, child) {
//             return SingleChildScrollView(
//               physics: NeverScrollableScrollPhysics(),
//               // padding: EdgeInsets.only(top: 50),
//               child: Column(
//                 children: [
//                   // FxSpacing.height(20),
//                   Column(
//                     children: [
//                       // GestureDetector(
//                       //   onTap: () {
//                       //     showModalBottomSheet<void>(
//                       //       isScrollControlled: true,
//                       //       context: context,
//                       //       builder: (BuildContext context) {
//                       //         return showPopup(controller);
//                       //         //return Container();
//                       //       },
//                       //     );
//                       //   },
//                       //   child: Opacity(
//                       //     opacity: 1.0 - _appBarAnimation.value / 60,
//                       //     child: Container(
//                       //       // margin: EdgeInsets.only(top: 10),
//                       //       width: MediaQuery.of(context).size.width,
//                       //       height: 60,
//                       //       child: Column(
//                       //         crossAxisAlignment: CrossAxisAlignment.center,
//                       //         children: [
//                       //           FxText.bodySmall(
//                       //             'สายส่ง',
//                       //             color: Colors.white,
//                       //             xMuted: false,
//                       //             fontSize: 16,
//                       //           ),
//                       //           Row(
//                       //             mainAxisAlignment: MainAxisAlignment.center,
//                       //             children: [
//                       //               Icon(
//                       //                 Icons.local_shipping,
//                       //                 color: Colors.white,
//                       //                 size: 21,
//                       //               ),
//                       //               FxSpacing.width(4),
//                       //               FxText.bodySmall(
//                       //                 (appController.selectedRouteLine != null)
//                       //                     ? appController
//                       //                         .selectedRouteLine!.routename
//                       //                     : "",
//                       //                 fontSize: 16,
//                       //                 color: Colors.white,
//                       //                 fontWeight: 600,
//                       //               ),
//                       //               FxSpacing.width(4),
//                       //               Icon(
//                       //                 Icons.arrow_drop_down,
//                       //                 color: Colors.white,
//                       //                 size: 21,
//                       //               ),
//                       //             ],
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       Opacity(
//                         opacity: 1.0 - _appBarAnimation.value / 60,
//                         child: Container(
//                           color: Colors.transparent,
//                           child: Padding(
//                               padding: FxSpacing.horizontal(10),
//                               child: _buildSearchWidget()),
//                         ),
//                       ),
//                       Transform.translate(
//                         offset: Offset(0, -_appBarAnimation.value),
//                         child: Container(
//                           padding: FxSpacing.only(top: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               FxContainer.transparent(
//                                 child: Column(children: [
//                                   Icon(Icons.qr_code_scanner,
//                                       color: Colors.white, size: 40),
//                                   FxText.titleSmall(
//                                     "สแกนรับงาน",
//                                     color: Colors.white,
//                                   )
//                                 ]),
//                               ),
//                               FxContainer.transparent(
//                                 onTap: () {
//                                   _searchTextController.text = "";
//                                   controller.reloadAllJobs(forceReload: true);
//                                 },
//                                 child: Column(children: [
//                                   Icon(Icons.sync,
//                                       color: Colors.white, size: 40),
//                                   FxText.titleSmall(
//                                     "โหลดงาน",
//                                     color: Colors.white,
//                                   )
//                                 ]),
//                               ),
//                               FxContainer.transparent(
//                                 onTap: () {
//                                   _selectSizeSheet();
//                                 },
//                                 child: Column(children: [
//                                   Icon(Icons.tune,
//                                       color: Colors.white, size: 40),
//                                   FxText.titleSmall(
//                                     "Filters",
//                                     color: Colors.white,
//                                   )
//                                 ]),
//                               ),
//                               AbsorbPointer(
//                                 absorbing: (controller.selectedJobStatus ==
//                                     JobStatus.SENT),
//                                 child: Opacity(
//                                   opacity: (controller.selectedJobStatus ==
//                                           JobStatus.SENT)
//                                       ? 0.5
//                                       : 1.0,
//                                   child: FxContainer.transparent(onTap: () {
//                                     // if (controller.toggleSendJobButton) {
//                                     //   _showSendJobByConfirmDialog();
//                                     // } else {
//                                     //   _showSendJobByDialog();
//                                     // }
//                                   }),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         )
//       ],
//     );
//   }

//   void _sendJobCommand(int jobType) {
//     if (controller.selectedJobIds.length == 0) {
//       showDialog(
//           context: context, builder: (context) => showSendJobRequired(context));
//     } else {
//       Navigator.of(NavigationService.navigatorKey.currentState!.context)
//           .pushNamed("/send_job", arguments: {
//         "jobType": jobType,
//         "jobs": controller.selectedJobIds
//       });
//     }
//   }

//   List<Widget> _buildQuickActionMenuList(setState) {
//     List<Widget> list = [
//       Column(
//         children: [
//           FxContainer.roundBordered(
//               onTap: () {
//                 _sendJobCommand(SendJobType.NORMAL);
//               },
//               color: Colors.white,
//               child: Icon(FontAwesomeIcons.upload, color: Colors.green)),
//           FxSpacing.height(10),
//           FxText.titleMedium("ส่งงาน", color: Colors.white)
//         ],
//       ),
//       Column(
//         children: [
//           FxContainer.roundBordered(
//               onTap: () {
//                 _sendJobCommand(SendJobType.REMARK);
//               },
//               color: Colors.white,
//               child: Icon(FontAwesomeIcons.triangleExclamation,
//                   color: Colors.orange)),
//           FxSpacing.height(10),
//           FxText.titleMedium("หมายเหตุ", color: Colors.white)
//         ],
//       ),
//       Column(
//         children: [
//           FxContainer.roundBordered(
//               onTap: () {
//                 _sendJobCommand(SendJobType.REJECT);
//               },
//               color: Colors.white,
//               child: Icon(FontAwesomeIcons.ban, color: Colors.red)),
//           FxSpacing.height(10),
//           FxText.titleMedium("ยกเลิกงาน", color: Colors.white)
//         ],
//       ),
//     ];
//     return list;
//   }

//   List<Widget> _buildFilterCategoryList(setState) {
//     List<Widget> list = [];
//     for (MapEntry<int, String> s in controller.status) {
//       list.add(_buildFilterCategory(s, setState));
//     }
//     return list;
//   }

//   Widget _buildFilterCategory(MapEntry<int, String> status, setState) {
//     return FxContainer(
//       borderColor: (controller.selectedJobStatus == status.key)
//           ? Colors.green
//           : Colors.grey.shade300,
//       paddingAll: 8,
//       borderRadiusAll: 8,
//       margin: FxSpacing.right(8),
//       bordered: true,
//       splashColor: customTheme.medicarePrimary.withAlpha(40),
//       color: customTheme.card,
//       onTap: () {
//         controller.onSelectedJobStatus(status.key);
//         setState(() {});
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // FxSpacing.width(8),
//           (status.key == JobStatus.SENDING)
//               ? Icon(FontAwesomeIcons.boxesPacking,
//                   color: Colors.yellow.shade600, size: 40)
//               : (status.key == JobStatus.SENT)
//                   ? Icon(
//                       Icons.send,
//                       color: Colors.green,
//                       size: 40,
//                     )
//                   : (status.key == JobStatus.REJECT_SENDING)
//                       ? Icon(
//                           Icons.cancel,
//                           color: Colors.red,
//                           size: 40,
//                         )
//                       : Container(),
//           FxSpacing.height(8),
//           FxText.bodyMedium(
//             status.value,
//             fontWeight: 600,
//           ),
//         ],
//       ),
//     );
//   }

//   void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     var test = args.value;
//   }

//   void _selectSizeSheet() {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext buildContext) {
//           return StatefulBuilder(
//             builder: (BuildContext context,
//                 void Function(void Function()) setState) {
//               return FxContainer(
//                 color: Colors.white,
//                 padding: FxSpacing.top(50),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: ListView(
//                         children: <Widget>[
//                           Padding(
//                             padding: FxSpacing.horizontal(24),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 FxCard.rounded(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   paddingAll: 6,
//                                   color: customTheme.border,
//                                   child: Icon(
//                                     Icons.close,
//                                     size: 16,
//                                     color: theme.colorScheme.onBackground,
//                                   ),
//                                 ),
//                                 FxText.bodyMedium(
//                                   'Filters',
//                                   fontWeight: 600,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     controller.onResetFilter();
//                                     setState(() {});
//                                   },
//                                   child: FxText.bodySmall(
//                                     'Reset',
//                                     color: customTheme.estatePrimary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           FxSpacing.height(15),
//                           Padding(
//                             padding: FxSpacing.horizontal(14),
//                             child: FxText.bodyLarge(
//                               'เลือกวันที่',
//                               fontWeight: 700,
//                             ),
//                           ),
//                           Padding(
//                             padding: FxSpacing.horizontal(14),
//                             child: SfDateRangePicker(
//                                 controller: _dateRangePickerController,
//                                 onSelectionChanged: _onDateSelectionChanged,
//                                 selectionMode:
//                                     DateRangePickerSelectionMode.range,
//                                 initialSelectedRange: PickerDateRange(
//                                   appController.fromDate,
//                                   appController.toDate,
//                                 )),
//                           ),
//                           FxSpacing.height(8),
//                           Padding(
//                             padding: FxSpacing.horizontal(14),
//                             child: FxText.bodyLarge(
//                               'สถานะงาน',
//                               fontWeight: 700,
//                             ),
//                           ),
//                           FxSpacing.height(8),
//                           StatefulBuilder(builder: (context, setState) {
//                             return GridView.count(
//                               padding: EdgeInsets.symmetric(horizontal: 16),
//                               primary: false,
//                               childAspectRatio: 1,
//                               shrinkWrap: true,
//                               crossAxisSpacing: 0,
//                               mainAxisSpacing: 0,
//                               crossAxisCount: 3,
//                               children: _buildFilterCategoryList(setState),
//                             );
//                           }),
//                           FxSpacing.height(16),
//                           Padding(
//                             padding: FxSpacing.horizontal(24),
//                             child: FxButton.block(
//                               borderRadiusAll: 8,
//                               onPressed: () {
//                                 appController.onSelectedDateRange(
//                                     _dateRangePickerController
//                                         .selectedRange!.startDate!,
//                                     _dateRangePickerController
//                                             .selectedRange!.endDate ??
//                                         _dateRangePickerController
//                                             .selectedRange!.startDate!);
//                                 controller.reloadAllJobs();
//                                 Navigator.pop(context);
//                               },
//                               backgroundColor: customTheme.estatePrimary,
//                               child: FxText.titleSmall(
//                                 "Apply Filters",
//                                 fontWeight: 700,
//                                 color: customTheme.estateOnPrimary,
//                                 letterSpacing: 0.4,
//                               ),
//                             ),
//                           ),
//                           FxSpacing.height(16),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         });
//   }

//   void _selectQuickAction() {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext buildContext) {
//           return StatefulBuilder(
//             builder: (BuildContext context,
//                 void Function(void Function()) setState) {
//               return BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                 child: FxContainer.transparent(
//                   height: 250,
//                   color: Colors.blue.withOpacity(0.8),
//                   padding: FxSpacing.top(50),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: ListView(
//                           children: <Widget>[
//                             FxSpacing.height(8),
//                             StatefulBuilder(builder: (context, setState) {
//                               return GridView.count(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 primary: false,
//                                 childAspectRatio: 1,
//                                 shrinkWrap: true,
//                                 crossAxisSpacing: 0,
//                                 mainAxisSpacing: 0,
//                                 crossAxisCount: 3,
//                                 children: _buildQuickActionMenuList(setState),
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//                       Divider(
//                         height: 1,
//                         color: theme.dividerColor,
//                         thickness: 1,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(FontAwesomeIcons.barcode,
//                                   color: Colors.white),
//                               FxContainer.transparent(
//                                 onTap: () async {
//                                   var value =
//                                       await FlutterBarcodeScanner.scanBarcode(
//                                           "#ff6666",
//                                           "Cancel",
//                                           true,
//                                           ScanMode.BARCODE);
//                                   if (value != "-1") {
//                                     var response = await controller
//                                         .appController.api
//                                         .updateJobStatusByBarCode(value);
//                                     if (response != null) {
//                                       if (response["isSuccess"]) {
//                                         Navigator.of(context).pop();
//                                         controller.reloadAllJobs(
//                                             forceReload: true);
//                                       } else {
//                                         if (response["errorCode"] ==
//                                             "JOB-0003") {
//                                           showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return _globalWidget
//                                                     .errorYesNoDialog(context,
//                                                         response["message"],
//                                                         title2:
//                                                             "ท่านต้องการเปลี่ยนสถานะรับงานแทนหรือไม่?",
//                                                         acceptPressed:
//                                                             () async {
//                                                   var response = await controller
//                                                       .appController.api
//                                                       .updateJobStatusByBarCode(
//                                                           value);
//                                                   if (response != null) {
//                                                     if (response["isSuccess"]) {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                       controller.reloadAllJobs(
//                                                           forceReload: true);
//                                                     } else {
//                                                       showDialog(
//                                                           context: context,
//                                                           builder: (context) {
//                                                             return _globalWidget
//                                                                 .errorDialog(
//                                                                     context,
//                                                                     response[
//                                                                         "message"]);
//                                                           });
//                                                     }
//                                                   }
//                                                 });
//                                               });
//                                         } else {
//                                           showDialog(
//                                               context: context,
//                                               builder: (context) {
//                                                 return _globalWidget
//                                                     .errorDialog(context,
//                                                         response["message"]);
//                                               });
//                                         }
//                                       }
//                                     }
//                                   } else {
//                                     showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           return _globalWidget.errorDialog(
//                                               context, "สแกนบาร์โค้ดไม่สำเร็จ ",
//                                               title2: '$value');
//                                         });
//                                   }
//                                 },
//                                 child: Row(children: [
//                                   FxText.titleLarge("สแกนรับงาน",
//                                       color: Colors.white)
//                                 ]),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }

//   void resetAppBar() {
//     _appBarAnimationController.animateTo(0,
//         duration: Duration(microseconds: 600), curve: Curves.ease);
//     _scrollController.animateTo(0,
//         duration: Duration(milliseconds: 300), curve: Curves.ease);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FxBuilder<HomeController>(
//       controller: controller,
//       builder: (controller) {
//         return SafeArea(
//           child: WillPopScope(
//             onWillPop: () async {
//               if (controller.isSearchMode) {
//                 _searchTextController.clear();
//                 FocusScope.of(context).unfocus();
//                 resetAppBar();
//                 controller.reloadAllJobs();
//               }
//               return false;
//             },
//             child: Scaffold(
//               floatingActionButton: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Visibility(
//                     visible:
//                         controller.selectionJobType == SelectionJobTypes.camera,
//                     child: FloatingActionButton(
//                       heroTag: "btn1",
//                       backgroundColor: Colors.blue,
//                       child: Icon(
//                         (controller.isShowList)
//                             ? FontAwesomeIcons.camera
//                             : FontAwesomeIcons.list,
//                       ),
//                       onPressed: () {
//                         controller.isShowList = !controller.isShowList;
//                         if (!controller.isShowList) {
//                           _mobileScannerController = MobileScannerController(
//                               detectionSpeed: DetectionSpeed.noDuplicates);
//                           _mobileScannerController.start();
//                         }
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                   FxSpacing.width(20),
//                   FloatingActionButton(
//                     heroTag: "btn2",
//                     backgroundColor: Colors.blue,
//                     child: Icon(
//                       FontAwesomeIcons.boltLightning,
//                     ),
//                     onPressed: () {
//                       _selectQuickAction();
//                       //resetAppBar();
//                     },
//                   ),
//                 ],
//               ),
//               body: Column(
//                 children: [
//                   Container(
//                     height: 2,
//                     child: controller.showLoading
//                         ? LinearProgressIndicator(
//                             color: customTheme.estatePrimary,
//                             minHeight: 2,
//                           )
//                         : Container(
//                             height: 2,
//                             color: SLColor.LIGHTBLUE2,
//                           ),
//                   ),
//                   Expanded(
//                     child: _buildBody(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;

//   Widget showPopup(HomeController controller) {
//     // must use StateSetter to update data between main screen and popup.
//     // if use default setState, the data will not update
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//       return Container(
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 32),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Text('รายการสายส่ง',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ),
//             Flexible(
//               child: ListView(
//                 padding: EdgeInsets.all(16),
//                 children:
//                     List.generate(appController.routelines.length, (index) {
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         behavior: HitTestBehavior.translucent,
//                         onTap: () {
//                           Navigator.pop(context);
//                           // controller.onSelectedRouteLine(
//                           //     appController.routelines[index]);
//                           setState(() {});
//                         },
//                         child: appController.routelines[index] ==
//                                 appController.selectedRouteLine
//                             ? Row(
//                                 children: [
//                                   Text(
//                                       appController.routelines[index].routename,
//                                       style: TextStyle(
//                                           color: Colors.black87, fontSize: 16)),
//                                   Spacer(),
//                                   Icon(FontAwesomeIcons.check,
//                                       color: Colors.green)
//                                   // FxText.labelMedium("เลือก",style: TextStyle(color: Colors.red),),
//                                 ],
//                               )
//                             : Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                     appController.routelines[index].routename,
//                                     style: TextStyle(
//                                         color: Colors.black, fontSize: 16)),
//                               ),
//                       ),
//                       Divider(
//                         height: 32,
//                         color: Colors.grey[400],
//                       ),
//                       appController.routelines.length == index + 1
//                           ? Container()
//                           // SizedBox(
//                           //     width: double.maxFinite,
//                           //     child: OutlinedButton(
//                           //     onPressed: () {
//                           //       Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressPage()));
//                           //     },
//                           //     style: ButtonStyle(
//                           //         overlayColor: MaterialStateProperty.all(Colors.transparent),
//                           //         shape: MaterialStateProperty.all(
//                           //             RoundedRectangleBorder(
//                           //               borderRadius: BorderRadius.circular(5.0),
//                           //             )
//                           //         ),
//                           //         side: MaterialStateProperty.all(
//                           //           BorderSide(
//                           //               color: PRIMARY_COLOR,
//                           //               width: 1.0
//                           //           ),
//                           //         )
//                           //     ),
//                           //     child: Text(
//                           //       'Add New Address',
//                           //       style: TextStyle(
//                           //           color: PRIMARY_COLOR,
//                           //           fontWeight: FontWeight.bold,
//                           //           fontSize: 13
//                           //       ),
//                           //       textAlign: TextAlign.center,
//                           //     )
//                           //   ),
//                           // )
//                           : SizedBox.shrink(),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
