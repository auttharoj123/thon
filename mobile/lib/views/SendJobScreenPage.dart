import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/SendJobController.dart';
import 'package:slpod/components/full_image_screen.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SendJobScreenPage extends StatefulWidget {
  SendJobScreenPage({Key? key}) : super(key: key);

  @override
  State<SendJobScreenPage> createState() => _SendJobScreenPageState();
}

class _SendJobScreenPageState extends State<SendJobScreenPage> {
  late SendJobController controller;
  final ImagePicker _picker = ImagePicker();
  late List<String> selectedImages = [];
  late ScrollController _scrollController;
  late PageController _pageController;
  var color = Colors.black;
  var strokeWidth = 3.0;
  final _sign = GlobalKey<SignatureState>();
  late int currentPageState = 0;
  late int point = 0;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(SendJobController());
    _scrollController = ScrollController();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FxContainer.transparent(
            paddingAll: 0,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        backgroundColor: SLColor.BLUE,
        elevation: 0,
        title: FxText.titleLarge(
          "ส่งงาน",
          color: Colors.white,
        ),
      ),
      body: FxBuilder(
          controller: controller,
          builder: (context) {
            return Container(
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Container(
                  //   padding: FxSpacing.top(20),
                  //   height: 80,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       TimelineTile(
                  //         isFirst: true,
                  //         axis: TimelineAxis.horizontal,
                  //         alignment: TimelineAlign.center,
                  //         indicatorStyle: IndicatorStyle(
                  //           indicatorXY: 0.5,
                  //           height: 16,
                  //           // color: currentPosition ? _color1 : Colors.grey[400]!
                  //         ),
                  //         endChild: FxText("ระบุหมายเหตุ"),
                  //       ),
                  //       TimelineTile(
                  //         axis: TimelineAxis.horizontal,
                  //         alignment: TimelineAlign.center,
                  //         indicatorStyle: IndicatorStyle(
                  //           indicatorXY: 0.5,
                  //           height: 16,
                  //           // color: currentPosition ? _color1 : Colors.grey[400]!
                  //         ),
                  //         endChild: FxText("รูปภาพ"),
                  //       ),
                  //       TimelineTile(
                  //         axis: TimelineAxis.horizontal,
                  //         alignment: TimelineAlign.center,
                  //         indicatorStyle: IndicatorStyle(
                  //           indicatorXY: 0.5,
                  //           height: 16,
                  //           // color: currentPosition ? _color1 : Colors.grey[400]!
                  //         ),
                  //         endChild: FxText("ลายเซ็น"),
                  //       ),
                  //       TimelineTile(
                  //         isLast: true,
                  //         axis: TimelineAxis.horizontal,
                  //         alignment: TimelineAlign.center,
                  //         indicatorStyle: IndicatorStyle(
                  //           indicatorXY: 0.5,
                  //           height: 16,
                  //           // color: currentPosition ? _color1 : Colors.grey[400]!
                  //         ),
                  //         endChild: FxText("ให้คะแนน"),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Container(
                              child: FxContainer.transparent(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: FxContainer.bordered(
                                  paddingAll: 2,
                                  color: Colors.white,
                                  child: DropdownButtonFormField<String>(
                                    menuMaxHeight: 300,
                                    dropdownColor: Colors.white,
                                    iconEnabledColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide.none),
                                    ),
                                    hint: FxText(
                                      "หมายเหตุการส่งงาน",
                                      color: Colors.black,
                                    ),
                                    // value: _valYear,
                                    items: controller.appController.mstTypes
                                        .map((e) {
                                      return DropdownMenuItem<String>(
                                        child: FxText(e.typeDetail,
                                            color: Colors.black),
                                        value: e.mstTypeId.toString(),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        // _valYear = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: FxContainer(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FxContainer.roundBordered(
                                                paddingAll: 10,
                                                bordered: false,
                                                color: SLColor.LIGHTBLUE2,
                                                child: Icon(
                                                  FontAwesomeIcons.fileImage,
                                                  size: 20,
                                                  color: Colors.white,
                                                )),
                                            FxSpacing.width(10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FxText.titleMedium("รูปภาพ"),
                                                FxText.titleMedium(
                                                    "จำนวน ${selectedImages.length}/10 รูป",
                                                    xMuted: true),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                FxContainer.roundBordered(
                                                  onTap: () async {
                                                    final List<XFile>? images =
                                                        await _picker
                                                            .pickMultiImage();
                                                    final paths = images!
                                                        .map((e) => e.path)
                                                        .toList();

                                                    var totalImage = paths
                                                            .length +
                                                        selectedImages.length;
                                                    if (totalImage > 10) {
                                                      selectedImages.addAll(
                                                          paths.sublist(
                                                              0,
                                                              10 -
                                                                  selectedImages
                                                                      .length));
                                                    } else {
                                                      selectedImages
                                                          .addAll(paths);
                                                    }

                                                    controller.update();
                                                    _scrollController.animateTo(
                                                        200.0 *
                                                            selectedImages
                                                                .length,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease);
                                                  },
                                                  child: Icon(
                                                      FontAwesomeIcons.image),
                                                ),
                                                FxSpacing.width(10),
                                                FxContainer.roundBordered(
                                                  onTap: () async {
                                                    try {
                                                      final pickedFile =
                                                          await _picker.pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera,
                                                              imageQuality: 25);

                                                      if (selectedImages
                                                              .length ==
                                                          10) {
                                                        return;
                                                      }
                                                      selectedImages.add(
                                                          pickedFile!.path);
                                                      controller.update();
                                                      _scrollController
                                                          .animateTo(
                                                              200.0 *
                                                                  selectedImages
                                                                      .length,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      300),
                                                              curve:
                                                                  Curves.ease);
                                                    } catch (e) {
                                                      setState(() {
                                                        //_pickImageError = e;
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                      FontAwesomeIcons.camera),
                                                ),
                                              ]),
                                        )
                                      ],
                                    ),
                                    FxSpacing.height(10),
                                    Divider(height: 2),
                                    FxSpacing.height(10),
                                    Expanded(
                                      child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          controller: _scrollController,
                                          itemCount: selectedImages.length,
                                          itemBuilder: (context, index) {
                                            return FxContainer.transparent(
                                              paddingAll: 0,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                        opaque: false,
                                                        pageBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    _,
                                                                    __) =>
                                                                FullImageScreen(
                                                                  imagePath:
                                                                      selectedImages[
                                                                          index],
                                                                  imageTag:
                                                                      'imageTag-' +
                                                                          index
                                                                              .toString(),
                                                                  backgroundOpacity:
                                                                      200,
                                                                )));
                                              },
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Hero(
                                                      tag: 'imageTag-' +
                                                          index.toString(),
                                                      child: Container(
                                                        child: Image.file(
                                                            File(selectedImages[
                                                                index]),
                                                            height: 200,
                                                            fit: BoxFit
                                                                .fitHeight),
                                                      )),
                                                  Container(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    height: 40,
                                                    margin: FxSpacing.only(
                                                        top: 0, left: 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        FxContainer.transparent(
                                                          width: 30,
                                                          height: 30,
                                                          paddingAll: 0,
                                                          child: Center(
                                                            child: FxText(
                                                                '# ${(index + 1).toString()}',
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        FxContainer
                                                            .roundBordered(
                                                          margin:
                                                              FxSpacing.right(
                                                                  5),
                                                          onTap: () {
                                                            selectedImages
                                                                .removeAt(
                                                                    index);
                                                            controller.update();
                                                          },
                                                          color: Colors.red,
                                                          width: 24,
                                                          height: 24,
                                                          paddingAll: 0,
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .xmark,
                                                            color: Colors.white,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        FxContainer(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FxContainer.roundBordered(
                                              paddingAll: 10,
                                              bordered: false,
                                              color: SLColor.LIGHTBLUE2,
                                              child: Icon(
                                                FontAwesomeIcons.signature,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                          FxSpacing.width(10),
                                          FxText.titleMedium("ลายเซ็น"),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              FxContainer.roundBordered(
                                                color: Colors.red,
                                                onTap: () async {
                                                  final sign =
                                                      _sign.currentState;
                                                  sign!.clear();
                                                },
                                                child: Icon(
                                                    FontAwesomeIcons.xmark,
                                                    color: Colors.white),
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                  FxSpacing.height(10),
                                  Divider(height: 2),
                                  FxSpacing.height(10),
                                  Container(
                                    height: 400,
                                    child: Signature(
                                      color: color,
                                      key: _sign,
                                      onSign: () {
                                        final sign = _sign.currentState;
                                        debugPrint(
                                            '${sign!.points.length} points in the signature');
                                      },
                                      strokeWidth: strokeWidth,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        FxContainer(
                            margin: FxSpacing.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FxText.bodyLarge("คะแนนความพึงพอใจ",
                                        fontSize: 21, fontWeight: 700),
                                  ],
                                ),
                                FxSpacing.height(20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        FxContainer.transparent(
                                          paddingAll: 0,
                                          onTap: () {
                                            point = 5;
                                            controller.update();
                                          },
                                          child: Icon(
                                              Icons.emoji_emotions_outlined,
                                              color: (point == 5)
                                                  ? Colors.green.shade700
                                                  : Colors.green.shade100,
                                              size: 50),
                                        ),
                                        FxText("ดีมาก")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        FxContainer.transparent(
                                          paddingAll: 0,
                                          onTap: () {
                                            point = 4;
                                            controller.update();
                                          },
                                          child: Icon(
                                              Icons.sentiment_satisfied_alt,
                                              color: (point == 4)
                                                  ? Colors.blue
                                                  : Colors.blue.shade100,
                                              size: 50),
                                        ),
                                        FxText("ดี")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        FxContainer.transparent(
                                          paddingAll: 0,
                                          onTap: () {
                                            point = 3;
                                            controller.update();
                                          },
                                          child: Icon(Icons.sentiment_neutral,
                                              color: (point == 3)
                                                  ? Colors.orange
                                                  : Colors.orange.shade100,
                                              size: 50),
                                        ),
                                        FxText("ปานกลาง")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        FxContainer.transparent(
                                          onTap: () {
                                            point = 2;
                                            controller.update();
                                          },
                                          paddingAll: 0,
                                          child: Icon(
                                              Icons
                                                  .sentiment_dissatisfied_outlined,
                                              color: (point == 2)
                                                  ? Colors.purple
                                                  : Colors.purple.shade100,
                                              size: 50),
                                        ),
                                        FxText("แย่")
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        FxContainer.transparent(
                                          onTap: () {
                                            point = 1;
                                            controller.update();
                                          },
                                          paddingAll: 0,
                                          child: Icon(
                                              Icons
                                                  .sentiment_very_dissatisfied_outlined,
                                              color: (point == 1)
                                                  ? Colors.red
                                                  : Colors.red.shade100,
                                              size: 50),
                                        ),
                                        FxText("แย่มาก")
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  // PageView(
                  //   children: [
                  //     // FxContainer.transparent(
                  //     //   margin: EdgeInsets.symmetric(vertical: 8),
                  //     //   child: FxContainer.bordered(
                  //     //     paddingAll: 2,
                  //     //     color: Colors.white,
                  //     //     child: DropdownButtonFormField<String>(
                  //     //       menuMaxHeight: 300,
                  //     //       dropdownColor: Colors.white,
                  //     //       iconEnabledColor: Colors.black,
                  //     //       decoration: InputDecoration(
                  //     //         border: OutlineInputBorder(
                  //     //             borderRadius: BorderRadius.circular(16),
                  //     //             borderSide: BorderSide.none),
                  //     //       ),
                  //     //       hint: FxText(
                  //     //         "หมายเหตุการส่งงาน",
                  //     //         color: Colors.black,
                  //     //       ),
                  //     //       // value: _valYear,
                  //     //       items:
                  //     //           controller.appController.mstTypes.map((e) {
                  //     //         return DropdownMenuItem<String>(
                  //     //           child: FxText(e.typeDetail,
                  //     //               color: Colors.white),
                  //     //           value: e.mstTypeId.toString(),
                  //     //         );
                  //     //       }).toList(),
                  //     //       onChanged: (String? value) {
                  //     //         setState(() {
                  //     //           // _valYear = value!;
                  //     //         });
                  //     //       },
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     FxContainer(
                  //       color: Colors.white,
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   FxContainer.roundBordered(
                  //                       paddingAll: 10,
                  //                       bordered: false,
                  //                       color: SLColor.LIGHTBLUE2,
                  //                       child: Icon(
                  //                         FontAwesomeIcons.fileImage,
                  //                         size: 20,
                  //                         color: Colors.white,
                  //                       )),
                  //                   FxSpacing.width(10),
                  //                   Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       FxText.titleMedium("รูปภาพ"),
                  //                       FxText.titleMedium(
                  //                           "จำนวน ${selectedImages.length}/10 รูป",
                  //                           xMuted: true),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 child: Row(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       FxContainer.roundBordered(
                  //                         onTap: () async {
                  //                           final List<XFile>? images =
                  //                               await _picker.pickMultiImage();
                  //                           final paths = images!
                  //                               .map((e) => e.path)
                  //                               .toList();

                  //                           var totalImage = paths.length +
                  //                               selectedImages.length;
                  //                           if (totalImage > 10) {
                  //                             selectedImages.addAll(
                  //                                 paths.sublist(
                  //                                     0,
                  //                                     10 -
                  //                                         selectedImages
                  //                                             .length));
                  //                           } else {
                  //                             selectedImages.addAll(paths);
                  //                           }

                  //                           controller.update();
                  //                           _scrollController.animateTo(
                  //                               200.0 * selectedImages.length,
                  //                               duration:
                  //                                   Duration(milliseconds: 300),
                  //                               curve: Curves.ease);
                  //                         },
                  //                         child: Icon(FontAwesomeIcons.image),
                  //                       ),
                  //                       FxSpacing.width(10),
                  //                       FxContainer.roundBordered(
                  //                         onTap: () async {
                  //                           try {
                  //                             final pickedFile =
                  //                                 await _picker.pickImage(
                  //                                     source:
                  //                                         ImageSource.camera,
                  //                                     imageQuality: 25);

                  //                             if (selectedImages.length == 10) {
                  //                               return;
                  //                             }
                  //                             selectedImages
                  //                                 .add(pickedFile!.path);
                  //                             controller.update();
                  //                             _scrollController.animateTo(
                  //                                 200.0 * selectedImages.length,
                  //                                 duration: Duration(
                  //                                     milliseconds: 300),
                  //                                 curve: Curves.ease);
                  //                           } catch (e) {
                  //                             setState(() {
                  //                               //_pickImageError = e;
                  //                             });
                  //                           }
                  //                         },
                  //                         child: Icon(FontAwesomeIcons.camera),
                  //                       ),
                  //                       FxSpacing.width(10),
                  //                       FxContainer.roundBordered(
                  //                         onTap: () async {},
                  //                         child: Icon(Icons.grid_view),
                  //                       )
                  //                     ]),
                  //               )
                  //             ],
                  //           ),
                  //           FxSpacing.height(10),
                  //           Divider(height: 2),
                  //           FxSpacing.height(10),
                  //           Container(
                  //             width: double.infinity,
                  //             height: 150,
                  //             child: ListView.builder(
                  //                 controller: _scrollController,
                  //                 // physics: PageScrollPhysics(),
                  //                 scrollDirection: Axis.horizontal,
                  //                 itemCount: selectedImages.length,
                  //                 itemBuilder: (context, index) {
                  //                   return FxContainer.transparent(
                  //                     paddingAll: 0,
                  //                     onTap: () {
                  //                       Navigator.of(context).push(
                  //                           PageRouteBuilder(
                  //                               opaque: false,
                  //                               pageBuilder: (BuildContext
                  //                                           context,
                  //                                       _,
                  //                                       __) =>
                  //                                   FullImageScreen(
                  //                                     imagePath:
                  //                                         selectedImages[index],
                  //                                     imageTag: 'imageTag-' +
                  //                                         index.toString(),
                  //                                     backgroundOpacity: 200,
                  //                                   )));
                  //                     },
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Stack(
                  //                       children: [
                  //                         Hero(
                  //                             tag: 'imageTag-' +
                  //                                 index.toString(),
                  //                             child: Container(
                  //                               width: 200,
                  //                               child: Image.file(
                  //                                   File(selectedImages[index]),
                  //                                   fit: BoxFit.fitWidth),
                  //                             )),
                  //                         FxContainer.roundBordered(
                  //                           color: SLColor.LIGHTBLUE2,
                  //                           width: 30,
                  //                           height: 30,
                  //                           margin:
                  //                               FxSpacing.only(top: 5, left: 5),
                  //                           paddingAll: 0,
                  //                           child: Center(
                  //                             child: FxText(
                  //                                 (index + 1).toString(),
                  //                                 color: Colors.white),
                  //                           ),
                  //                         ),
                  //                         FxContainer.roundBordered(
                  //                           onTap: () {
                  //                             selectedImages.removeAt(index);
                  //                             controller.update();
                  //                           },
                  //                           color: Colors.red,
                  //                           width: 30,
                  //                           height: 30,
                  //                           margin: FxSpacing.only(
                  //                               top: 5, left: 165),
                  //                           paddingAll: 0,
                  //                           child: Icon(
                  //                             FontAwesomeIcons.xmark,
                  //                             color: Colors.white,
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   );
                  //                 }),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     FxSpacing.height(10),
                  //     FxContainer(
                  //       color: Colors.white,
                  //       child: Column(
                  //         children: [
                  //           Column(
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       FxContainer.roundBordered(
                  //                           paddingAll: 10,
                  //                           bordered: false,
                  //                           color: SLColor.LIGHTBLUE2,
                  //                           child: Icon(
                  //                             FontAwesomeIcons.signature,
                  //                             size: 20,
                  //                             color: Colors.white,
                  //                           )),
                  //                       FxSpacing.width(10),
                  //                       FxText.titleMedium("ลายเซ็น"),
                  //                     ],
                  //                   ),
                  //                   Expanded(
                  //                     child: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.end,
                  //                         children: [
                  //                           FxContainer.roundBordered(
                  //                             onTap: () async {},
                  //                             child:
                  //                                 Icon(FontAwesomeIcons.plus),
                  //                           ),
                  //                           FxSpacing.width(10),
                  //                           FxContainer.roundBordered(
                  //                             onTap: () async {},
                  //                             child:
                  //                                 Icon(FontAwesomeIcons.xmark),
                  //                           ),
                  //                         ]),
                  //                   )
                  //                 ],
                  //               ),
                  //               FxSpacing.height(10),
                  //               Divider(height: 2),
                  //               FxSpacing.height(10),
                  //               Container(
                  //                 height: 400,
                  //                 child: Signature(
                  //                   color: color,
                  //                   key: _sign,
                  //                   onSign: () {
                  //                     final sign = _sign.currentState;
                  //                     debugPrint(
                  //                         '${sign!.points.length} points in the signature');
                  //                   },
                  //                   strokeWidth: strokeWidth,
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: FxContainer.transparent(
                            color: (currentPageState == 0)
                                ? Colors.grey
                                : Colors.red,
                            borderRadiusAll: 0,
                            onTap: () {
                              if (currentPageState == 0) return;
                              currentPageState--;
                              _pageController.animateToPage(currentPageState,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                              controller.update();
                            },
                            child: Center(
                              child: FxText("ย้อนกลับ",
                                  color: Colors.white, fontWeight: 600),
                            )),
                      ),
                      Expanded(
                        child: FxContainer.transparent(
                            color: SLColor.BLUE,
                            borderRadiusAll: 0,
                            onTap: () {
                              currentPageState++;
                              _pageController.animateToPage(currentPageState,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                              controller.update();
                            },
                            child: Center(
                              child: FxText(
                                  (currentPageState == 3)
                                      ? "ยืนยันการส่งงาน"
                                      : "ถัดไป",
                                  color: Colors.white,
                                  fontWeight: 600),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
