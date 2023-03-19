// import 'package:flutter/material.dart';
// import 'package:flutx/flutx.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:slpod/controllers/NonUpdateJobLogHistoryController.dart';
// import 'package:slpod/views/Reuseable/GlobalWidget.dart';

// class NonUpdateJobLogHistoryDetailScreen extends StatefulWidget {
//   const NonUpdateJobLogHistoryDetailScreen({super.key});

//   @override
//   State<NonUpdateJobLogHistoryDetailScreen> createState() =>
//       _NonUpdateJobLogHistoryDetailScreen();
// }

// class _NonUpdateJobLogHistoryDetailScreen
//     extends State<NonUpdateJobLogHistoryDetailScreen> {
//   GlobalWidget _globalWidget = GlobalWidget();
//   late NonUpdateJobLogHistoryController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller =
//         FxControllerStore.putOrFind(NonUpdateJobLogHistoryController());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   backgroundColor: Colors.blue,
//         //   title: FxText.titleMedium("ประวัติการส่งงาน"),
//         // ),
//         body: FxBuilder<NonUpdateJobLogHistoryController>(
//             controller: controller,
//             builder: (context) {
//               return Stack(children: [
//                 Transform.scale(
//                   scale: 1.5,
//                   child: Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(200),
//                             bottomRight: Radius.circular(200)),
//                         gradient: LinearGradient(colors: [
//                           Colors.blue.shade600,
//                           Colors.blue.shade200
//                         ])),
//                   ),
//                 ),
//                 SafeArea(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: FxSpacing.xy(10, 10),
//                             child: _globalWidget.menuButton(),
//                           ),
//                           FxText.titleLarge("ประวัติการส่งงาน",
//                               color: Colors.white)
//                         ],
//                       ),
//                       Expanded(
//                         child: FxContainer.bordered(
//                           color: Colors.grey.shade100,
//                           margin: FxSpacing.only(
//                               top: 10, left: 20, right: 20, bottom: 10),
//                           child: Column(
//                             children: [
//                               FxContainer(
//                                 color: Colors.blue,
//                                 paddingAll: 5,
//                                 child: Row(children: [
//                                   FxContainer(
//                                       onTap: () {
//                                         controller.selectedGroup = 0;
//                                         controller.loadData();
//                                       },
//                                       color: (controller.selectedGroup == 0)
//                                           ? Colors.green
//                                           : Colors.transparent,
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.check,color: Colors.white),
//                                           FxSpacing.width(10),
//                                           FxText.titleSmall(
//                                             "สำเร็จ",
//                                             color: Colors.white,
//                                           ),
//                                         ],
//                                       )),
//                                   FxContainer(
//                                       onTap: () {
//                                         controller.selectedGroup = 1;
//                                         controller.loadData();
//                                       },
//                                       color: (controller.selectedGroup == 1)
//                                           ? Colors.red.shade300
//                                           : Colors.transparent,
//                                       child: Row(
//                                         children: [
//                                           Icon(FontAwesomeIcons.xmark, color:Colors.white),
//                                           FxSpacing.width(10),
//                                           FxText.titleSmall(
//                                             "ไม่สำเร็จ",
//                                             color: Colors.white,
//                                           ),
//                                         ],
//                                       )),
//                                   Expanded(child: Container()),
//                                   Icon(
//                                     Icons.upload,
//                                     color: Colors.blue,
//                                     size: 30,
//                                   ),
//                                   FxSpacing.width(10),
//                                   Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                     size: 30,
//                                   )
//                                 ]),
//                               ),
//                               FxSpacing.height(20),
//                               Expanded(
//                                 child: ListView.builder(
//                                     physics: BouncingScrollPhysics(),
//                                     itemCount: controller.jobs.length,
//                                     itemBuilder: (context, index) {
//                                       var job = controller.jobs[index];
//                                       return Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Icon(
//                                                           FontAwesomeIcons
//                                                               .barcode,
//                                                           color: Colors.blue),
//                                                       FxSpacing.width(10),
//                                                       Column(
//                                                         children: job.barcodes
//                                                             .split(',')
//                                                             .map((e) {
//                                                           return FxText(e);
//                                                         }).toList(),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 FxSpacing.width(10),
//                                                 Row(
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Icon(Icons.image,
//                                                             color: Colors.blue),
//                                                         FxSpacing.width(10),
//                                                         FxText.titleMedium(job
//                                                             .imagesPath.length
//                                                             .toString())
//                                                       ],
//                                                     ),
//                                                     FxSpacing.width(20),
//                                                     (controller.selectedGroup ==
//                                                             0)
//                                                         ? FxContainer(
//                                                             paddingAll: 5,
//                                                             color: Colors
//                                                                 .green.shade300,
//                                                             child: FxText
//                                                                 .titleSmall(
//                                                               "สำเร็จ",
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                           )
//                                                         : FxContainer(
//                                                             paddingAll: 5,
//                                                             color: Colors
//                                                                 .red.shade300,
//                                                             child: FxText
//                                                                 .titleSmall(
//                                                               "ไม่สำเร็จ",
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                           ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                             FxSpacing.height(10),
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.calendar_today, color: Colors.blue),
//                                                 FxSpacing.width(10),
//                                                 FxText.titleSmall(DateFormat(
//                                                         'yyyy/MM/dd kk:mm')
//                                                     .format(
//                                                         job.updatedDate.toLocal())),
//                                               ],
//                                             ),
//                                             FxSpacing.height(20),
//                                             Divider(
//                                               height: 2,
//                                               color: Colors.grey.shade400,
//                                             )
//                                           ],
//                                         ),
//                                       );
//                                     }),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]);
//             }));
//   }
// }
