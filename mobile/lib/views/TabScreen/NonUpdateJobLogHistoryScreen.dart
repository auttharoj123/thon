import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/HomeController.dart';
import 'package:slpod/controllers/NonUpdateJobLogHistoryController.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';

class NonUpdateJobLogHistoryScreen extends StatefulWidget {
  const NonUpdateJobLogHistoryScreen({super.key});

  @override
  State<NonUpdateJobLogHistoryScreen> createState() =>
      _NonUpdateJobLogHistoryScreen();
}

class _NonUpdateJobLogHistoryScreen
    extends State<NonUpdateJobLogHistoryScreen> {
  GlobalWidget _globalWidget = GlobalWidget();
  late NonUpdateJobLogHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller =
        FxControllerStore.putOrFind(NonUpdateJobLogHistoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.blue,
        //   title: FxText.titleMedium("ประวัติการส่งงาน"),
        // ),
        body: FxBuilder<NonUpdateJobLogHistoryController>(
            controller: controller,
            builder: (context1) {
              return Stack(children: [
                Transform.scale(
                  scale: 1.5,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200)),
                        gradient: LinearGradient(colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade200
                        ])),
                  ),
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: FxSpacing.xy(10, 10),
                            child: _globalWidget.menuButton(),
                          ),
                          FxSpacing.width(20),
                          FxText.titleLarge("ประวัติการส่งงาน",
                              color: Colors.white)
                        ],
                      ),
                      Expanded(
                        child: FxContainer.bordered(
                          color: Colors.grey.shade100,
                          margin: FxSpacing.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          child: Column(
                            children: [
                              FxContainer(
                                color: Colors.blue,
                                paddingAll: 5,
                                child: Row(children: [
                                  FxContainer(
                                      paddingAll: 8,
                                      onTap: () {
                                        controller.selectedGroup = 0;
                                        controller.loadData();
                                      },
                                      color: (controller.selectedGroup == 0)
                                          ? Colors.green
                                          : Colors.transparent,
                                      child: Row(
                                        children: [
                                          Icon(Icons.check,
                                              color: Colors.white),
                                          FxSpacing.width(10),
                                          FxText.titleSmall(
                                            "ส่งแล้ว",
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                  FxContainer(
                                      paddingAll: 8,
                                      onTap: () {
                                        controller.selectedGroup = 1;
                                        controller.loadData();
                                      },
                                      color: (controller.selectedGroup == 1)
                                          ? Colors.yellow.shade700
                                          : Colors.transparent,
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.inbox,
                                              color: Colors.white),
                                          FxSpacing.width(10),
                                          FxText.titleSmall(
                                            "รอดำเนินการ",
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                                  Expanded(child: Container()),
                                  (controller.selectedGroup == 1)
                                      ? FxContainer.transparent(
                                          paddingAll: 0,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _globalWidget
                                                        .infoYesNoDialog(
                                                      context,
                                                      "ต้องการส่งงานทั้งหมดหรือไม่?",
                                                      acceptPressed: () async {
                                                        await controller
                                                            .syncAllJob();
                                                      },
                                                    ));
                                          },
                                          child: Icon(
                                            Icons.upload,
                                            color: Colors.green.shade300,
                                            size: 30,
                                          ),
                                        )
                                      : Container(),
                                  FxSpacing.width(10),
                                  (controller.selectedGroup == 0)
                                      ? FxContainer.transparent(
                                          paddingAll: 0,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _globalWidget.errorYesNoDialog(
                                                        context,
                                                        "กรุณายืนยันเคลียร์ข้อมูลทั้งหมด ?",
                                                        acceptPressed:
                                                            () async {
                                                      await controller
                                                          .removeData(true);
                                                    }));
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        )
                                      : Container()
                                ]),
                              ),
                              FxSpacing.height(10),
                              (controller.selectedGroup == 0)
                                  ? FxText(
                                      "*ระบบจะเก็บประวัติการส่งงานไม่เกิน 7 วัน*",
                                      color: Colors.red)
                                  : Container(),
                              FxSpacing.height(20),
                              Expanded(
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: controller.jobs.length,
                                    itemBuilder: (context, index) {
                                      var job = controller.jobs[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                    FontAwesomeIcons
                                                                        .barcode,
                                                                    color: Colors
                                                                        .blue),
                                                                FxSpacing.width(
                                                                    10),
                                                                Column(
                                                                  children: job
                                                                      .barcodes
                                                                      .split(
                                                                          ',')
                                                                      .map((e) {
                                                                    return FxText(
                                                                        e);
                                                                  }).toList(),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          FxSpacing.width(10),
                                                          (controller.selectedGroup ==
                                                                      1 &&
                                                                  job.result !=
                                                                      null)
                                                              ? FxContainer(
                                                                  paddingAll: 5,
                                                                  color: Colors
                                                                      .red
                                                                      .shade300,
                                                                  child: FxText
                                                                      .titleSmall(
                                                                    "ไม่สำเร็จ",
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                      FxSpacing.height(10),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  color: Colors
                                                                      .blue),
                                                              FxSpacing.width(
                                                                  10),
                                                              FxText.titleSmall(DateFormat(
                                                                      'yyyy/MM/dd kk:mm')
                                                                  .format(job
                                                                      .updatedDate
                                                                      .toLocal())),
                                                            ],
                                                          ),
                                                          FxSpacing.width(10),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.image,
                                                                  color: Colors
                                                                      .blue),
                                                              FxSpacing.width(
                                                                  10),
                                                              FxText.titleMedium(
                                                                  job.imagesPath
                                                                      .length
                                                                      .toString())
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      FxSpacing.height(10),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              FontAwesomeIcons
                                                                  .paperPlane,
                                                              color:
                                                                  Colors.blue),
                                                          FxSpacing.width(10),
                                                          FxText.titleMedium(
                                                              job.sendJobType ==
                                                                      SendJobType
                                                                          .NORMAL
                                                                  ? "แบบปกติ"
                                                                  : "แบบมีหมายเหตุ",
                                                              color:
                                                                  Colors.green)
                                                        ],
                                                      ),
                                                      (job.result != null)
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                FxSpacing
                                                                    .height(10),
                                                                FxContainer(
                                                                  color: Colors
                                                                      .red
                                                                      .shade200,
                                                                  child: FxText(
                                                                      job.result ??
                                                                          "",
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                                // FxContainer(
                                                //   child: Icon(Icons.upload,
                                                //       color: Colors.green),
                                                // )
                                              ],
                                            ),
                                            FxSpacing.height(20),
                                            Divider(
                                              height: 2,
                                              color: Colors.grey.shade400,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
            }));
  }
}
