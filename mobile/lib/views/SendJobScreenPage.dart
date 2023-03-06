import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          (args["jobType"] == SendJobType.REMARK)
              ? Container(
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
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none),
                        ),
                        hint: FxText(
                          "หมายเหตุการส่งงาน",
                          color: Colors.black,
                        ),
                        // value: _valYear,
                        items: controller.appController.mstTypes.map((e) {
                          return DropdownMenuItem<String>(
                            child: FxText(e.typeDetail, color: Colors.black),
                            value: e.mstTypeId.toString(),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            controller.remarkCatIdDump = value!;
                          });
                        },
                      ),
                    ),
                  ),
                )
              : FxContainer(
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
                                          controller.signatureController
                                              .clear();
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

  // Widget _page2() {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //               ToggleButton(value: "ค่าขึ้นชั้น"),
  //               ToggleButton(value: "ค่าจอดรถ"),
  //             ]),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //               ToggleButton(value: "ค่าพาเลท"),
  //               ToggleButton(value: "ค่าเด็กยก/จัดเรียง"),
  //             ]),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //               ToggleButton(value: "ค่าลิฟต์"),
  //               ToggleButton(value: "ค่ารถเข็น"),
  //             ]),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //               ToggleButton(value: "ใช้เวลาในการส่ง 1 ชม."),
  //               ToggleButton(value: "ใช้เวลาในการส่ง 2 ชม.ขึ้นไป"),
  //             ]),

  //             // SingleChildScrollView(
  //             //   scrollDirection: Axis.horizontal,
  //             //   child: Row(
  //             //     children: [
  //             //       ToggleButton(value: "ค่าขึ้นชั้น"),
  //             //       ToggleButton(value: "ค่าจอดรถ"),
  //             //       ToggleButton(value: "ค่าพาเลท"),
  //             //       ToggleButton(value: "ค่าเด็กยก/จัดเรียง"),
  //             //       ToggleButton(value: "ค่าลิฟต์"),
  //             //       ToggleButton(value: "ค่ารถเข็น"),
  //             //       ToggleButton(value: "ใช้เวลาในการส่ง 1 ชม."),
  //             //       ToggleButton(value: "ใช้เวลาในการส่ง 2 ชม.ขึ้นไป"),
  //             //     ],
  //             //   ),
  //             // ),
  //             FxSpacing.height(20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Row(
  //                   children: [
  //                     FxContainer.roundBordered(
  //                         paddingAll: 10,
  //                         bordered: false,
  //                         color: SLColor.LIGHTBLUE2,
  //                         child: Icon(
  //                           FontAwesomeIcons.fileImage,
  //                           size: 20,
  //                           color: Colors.white,
  //                         )),
  //                     FxSpacing.width(10),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         FxText.titleMedium("รูปภาพ"),
  //                         FxText.titleMedium(
  //                             "จำนวน ${controller.selectedImages.length}/10 รูป",
  //                             xMuted: true),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         FxContainer.roundBordered(
  //                           onTap: () async {
  //                             await controller.pickMultiImage();
  //                           },
  //                           child: Icon(FontAwesomeIcons.image),
  //                         ),
  //                         FxSpacing.width(10),
  //                         FxContainer.roundBordered(
  //                           onTap: () async {
  //                             await controller.pickCameraImage();
  //                           },
  //                           child: Icon(FontAwesomeIcons.camera),
  //                         ),
  //                       ]),
  //                 )
  //               ],
  //             ),
  //             FxSpacing.height(10),
  //             Divider(height: 2),
  //             FxSpacing.height(10),
  //             Expanded(
  //               child: GridView.builder(
  //                   gridDelegate:
  //                       const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                   ),
  //                   controller: controller.scrollController,
  //                   itemCount: controller.selectedImages.length,
  //                   itemBuilder: (context, index) {
  //                     return FxContainer.transparent(
  //                       color: Colors.grey.shade400,
  //                       borderRadiusAll: 0,
  //                       marginAll: 5,
  //                       paddingAll: 0,
  //                       onTap: () {
  //                         Navigator.of(context).push(PageRouteBuilder(
  //                             opaque: false,
  //                             pageBuilder: (BuildContext context, _, __) =>
  //                                 FullImageScreen(
  //                                   imagePath: controller.selectedImages[index],
  //                                   imageTag: 'imageTag-' + index.toString(),
  //                                   backgroundOpacity: 200,
  //                                 )));
  //                       },
  //                       // padding: const EdgeInsets.all(8.0),
  //                       child: Stack(
  //                         children: [
  //                           Hero(
  //                               tag: 'imageTag-' + index.toString(),
  //                               child: Center(
  //                                 child: Container(
  //                                   child: Image.file(
  //                                       File(controller.selectedImages[index]),
  //                                       height: 200,
  //                                       fit: BoxFit.fitHeight),
  //                                 ),
  //                               )),
  //                           Container(
  //                             color: Colors.black.withAlpha(80),
  //                             height: 40,
  //                             margin: FxSpacing.only(top: 0, left: 0),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 FxContainer.transparent(
  //                                   width: 30,
  //                                   height: 30,
  //                                   paddingAll: 0,
  //                                   child: Center(
  //                                     child: FxText(
  //                                         '# ${(index + 1).toString()}',
  //                                         color: Colors.white),
  //                                   ),
  //                                 ),
  //                                 FxContainer.roundBordered(
  //                                   margin: FxSpacing.right(5),
  //                                   onTap: () {
  //                                     controller.selectedImages.removeAt(index);
  //                                     controller.update();
  //                                   },
  //                                   color: Colors.red,
  //                                   width: 24,
  //                                   height: 24,
  //                                   paddingAll: 0,
  //                                   child: Icon(
  //                                     FontAwesomeIcons.xmark,
  //                                     color: Colors.white,
  //                                     size: 12,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     );
  //                   }),
  //             )
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _page2() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Container(
      child: CustomScrollView(
        slivers: [
          (args["jobType"] == SendJobType.REMARK)
              ? SliverList(
                  key: const PageStorageKey(0),
                  delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      ToggleButton(
                          value: "ร้านปิดชั่วคราว",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ร้านค้าปิดกิจการ",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "ลูกค้านัดส่ง",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "เกิดอุบัติเหตุ/รถเสีย",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "จัดส่งโดย partner",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ลูกค้าไม่สะดวกรับสินค้า",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "ติดต่อลูกค้าไม่ได้",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ชำรุด/จัดส่งสินค้าไม่ครบ",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  FxSpacing.height(10),
                  Divider(height: 2),
                  FxSpacing.height(10),
                ]))
              : SliverList(
                  key: const PageStorageKey(1),
                  delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      ToggleButton(
                          value: "ค่าขึ้นชั้น",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ค่าจอดรถ",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "ค่าพาเลท",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ค่าเด็กยก/จัดเรียง",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "ค่าลิฟต์",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ค่ารถเข็น",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      ToggleButton(
                          value: "ใช้เวลาในการส่ง 1 ชม.",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                      ToggleButton(
                          value: "ใช้เวลาในการส่ง 2 ชม.ขึ้นไป",
                          onChecked: (value) {
                            controller.checkedSpecialRemark(value);
                          }),
                    ],
                  ),
                  FxSpacing.height(10),
                  Divider(height: 2),
                  FxSpacing.height(10),
                ])),
          SliverList(
              key: const PageStorageKey(2),
              delegate: SliverChildListDelegate(
                [
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
                          FontAwesomeIcons.fileImage,
                          size: 20,
                          color: Colors.white,
                        )),
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    FxContainer.roundBordered(
                      onTap: () async {
                        await controller.pickMultiImage();
                      },
                      child: Icon(FontAwesomeIcons.image),
                    ),
                    FxSpacing.width(10),
                    FxContainer.roundBordered(
                      onTap: () async {
                        await controller.pickCameraImage();
                      },
                      child: Icon(FontAwesomeIcons.camera),
                    ),
                  ]),
                )
              ],
            ),
            FxSpacing.height(10),
            Divider(height: 2),
            FxSpacing.height(10),
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
                            width: 30,
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
                              controller.update();
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
                      children: [_page1(), _page2()],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
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
