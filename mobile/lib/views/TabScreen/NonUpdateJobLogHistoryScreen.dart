import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            builder: (context) {
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
                          FxText.titleLarge("ประวัติการส่งงาน",
                              color: Colors.white)
                        ],
                      ),
                      Expanded(
                        child: FxContainer.bordered(
                          margin: FxSpacing.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          child: Column(
                            children: [
                              FxContainer(
                                onTap: () {
                                  controller.selectedGroup = 0;
                                  controller.loadData();
                                },
                                child: Row(children: [
                                  FxContainer(
                                      color: (controller.selectedGroup == 0)
                                          ? Colors.green
                                          : Colors.transparent,
                                      child: FxText.titleSmall(
                                        "สำเร็จ",
                                        color: (controller.selectedGroup == 0)
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  FxContainer(
                                      onTap: () {
                                        controller.selectedGroup = 1;
                                        controller.loadData();
                                      },
                                      color: (controller.selectedGroup == 1)
                                          ? Colors.green
                                          : Colors.transparent,
                                      child: FxText.titleSmall(
                                        "ไม่สำเร็จ",
                                        color: (controller.selectedGroup == 1)
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  Expanded(child: Container()),
                                  FxText.titleSmall("เคลียร์ข้อมูล",color: Colors.red)
                                ]),
                              ),
                              FxSpacing.height(20),
                              Expanded(
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: controller.jobs.length,
                                    itemBuilder: (context, index) {
                                      var job = controller.jobs[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .barcode,
                                                        color: Colors.blue),
                                                    FxSpacing.width(10),
                                                    Flexible(
                                                        child: FxText.titleMedium(
                                                            '${job.barcodes}')),
                                                  ],
                                                ),
                                              ),
                                              FxSpacing.width(10),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.image,
                                                          color: Colors.blue),
                                                      FxText.titleMedium(job
                                                          .imagesPath.length
                                                          .toString())
                                                    ],
                                                  ),
                                                  FxSpacing.width(20),
                                                  FxContainer(
                                                    paddingAll: 5,
                                                    color:
                                                        Colors.green.shade300,
                                                    child: FxText.titleSmall(
                                                      "สำเร็จ",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          FxSpacing.height(20),
                                          Divider(
                                            height: 2,
                                            color: Colors.grey.shade400,
                                          )
                                        ],
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
