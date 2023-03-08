import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:signature/signature.dart';
import 'package:slpod/components/ToggleButton.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/SendJobController.dart';
import 'package:slpod/components/full_image_screen.dart';

class SendJobScreenPage extends StatefulWidget {
  SendJobScreenPage({Key? key}) : super(key: key);

  @override
  State<SendJobScreenPage> createState() => _SendJobScreenPageState();
}

class _SendJobScreenPageState extends State<SendJobScreenPage> {
  late SendJobController controller;

  @override
  void initState() {
    super.initState();
    controller = FxControllerStore.putOrFind(SendJobController());
  }

  Widget _page1() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return SingleChildScrollView(
      child: Column(
        children: [
          // (args["jobType"] == SendJobType.REMARK)
          //     ?
          //     Container(
          //         child: FxContainer.transparent(
          //           margin: EdgeInsets.symmetric(vertical: 8),
          //           child: FxContainer.bordered(
          //             paddingAll: 2,
          //             color: Colors.white,
          //             child: DropdownButtonFormField<String>(
          //               menuMaxHeight: 300,
          //               dropdownColor: Colors.white,
          //               iconEnabledColor: Colors.black,
          //               decoration: InputDecoration(
          //                 border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(16),
          //                     borderSide: BorderSide.none),
          //               ),
          //               hint: FxText(
          //                 "หมายเหตุการส่งงาน",
          //                 color: Colors.black,
          //               ),
          //               // value: _valYear,
          //               items: controller.appController.mstTypes.map((e) {
          //                 return DropdownMenuItem<String>(
          //                   child: FxText(e.typeDetail, color: Colors.black),
          //                   value: e.mstTypeId.toString(),
          //                 );
          //               }).toList(),
          //               onChanged: (String? value) {
          //                 setState(() {
          //                   controller.remarkCatIdDump = value!;
          //                 });
          //               },
          //             ),
          //           ),
          //         ),
          //       )
          //     :
          FxContainer(
            color: Colors.white,
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FxContainer.roundBordered(
                                  paddingAll: 5,
                                  color: Colors.red,
                                  onTap: () async {
                                    controller.signatureController.clear();
                                    setState(() {});
                                  },
                                  child: Icon(FontAwesomeIcons.xmark,
                                      color: Colors.white),
                                ),
                              ]),
                        )
                      ],
                    ),
                    controller.globalWidget.satisfactionView(controller),
                    FxSpacing.height(10),
                    Divider(height: 2),
                    FxSpacing.height(10),
                    Container(
                        height: 400,
                        child: Signature(
                          controller: controller.signatureController,
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _page2() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var specialRemarks = (args["jobType"] == SendJobType.REMARK)
        ? controller.specialRemarks.sublist(0, 8)
        : controller.specialRemarks
            .sublist(8, controller.specialRemarks.length);

    return Container(
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverGrid(
              key: const PageStorageKey(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 52, crossAxisCount: 2),
              delegate: SliverChildBuilderDelegate(
                childCount: specialRemarks.length,
                (context, index) {
                  return Column(
                    children: [
                      ToggleButton(
                          value: specialRemarks[index],
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      Divider(height: 2)
                    ],
                  );
                },
              )),
          SliverList(
              key: const PageStorageKey(2),
              delegate: SliverChildListDelegate([
                Container(
                  padding: FxSpacing.symmetric(vertical: 5,horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Lottie.asset(
                              'assets/animations/lottie/image-preload.json',
                              height: 60),
                          FxSpacing.width(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.titleMedium("รูปภาพ"),
                              FxText.titleMedium(
                                  "จำนวน ${controller.selectedImages.length}/10 รูป",
                                  xMuted: true),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FxContainer.roundBordered(
                                  paddingAll: 0,
                                  onTap: () async {
                                    await controller.pickMultiImage();
                                  },
                                  child: Lottie.asset(
                                      'assets/animations/lottie/image.json',
                                      height: 60)),
                              FxSpacing.width(10),
                              FxContainer.roundBordered(
                                  paddingAll: 0,
                                  onTap: () async {
                                    await controller.pickCameraImage();
                                  },
                                  // child: Icon(FontAwesomeIcons.camera),
                                  child: Lottie.asset(
                                      'assets/animations/lottie/camera.json',
                                      height: 60)),
                            ]),
                      )
                    ],
                  ),
                ),
                // FxSpacing.height(10),
                Divider(height: 2),
                // FxSpacing.height(10),
              ])),
          SliverGrid(
            key: const PageStorageKey(3),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildListDelegate(
                controller.selectedImages.asMap().entries.map<Widget>((entry) {
              return FxContainer.transparent(
                color: Colors.grey.shade400,
                borderRadiusAll: 0,
                marginAll: 5,
                paddingAll: 0,
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          FullImageScreen(
                            imagePath: controller.selectedImages[entry.key],
                            imageTag: 'imageTag-' + entry.key.toString(),
                            backgroundOpacity: 200,
                          )));
                },
                // padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Hero(
                        tag: 'imageTag-' + entry.key.toString(),
                        child: Center(
                          child: Container(
                            child: Image.file(
                                File(controller.selectedImages[entry.key]),
                                height: 200,
                                fit: BoxFit.fitHeight),
                          ),
                        )),
                    Container(
                      color: Colors.black.withAlpha(80),
                      height: 40,
                      margin: FxSpacing.only(top: 0, left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FxContainer.transparent(
                            // width: 30,
                            height: 30,
                            paddingAll: 0,
                            child: Center(
                              child: FxText('# ${(entry.key + 1).toString()}',
                                  color: Colors.white),
                            ),
                          ),
                          FxContainer.roundBordered(
                            margin: FxSpacing.right(5),
                            onTap: () {
                              controller.selectedImages.removeAt(entry.key);
                              setState(() {
                                
                              });
                            },
                            color: Colors.red,
                            width: 24,
                            height: 24,
                            paddingAll: 0,
                            child: Icon(
                              FontAwesomeIcons.xmark,
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
            }).toList()),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (args["jobType"] == SendJobType.REMARK) {
      controller.currentPageState = 1;
    }
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
          (args["jobType"] == SendJobType.REMARK)
              ? "ส่งงานแบบมีหมายเหตุ"
              : "ส่งงานแบบปกติ",
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
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        (args["jobType"]) != SendJobType.REMARK
                            ? _page1()
                            : _page2(),
                        _page2()
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      (args["jobType"] == SendJobType.REMARK)
                          ? Container()
                          : Expanded(
                              child: FxContainer.transparent(
                                  color: (controller.currentPageState == 0)
                                      ? Colors.grey
                                      : Colors.red,
                                  borderRadiusAll: 0,
                                  onTap: controller.previousPage,
                                  child: Center(
                                    child: FxText("ย้อนกลับ",
                                        color: Colors.white, fontWeight: 600),
                                  )),
                            ),
                      Expanded(
                        child: FxContainer.transparent(
                            color: SLColor.BLUE,
                            borderRadiusAll: 0,
                            onTap: controller.nextPage,
                            child: Center(
                              child: FxText(
                                  (controller.currentPageState == 1)
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

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }
}
