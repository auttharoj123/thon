import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:slpod/components/RadioCheckButton.dart';
import 'package:slpod/components/expansion_tile_partial.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';
import 'package:slpod/views/SLState.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/HomeController.dart';
import '../../loading_effect.dart';

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends SLState<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int selectedCategory = 0;
  late ThemeData theme;
  late CustomTheme customTheme;
  late HomeController controller;
  late ScrollController _scrollController;
  late TextEditingController _searchTextController;
  // late DateRangePickerController _dateRangePickerController;
  late MobileScannerController _mobileScannerController;
  late GlobalWidget _globalWidget;
  double topPointCard = 60;
  bool isPanning = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    controller = FxControllerStore.putOrFind(HomeController(), save: false);
    // _dateRangePickerController = DateRangePickerController();
    _searchTextController = TextEditingController();
    _mobileScannerController =
        MobileScannerController(detectionSpeed: DetectionSpeed.unrestricted);
    _scrollController = ScrollController();
    _globalWidget = GlobalWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Widget _buildViewButton(dynamic job) {
  //   if (controller.selectedJobs.length > 0) return Container();

  //   return FxContainer.roundBordered(
  //     color: Colors.blue,
  //     onTap: () {
  //       controller.goToJobDetailPage(job);
  //     },
  //     paddingAll: 10,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           FontAwesomeIcons.eye,
  //           color: Colors.white,
  //           size: 16,
  //         ),
  //         // FxSpacing.width(10),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRadioButton(dynamic job) {
    if (controller.selectedJobs.length > 0) {
      return FxContainer.roundBordered(
        onTap: () {
          if (job is JobDetailWrapper) {
            var foundItems = job.items.where(
                (element) => controller.selectedJobIds.contains(element));
            controller.selectedJobIds.removeWhere(
              (element) {
                return foundItems.contains(element);
              },
            );
            controller.selectedJobs.remove(job);
          } else {
            controller.selectedJobIds.remove(job);
            controller.selectedJobs.removeWhere((element) {
              return element.items.contains(job);
            });
          }
          setState(() {});
        },
        bordered: false,
        color: Colors.red,
        paddingAll: 2,
        marginAll: 10,
        child: Icon(FontAwesomeIcons.xmark, color: Colors.white),
      );
    }

    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          width: (controller.selectionJobType == SelectionJobType.send_job)
              ? 30
              : 0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: (controller.selectionJobType == SelectionJobType.send_job)
                ? 1.0
                : 0.0,
            child: FxContainer.transparent(
              paddingAll: 0,
              child: RadioCheckButton(job.isChecked),
              // child: job.isChecked
              //     ? Icon(
              //         Icons.check_circle,
              //         size: 30,
              //         color: Colors.blue,
              //       )
              //     : Icon(
              //         Icons.circle,
              //         size: 30,
              //         color: Colors.grey,
              //       ),
            ),
          ),
        ),
        FxSpacing.width(
            (controller.selectionJobType == SelectionJobType.send_job)
                ? 10
                : 0),
      ],
    );
  }

  Widget _buildCall(JobDetail job) {
    return (job.contactTelephone.isNotEmpty)
        ? FxContainer.roundBordered(
            marginAll: 0,
            onTap: () async {
              await launchUrl(Uri(scheme: 'tel', path: job.contactTelephone));
            },
            color: (job.contactTelephone.isNotEmpty)
                ? Colors.green.shade300
                : Colors.grey,
            paddingAll: 5,
            child: Icon(
              Icons.call,
              color: Colors.white,
              size: 15,
            ),
          )
        : Container();
  }

  Widget clearSelectionDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Lottie.asset("assets/animations/lottie/warning.json",
                    height: 50),
                FxSpacing.width(8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: FxTextStyle.bodyLarge(
                            fontWeight: 500, letterSpacing: 0.2),
                        children: <TextSpan>[
                          TextSpan(text: "ยกเลิกรายการที่เลือกทั้งหมดหรือไม่?"),
                        ]),
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: FxText.bodyMedium(
                          "ปิด",
                          fontWeight: 700,
                          letterSpacing: 0.4,
                          color: Colors.red,
                        )),
                    FxSpacing.width(10),
                    FxButton(
                        backgroundColor: SLColor.LIGHTBLUE2,
                        borderRadiusAll: 4,
                        elevation: 0,
                        onPressed: () {
                          Navigator.pop(context);
                          // if (controller.selectionJobType ==
                          //     SelectionJobTypes.camera) {
                          //   controller.filteredJobs = [];
                          // }
                          controller.clearAllSelection();
                        },
                        child: FxText.bodyMedium("ยืนยัน",
                            letterSpacing: 0.4,
                            color: theme.colorScheme.onPrimary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget inputBarcodeDialog(context) {
    var isProcessing = false;
    var errorFromServerText = '';
    var _textController = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: FxSpacing.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FxText.titleLarge(
                  (controller.selectionJobType == SelectionJobType.receive_job)
                      ? 'ค้นหาบาร์โค้ดและรับงาน'
                      : 'ป้อนบาร์โค้ดเพื่อเลือก',
                  fontWeight: 600,
                ),
                (errorFromServerText.isNotEmpty)
                    ? FxText.titleMedium(
                        errorFromServerText,
                        fontWeight: 600,
                        color: Colors.red,
                      )
                    : Container(),
                FxSpacing.height(20),
                // FxTextField()
                TextFormField(
                  controller: _textController,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    errorStyle: TextStyle(fontFamily: 'Kanit', fontSize: 14),
                    filled: true,
                    fillColor: customTheme.card,
                    labelText: 'ป้อนหมายเลขบาร์โค้ด',
                    contentPadding: EdgeInsets.zero,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.barcode,
                      color: Colors.blue,
                    ),
                    labelStyle: FxTextStyle.bodyMedium(
                        color: theme.colorScheme.onBackground, xMuted: true),
                  ),
                  cursorColor: customTheme.medicarePrimary,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) return "กรุณาป้อนบาร์โค้ด";
                  },
                ),
                Container(
                    margin: FxSpacing.top(8),
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AbsorbPointer(
                          absorbing: isProcessing,
                          child: FxButton.text(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: FxText.bodyMedium(
                                "ปิด",
                                fontWeight: 700,
                                letterSpacing: 0.4,
                                color: isProcessing ? Colors.grey : Colors.red,
                              )),
                        ),
                        FxSpacing.width(10),
                        AbsorbPointer(
                          absorbing: isProcessing,
                          child: FxButton(
                              backgroundColor: isProcessing
                                  ? Colors.grey
                                  : SLColor.LIGHTBLUE2,
                              borderRadiusAll: 4,
                              elevation: 0,
                              onPressed: () async {
                                if (!controller.formKey.currentState!
                                    .validate()) return;
                                var value = _textController.text;
                                if (controller.selectionJobType ==
                                    SelectionJobType.receive_job) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      errorFromServerText = '';
                                      isProcessing = true;
                                    });
                                    controller.appController.api
                                        .updateJobStatusByBarCode(value)
                                        .then((response) {
                                      if (response != null) {
                                        if (response["isSuccess"]) {
                                          Navigator.of(context).pop();
                                          controller.reloadAllJobs(
                                              forceReload: true);
                                        } else {
                                          setState(() {
                                            errorFromServerText =
                                                response["message"];
                                          });
                                        }
                                      }
                                    }).catchError((error, stackTrace) {
                                      setState(() {
                                        errorFromServerText =
                                            'ระบบขัดข้อง กรุณาลองใหม่อีกครั้ง';
                                      });
                                    }).whenComplete(() {
                                      setState(() {
                                        isProcessing = false;
                                      });
                                    });
                                  }
                                } else {
                                  var errorMessage =
                                      await controller.searchJobsForSend(value);
                                  Navigator.of(context).pop();
                                  if (errorMessage.isNotEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            _globalWidget.errorDialog(
                                                context, errorMessage));
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  FxText.bodyMedium("ยืนยัน",
                                      letterSpacing: 0.4,
                                      color: theme.colorScheme.onPrimary),
                                  FxSpacing.width(10),
                                  (isProcessing)
                                      ? Container(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                              color: Colors.blue,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue)),
                                        )
                                      : Container(),
                                ],
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget showConfirmScanBarcode(context, jobDetail) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: FxSpacing.right(16),
                  child: Icon(
                    FontAwesomeIcons.circleCheck,
                    size: 28,
                    color: Colors.green.shade700,
                  ),
                ),
                FxSpacing.width(8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: FxTextStyle.bodyLarge(
                            fontWeight: 500, letterSpacing: 0.2),
                        children: <TextSpan>[
                          TextSpan(text: "พบหมายเลขบาร์โค้ด "),
                          TextSpan(
                              text: "${jobDetail[0].barcode}",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ]),
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.isShowList = true;
                          setState(() {});
                        },
                        child: FxText.bodyMedium("ยกเลิก",
                            fontWeight: 700, letterSpacing: 0.4)),
                    FxSpacing.width(10),
                    FxButton(
                        backgroundColor: SLColor.LIGHTBLUE2,
                        borderRadiusAll: 4,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.selectJobByBarcode(jobDetail);
                          _mobileScannerController.start();
                        },
                        child: FxText.bodyMedium("ยืนยันรายการ",
                            letterSpacing: 0.4,
                            color: theme.colorScheme.onPrimary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget showSendJobRequired(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: FxSpacing.right(16),
                  child: Icon(
                    FontAwesomeIcons.xmark,
                    size: 28,
                    color: Colors.red.shade700,
                  ),
                ),
                FxSpacing.width(8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: FxTextStyle.bodyLarge(
                            fontWeight: 500, letterSpacing: 0.2),
                        children: <TextSpan>[
                          TextSpan(text: "กรุณาเลือกงานที่ต้องการส่ง")
                        ]),
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: FxText.bodyMedium("ตกลง",
                            fontWeight: 700, letterSpacing: 0.4)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget showDuplicateScanBarcode(context, jobDetail) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: FxSpacing.right(16),
                  child: Icon(
                    FontAwesomeIcons.xmark,
                    size: 28,
                    color: Colors.red.shade700,
                  ),
                ),
                FxSpacing.width(8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: FxTextStyle.bodyLarge(
                            fontWeight: 500, letterSpacing: 0.2),
                        children: <TextSpan>[
                          TextSpan(text: "หมายเลขบาร์โค้ด "),
                          TextSpan(
                              text: "${jobDetail[0].barcode}",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: " ได้ถูกเลือกแล้ว"),
                        ]),
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.isShowList = true;
                          setState(() {});
                        },
                        child: FxText.bodyMedium("ยกเลิก",
                            fontWeight: 700, letterSpacing: 0.4)),
                    FxSpacing.width(10),
                    FxButton(
                        backgroundColor: SLColor.LIGHTBLUE2,
                        borderRadiusAll: 4,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _mobileScannerController.start();
                        },
                        child: FxText.bodyMedium("ทำรายการต่อ",
                            letterSpacing: 0.4,
                            color: theme.colorScheme.onPrimary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget showSelectionTypeDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: FxSpacing.right(16),
                  child: Icon(
                    FontAwesomeIcons.barcode,
                    size: 28,
                  ),
                ),
                FxSpacing.width(8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        style: FxTextStyle.bodyLarge(
                            fontWeight: 500, letterSpacing: 0.2),
                        children: <TextSpan>[
                          TextSpan(text: "เปิดใช้งานเลือกงานโดยสแกนบาร์โค้ด?"),
                        ]),
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: FxText.bodyMedium("ปิด",
                            fontWeight: 700, letterSpacing: 0.4)),
                    FxSpacing.width(10),
                    FxButton(
                        backgroundColor: SLColor.LIGHTBLUE2,
                        borderRadiusAll: 4,
                        elevation: 0,
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            // controller.toggleSendJobButtonFunc(
                            //     SelectionJobTypes.camera);
                          } on PlatformException {}
                        },
                        child: FxText.bodyMedium("ยืนยัน",
                            letterSpacing: 0.4,
                            color: theme.colorScheme.onPrimary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildLateDeliveryWarning(job) {
    return (controller.selectedJobStatus == JobStatus.SENDING &&
            DateTime.now()
                .subtract(Duration(days: 0))
                .isAfter(job.deliveryDate))
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FxText("เกินกำหนด 3 วัน",
                      fontWeight: 600, fontSize: 14, color: Colors.red),
                  FxSpacing.width(10),
                  Lottie.asset("assets/animations/lottie/warning-sign.json",
                      height: 30)
                ],
              ),
              FxSpacing.height(10),
            ],
          )
        : Container();
  }

  Widget _buildJobDetailWrapperItem(JobDetailWrapper wrapper) {
    var titleFontSize = 14.0;
    if (wrapper.items.length == 1) {
      return _buildJobDetailItem(wrapper.items[0]);
    }

    return FxContainer.transparent(
      onTap: () {
        if (controller.selectionJobType == SelectionJobType.receive_job ||
            controller.selectedJobs.length > 0) return;

        if (!wrapper.isChecked) {
          wrapper.isChecked = true;
          wrapper.items.forEach((element) {
            element.isChecked = true;
            if (!controller.selectedJobIds.contains(element)) {
              controller.selectedJobIds.add(element);
            }
          });
        } else {
          wrapper.isChecked = false;
          wrapper.items.forEach((element) {
            element.isChecked = false;
            controller.selectedJobIds.remove(element);
          });
        }
        setState(() {});
      },
      paddingAll: 0,
      bordered: false,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FxSpacing.height(10),
                    ExpansionTileNew(
                      backgroundColor: Colors.transparent,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _buildRadioButton(wrapper),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FxText(
                                              "${wrapper.title}",
                                              fontWeight: 600,
                                              color: Colors.blue,
                                              fontSize: 18,
                                            ),
                                            FxSpacing.width(10),
                                            _buildCall(wrapper.items[0])
                                          ],
                                        ),
                                        // FxSpacing.width(20),
                                        (wrapper.items[0].directionType == 1)
                                            ? FxContainer.bordered(
                                                bordered: false,
                                                color: Colors.red.shade300,
                                                paddingAll: 5,
                                                child: FxText("จัดส่ง",
                                                    fontSize: titleFontSize,
                                                    color: Colors.white))
                                            : FxContainer.bordered(
                                                bordered: false,
                                                color: Colors.red.shade300,
                                                paddingAll: 5,
                                                child: FxText("รับคืน",
                                                    fontSize: titleFontSize,
                                                    color: Colors.white)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          FxSpacing.height(10),
                          _buildLateDeliveryWarning(wrapper.items[0]),
                          Row(
                            children: [
                              FxText(
                                "จำนวนสินค้าทั้งหมด: ",
                                fontWeight: 600,
                                fontSize: titleFontSize,
                                color: Colors.grey,
                              ),
                              FxSpacing.width(10),
                              FxText(
                                "${wrapper.totalQty}",
                                fontWeight: 600,
                                fontSize: titleFontSize,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          FxSpacing.height(10),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.user,
                                color: Colors.blue,
                                size: 20,
                              ),
                              FxSpacing.width(10),
                              Flexible(
                                child: FxText(
                                  "${wrapper.items[0].receiverName}",
                                  fontWeight: 600,
                                  fontSize: titleFontSize,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          (controller.selectedJobs.length == 0)
                              ? Column(
                                  children: [
                                    FxSpacing.height(10),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.route,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        FxSpacing.width(10),
                                        Flexible(
                                          child: FxText(
                                            "${wrapper.items[0].routeName}",
                                            fontWeight: 600,
                                            fontSize: titleFontSize,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    FxSpacing.height(10),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.calendar,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        FxSpacing.width(10),
                                        FxText(
                                          "${formatDate(wrapper.items[0].deliveryDateEx, [
                                                dd,
                                                '/',
                                                mm,
                                                '/',
                                                yyyy,
                                                ' ',
                                                HH,
                                                ':',
                                                nn
                                              ])}",
                                          fontWeight: 600,
                                          fontSize: titleFontSize,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    FxSpacing.height(10),
                                    (wrapper.items[0].remark.isNotEmpty)
                                        ? FxContainer(
                                            color: Colors.red.shade100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                FxText(
                                                  "หมายเหตุ : ",
                                                  xMuted: false,
                                                  fontSize: titleFontSize,
                                                  color: Colors.red,
                                                ),
                                                FxSpacing.width(2),
                                                FxText(
                                                  wrapper.items[0].remark,
                                                  xMuted: false,
                                                  color: Colors.red,
                                                  fontSize: titleFontSize,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.all(10),
                      children: wrapper.items.map((e) {
                        return _buildJobDetailItemByGroup(wrapper, e);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailItem(JobDetail job) {
    var titleFontSize = 14.0;
    return FxContainer.transparent(
      onTap: () {
        if (controller.selectionJobType == SelectionJobType.receive_job) return;

        if (controller.selectedJobs.length > 0) {
          controller.goToJobDetailPage(job);
          return;
        }

        if (!job.isChecked) {
          job.isChecked = true;
          if (!controller.selectedJobIds.contains(job)) {
            controller.selectedJobIds.add(job);
          }
        } else {
          job.isChecked = false;
          controller.selectedJobIds.remove(job);
        }
        setState(() {});
      },
      paddingAll: 0,
      bordered: false,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _buildRadioButton(job),
                  Expanded(
                    child: Row(
                      children: [
                        FxContainer.transparent(
                          paddingAll: 5,
                          onTap: () {
                            controller.goToJobDetailPage(job);
                          },
                          child: Row(
                            children: [
                              FxText(
                                "${job.barcode}",
                                fontWeight: 600,
                                fontSize: 18,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              FxSpacing.width(10),
                              _buildCall(job)
                            ],
                          ),
                        ),
                        FxSpacing.width(20),
                        (job.directionType == 1)
                            ? FxContainer.bordered(
                                bordered: false,
                                color: Colors.red.shade300,
                                paddingAll: 5,
                                child: FxText("จัดส่ง",
                                    fontSize: titleFontSize,
                                    color: Colors.white))
                            : FxContainer.bordered(
                                bordered: false,
                                color: Colors.red.shade300,
                                paddingAll: 5,
                                child: FxText("รับคืน",
                                    fontSize: titleFontSize,
                                    color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              FxSpacing.height(10),
              _buildLateDeliveryWarning(job),
              Row(
                children: [
                  FxText(
                    "จำนวนสินค้า: ",
                    fontWeight: 600,
                    fontSize: titleFontSize,
                    color: Colors.grey,
                  ),
                  FxSpacing.width(10),
                  FxText(
                    "${job.qty}",
                    fontWeight: 600,
                    fontSize: titleFontSize,
                    color: Colors.grey,
                  ),
                ],
              ),
              FxSpacing.height(10),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.user,
                    color: Colors.blue,
                    size: 20,
                  ),
                  FxSpacing.width(10),
                  Flexible(
                    child: FxText(
                      "${job.receiverName}",
                      fontWeight: 600,
                      fontSize: titleFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              (controller.selectedJobs.length == 0)
                  ? Column(
                      children: [
                        FxSpacing.height(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.route,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  FxSpacing.width(10),
                                  Flexible(
                                    child: FxText(
                                      "${job.routeName}",
                                      fontWeight: 600,
                                      fontSize: titleFontSize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        FxSpacing.height(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.calendar,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  FxSpacing.width(10),
                                  FxText(
                                    "${formatDate(job.deliveryDateEx, [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                          ' ',
                                          HH,
                                          ':',
                                          nn
                                        ])}",
                                    fontWeight: 600,
                                    fontSize: titleFontSize,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        FxSpacing.height(10),
                        (job.remark.isNotEmpty)
                            ? FxContainer(
                                color: Colors.red.shade100,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    FxText(
                                      "หมายเหตุ : ",
                                      xMuted: false,
                                      fontSize: titleFontSize,
                                      color: Colors.red,
                                    ),
                                    FxSpacing.width(2),
                                    FxText(
                                      job.remark,
                                      xMuted: false,
                                      color: Colors.red,
                                      fontSize: titleFontSize,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailItemByGroup(JobDetailWrapper wrapper, JobDetail job) {
    var titleFontSize = 14.0;
    return FxContainer.transparent(
      onTap: () {
        if (controller.selectionJobType == SelectionJobType.receive_job) return;

        if (controller.selectedJobs.length > 0) {
          controller.goToJobDetailPage(job);
          return;
        }

        if (!job.isChecked) {
          job.isChecked = true;
          if (!controller.selectedJobIds.contains(job))
            controller.selectedJobIds.add(job);
        } else {
          job.isChecked = false;
          controller.selectedJobIds.remove(job);
        }
        wrapper.isChecked =
            wrapper.items.where((element) => element.isChecked).length ==
                wrapper.items.length;
        setState(() {});
      },
      paddingAll: 0,
      margin: FxSpacing.only(left: 10, right: 10),
      bordered: false,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxSpacing.height(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        (controller.selectedJobs.length == 0)
                            ? _buildRadioButton(job)
                            : Container(),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          FxContainer.none(
                                            color: Colors.transparent,
                                            paddingAll: 0,
                                            onTap: () {
                                              controller.goToJobDetailPage(job);
                                            },
                                            child: FxText(
                                              "${job.receiverName}",
                                              fontWeight: 600,
                                              fontSize: 18,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Column(
                                    //   children: [
                                    //     (job.directionType == 1)
                                    //         ? FxContainer.bordered(
                                    //             bordered: false,
                                    //             color: Colors.red.shade300,
                                    //             paddingAll: 5,
                                    //             child: FxText("จัดส่ง",
                                    //                 fontSize: titleFontSize,
                                    //                 color: Colors.white))
                                    //         : FxContainer.bordered(
                                    //             bordered: false,
                                    //             color: Colors.red.shade300,
                                    //             paddingAll: 5,
                                    //             child: FxText("รับคืน",
                                    //                 fontSize: titleFontSize,
                                    //                 color: Colors.white)),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    FxSpacing.height(10),
                    Row(
                      children: [
                        FxText(
                          "จำนวนสินค้า: ",
                          fontWeight: 600,
                          fontSize: titleFontSize,
                          color: Colors.grey,
                        ),
                        FxSpacing.width(10),
                        FxText(
                          "${job.qty}",
                          fontWeight: 600,
                          fontSize: titleFontSize,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText(
                          "รายละเอียดสินค้า: ",
                          fontWeight: 600,
                          fontSize: titleFontSize,
                          color: Colors.grey,
                        ),
                        FxSpacing.width(10),
                        Flexible(
                          child: FxText(
                            "${job.goodsDetails}",
                            fontWeight: 600,
                            fontSize: titleFontSize,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildJobList() {
    if (controller.selectedJobType == SendJobTypes.group_barcode) {
      if (controller.jobs.length == 0) {
        return Center(
          child: FxText.headlineMedium("ไม่พบข้อมูล", xMuted: true),
        );
      }

      var listWidget = null;
      if (controller.selectedJobs.length > 0) {
        listWidget = ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            padding: FxSpacing.only(
                top: 20,
                bottom: controller.selectedJobIds.length > 0 ? 300 : 80),
            itemCount: controller.selectedJobs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _buildJobDetailWrapperItem(controller.selectedJobs[index]),
                  Divider(height: 10)
                ],
              );
            });
      } else {
        listWidget = ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            padding: FxSpacing.only(
                top: 20,
                bottom: controller.selectedJobIds.length > 0 ? 200 : 80),
            itemCount: controller.filteredJobs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _buildJobDetailWrapperItem(controller.filteredJobs[index]),
                  Divider(height: 10)
                ],
              );
            });
      }
      return ShaderMask(
          shaderCallback: (Rect rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.transparent,
                Colors.transparent,
                Colors.purple
              ],
              stops: [
                0.0,
                0.1,
                0.9,
                1.0
              ], // 10% purple, 80% transparent, 10% purple
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: listWidget);
    }
    return Container();
  }

  Widget _buildBody() {
    var color = controller.getOrderStatusColor(controller.selectedJobStatus);

    return Container(
      color: Colors.grey.shade200,
      child: Stack(children: [
        Transform.scale(
          scale: 1.5,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200)),
                gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade200])),
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            // isPanning = true;

            // var top = topPointCard + details.delta.dy;
            // if (top < 60 || top > 200) return;

            // setState(() {
            //   topPointCard = top;
            // });
          },
          onPanEnd: (details) {
            // isPanning = false;
            // if (topPointCard > 100) {
            //   setState(() {
            //     topPointCard = 150;
            //   });
            // } else {
            //   setState(() {
            //     topPointCard = 70;
            //   });
            // }
          },
          child: AnimatedContainer(
              duration: isPanning
                  ? Duration(seconds: 0)
                  : Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              padding: FxSpacing.top(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              margin: FxSpacing.only(top: FxSpacing.safeAreaTop(context) + topPointCard, left: 10, right: 10),
              child: Stack(
                children: [
                  FxContainer.bordered(
                    margin: FxSpacing.left(
                        MediaQuery.of(context).size.width / 2 - 60),
                    width: 100,
                    height: 4,
                    color: Colors.grey.shade300,
                  ),
                  (controller.showLoading)
                      ? SingleChildScrollView(
                          padding: FxSpacing.top(60),
                          child: LoadingEffect.getSearchLoadingScreen(
                            context,
                          ))
                      : Container(
                          margin: FxSpacing.top(10), child: _buildJobList()),
                  // Positioned(
                  //     right: 20,
                  //     child: Icon(
                  //       Icons.search,
                  //       color: Colors.blue,
                  //     )),
                  Positioned(
                      right: 20,
                      child: FxContainer.transparent(
                        onTap: () {
                          controller.reloadAllJobs(forceReload: true);
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Colors.blue,
                        ),
                      )),
                ],
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: FxSpacing.safeAreaTop(context)),
          // height: 160,
          child: Column(
            children: [
              Container(
                padding: FxSpacing.xy(10, 10),
                // margin:
                //     FxSpacing.only(top: 10, left: 10, right: 10, bottom: 10),
                // color: SLColor.LIGHTBLUE2.withOpacity(0.7),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _globalWidget.menuButton(),
                        FxSpacing.width(10),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () {
                            _selectSizeSheet();
                          },
                          child: Container(
                            padding: FxSpacing.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: color),
                            child: Row(
                              children: [
                                (controller.selectedJobStatus ==
                                        JobStatus.SENDING)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          FontAwesomeIcons.boxesPacking,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                                (controller.selectedJobStatus == JobStatus.SENT)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Icon(FontAwesomeIcons.paperPlane,
                                            size: 14, color: Colors.white),
                                      )
                                    : Container(),
                                (controller.selectedJobStatus ==
                                        JobStatus.REJECT_SENDING)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(FontAwesomeIcons.ban,
                                            size: 14, color: Colors.white),
                                      )
                                    : Container(),
                                FxText.titleSmall(
                                  '${controller.getOrderStatusTitle(controller.selectedJobStatus)} (${controller.filteredJobs.length})',
                                  color: Colors.white,
                                  fontSize: 12,
                                )
                              ],
                            ),
                            // paddingAll: 8,
                            // color: controller.getOrderStatusColor(
                            //     controller.selectedJobStatus)
                          ),
                        ),
                        FxSpacing.width(10),
                        (controller.selectedJobStatus == JobStatus.SENDING)
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.selectionJobTypeChanged(
                                          SelectionJobType.receive_job);
                                    },
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                          color: (controller.selectionJobType ==
                                                  SelectionJobType.receive_job)
                                              ? Colors.green.shade300
                                              : Colors.blue.shade300,
                                          // border: Border(
                                          //   bottom: BorderSide(width: 1, color: Colors.green)
                                          // ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))),
                                      padding: FxSpacing.all(10),
                                      duration: Duration(milliseconds: 300),
                                      child: Row(children: [
                                        // Icon(
                                        //   FontAwesomeIcons.boxesPacking,
                                        //   color: Colors.white,
                                        // ),
                                        // FxSpacing.width(15),
                                        FxText.titleSmall(
                                          "รับงาน",
                                          fontSize: 12,
                                          color: Colors.white,
                                        )
                                      ]),
                                    ),
                                  ),
                                  // VerticalDivider(width: 2,thickness: 2,color: Colors.white,),
                                  GestureDetector(
                                    onTap: () {
                                      controller.selectionJobTypeChanged(
                                          SelectionJobType.send_job);
                                    },
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                          color: (controller.selectionJobType ==
                                                  SelectionJobType.send_job)
                                              ? Colors.green.shade300
                                              : Colors.blue.shade300,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight:
                                                  Radius.circular(30))),
                                      padding: FxSpacing.all(10),
                                      duration: Duration(milliseconds: 300),
                                      child: Row(children: [
                                        // Icon(
                                        //   FontAwesomeIcons.paperPlane,
                                        //   color: Colors.white,
                                        // ),
                                        // FxSpacing.width(15),
                                        FxText.titleSmall(
                                          "ส่งงาน",
                                          fontSize: 12,
                                          color: Colors.white,
                                        )
                                      ]),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          width: MediaQuery.of(context).size.width,
          height: 150,
          bottom: controller.selectedJobIds.length > 0 ? 0 : -150,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.black.withAlpha(80),
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade500.withAlpha(150),
                      Colors.blue.shade300.withAlpha(150)
                    ]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          FxText(
                            "รูปแบบการส่งงาน / ปิดงาน",
                            color: Colors.white,
                          ),
                          Positioned(
                            right: 0,
                            child: FxContainer.transparent(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        clearSelectionDialog(context));
                              },
                              paddingAll: 0,
                              child: FxText(
                                "เคลียร์ (${controller.selectedJobIds.length})",
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FxContainer.transparent(
                            onTap: () {
                              _sendJobCommand(SendJobType.NORMAL);
                            },
                            borderRadiusAll: 0,
                            marginAll: 10,
                            bordered: false,
                            color: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                ),
                                FxSpacing.width(10),
                                FxText.titleSmall(
                                  "แบบปกติ",
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: FxContainer.transparent(
                            onTap: () {
                              _sendJobCommand(SendJobType.REMARK);
                            },
                            borderRadiusAll: 0,
                            marginAll: 10,
                            bordered: false,
                            color: Colors.amber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.triangleExclamation,
                                  color: Colors.white,
                                ),
                                FxSpacing.width(10),
                                FxText.titleSmall(
                                  "แบบมีหมายเหตุ",
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        (controller.selectedJobStatus == JobStatus.SENDING)
            ? AnimatedPositioned(
                // top: MediaQuery.of(context).size.height / 2 - 75,
                bottom: controller.selectedJobIds.length > 0 ? 150 : 20,
                right: 20,
                child: Container(
                  width: 60,
                  height: 150,
                  // decoration: BoxDecoration(
                  //     // color: Colors.blue.withAlpha(150),
                  //     borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         bottomLeft: Radius.circular(10)),
                  //     gradient: LinearGradient(colors: [
                  //       Colors.blue.shade500.withAlpha(180),
                  //       Colors.blue.shade300.withAlpha(180)
                  //     ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FxContainer.roundBordered(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    inputBarcodeDialog(context));
                          },
                          paddingAll: 10,
                          marginAll: 0,
                          bordered: false,
                          color: Colors.grey.shade200,
                          child: Lottie.asset(
                              'assets/animations/lottie/keyboard.json')),
                      FxSpacing.height(10),
                      FxContainer.roundBordered(
                          onTap: () async {
                            var value = await FlutterBarcodeScanner.scanBarcode(
                                "#ff6666", "Cancel", true, ScanMode.BARCODE);
                            // var value = await BarcodeScanner.scan();
                            if (value != "-1") {
                              if (controller.selectionJobType ==
                                  SelectionJobType.receive_job) {
                                var response = await controller
                                    .appController.api
                                    .updateJobStatusByBarCode(value);
                                if (response != null) {
                                  if (response["isSuccess"]) {
                                    AssetsAudioPlayer.playAndForget(
                                        Audio('assets/audio/bell.wav'));
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _globalWidget.successDialog(
                                              context,
                                              "สแกนบาร์โค้ด $value สำเร็จ");
                                        });
                                    controller.reloadAllJobs(forceReload: true);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _globalWidget.errorDialog(
                                              context, response["message"]);
                                        });
                                  }
                                }
                              } else {
                                var errorMessage =
                                    await controller.searchJobsForSend(value);
                                if (errorMessage.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => _globalWidget
                                          .errorDialog(context, errorMessage));
                                }
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _globalWidget.errorDialog(
                                        context, "สแกนบาร์โค้ดไม่สำเร็จ ",
                                        title2: '$value');
                                  });
                            }
                          },
                          paddingAll: 10,
                          bordered: false,
                          color: Colors.grey.shade200,
                          child: Lottie.asset(
                              'assets/animations/lottie/barcode-scanner.json'))
                    ],
                  ),
                ),
                curve: Curves.easeInOutSine,
                duration: Duration(milliseconds: 400))
            : Container()
      ]),
    );
  }

  Widget _buildSearchWidget() {
    return FxTextField(
      controller: _searchTextController,
      contentPadding: EdgeInsets.zero,
      focusedBorderColor: customTheme.medicarePrimary,
      cursorColor: customTheme.medicarePrimary,
      textFieldStyle: FxTextFieldStyle.outlined,
      labelText: 'หมายเลขออเดอร์ , อ้างอิง3',
      autofocus: false,
      labelStyle: FxTextStyle.bodyMedium(
          color: theme.colorScheme.onBackground, xMuted: true),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: customTheme.card,
      prefixIcon: Icon(
        FeatherIcons.search,
        color: customTheme.medicarePrimary,
        size: 20,
      ),
      onChanged: (value) {
        controller.searchJobs(value, controller.selectedJobStatus);
      },
      suffixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          (_searchTextController.text.isEmpty)
              ? Container()
              : FxContainer.transparent(
                  padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _searchTextController.clear();
                    controller.searchJobs(_searchTextController.text,
                        controller.selectedJobStatus);
                    //controller.reloadAllJobs();
                  },
                  child: Icon(FontAwesomeIcons.xmark,
                      color: customTheme.medicarePrimary, size: 20),
                ),
          FxContainer.transparent(
            padding: FxSpacing.only(right: 10),
            onTap: () async {
              try {
                _searchTextController.text =
                    await FlutterBarcodeScanner.scanBarcode(
                        "#ff6666", "Cancel", true, ScanMode.BARCODE);
                //print(barcodeScanRes);
                controller.searchJobs(
                    _searchTextController.text, controller.selectedJobStatus);
              } on PlatformException {
                // barcodeScanRes =
                //     'Failed to get platform version.';
              }
            },
            child: Icon(FontAwesomeIcons.barcode,
                color: customTheme.medicarePrimary, size: 20),
          ),
        ],
      ),
    );
  }

  void _sendJobCommand(int jobType) {
    if (controller.selectedJobIds.length == 0) {
      showDialog(
          context: context, builder: (context) => showSendJobRequired(context));
    } else {
      Navigator.of(NavigationService.navigatorKey.currentState!.context)
          .pushNamed("/send_job", arguments: {
        "jobType": jobType,
        "jobs": controller.selectedJobIds
      });
    }
  }

  List<Widget> _buildQuickActionMenuList(setState) {
    List<Widget> list = [
      Column(
        children: [
          FxContainer.roundBordered(
              onTap: () {
                _sendJobCommand(SendJobType.NORMAL);
              },
              color: Colors.white,
              child: Icon(FontAwesomeIcons.upload, color: Colors.green)),
          FxSpacing.height(10),
          FxText.titleMedium("ส่งงาน", color: Colors.white)
        ],
      ),
      Column(
        children: [
          FxContainer.roundBordered(
              onTap: () {
                _sendJobCommand(SendJobType.REMARK);
              },
              color: Colors.white,
              child: Icon(FontAwesomeIcons.triangleExclamation,
                  color: Colors.orange)),
          FxSpacing.height(10),
          FxText.titleMedium("หมายเหตุ", color: Colors.white)
        ],
      ),
      Column(
        children: [
          FxContainer.roundBordered(
              onTap: () {
                _sendJobCommand(SendJobType.REJECT);
              },
              color: Colors.white,
              child: Icon(FontAwesomeIcons.ban, color: Colors.red)),
          FxSpacing.height(10),
          FxText.titleMedium("ยกเลิกงาน", color: Colors.white)
        ],
      ),
    ];
    return list;
  }

  List<Widget> _buildFilterCategoryList(setState) {
    List<Widget> list = [];
    for (MapEntry<int, String> s in controller.status) {
      list.add(_buildFilterCategory(s, setState));
    }
    return list;
  }

  Widget _buildFilterCategory(MapEntry<int, String> status, setState) {
    return FxContainer(
      borderColor: (controller.selectedJobStatus == status.key)
          ? Colors.green
          : Colors.grey.shade300,
      paddingAll: 8,
      borderRadiusAll: 8,
      margin: FxSpacing.right(8),
      bordered: true,
      splashColor: customTheme.medicarePrimary.withAlpha(40),
      color: customTheme.card,
      onTap: () {
        controller.onSelectedJobStatus(status.key);
        setState(() {});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // FxSpacing.width(8),
          (status.key == JobStatus.SENDING)
              ? Icon(FontAwesomeIcons.boxesPacking,
                  color: Colors.yellow.shade600, size: 40)
              : (status.key == JobStatus.SENT)
                  ? Icon(
                      Icons.send,
                      color: Colors.green,
                      size: 40,
                    )
                  : (status.key == JobStatus.REJECT_SENDING)
                      ? Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 40,
                        )
                      : Container(),
          FxSpacing.height(8),
          FxText.bodyMedium(
            status.value,
            fontWeight: 600,
          ),
        ],
      ),
    );
  }

  void _selectSizeSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return FxContainer(
                color: Colors.white,
                padding: FxSpacing.top(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: FxSpacing.horizontal(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FxCard.rounded(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  paddingAll: 6,
                                  color: customTheme.border,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: theme.colorScheme.onBackground,
                                  ),
                                ),
                                FxText.bodyMedium(
                                  'Filters',
                                  fontWeight: 600,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.onResetFilter();
                                    setState(() {});
                                  },
                                  child: FxText.bodySmall(
                                    'Reset',
                                    color: customTheme.estatePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // FxSpacing.height(15),
                          // Padding(
                          //   padding: FxSpacing.horizontal(14),
                          //   child: FxText.bodyLarge(
                          //     'เลือกวันที่',
                          //     fontWeight: 700,
                          //   ),
                          // ),
                          // Padding(
                          //   padding: FxSpacing.horizontal(14),
                          //   child: SfDateRangePicker(
                          //       controller: _dateRangePickerController,
                          //       selectionMode:
                          //           DateRangePickerSelectionMode.range,
                          //       initialSelectedRange: PickerDateRange(
                          //         appController.fromDate,
                          //         appController.toDate,
                          //       )),
                          // ),
                          // FxSpacing.height(8),
                          Padding(
                            padding: FxSpacing.horizontal(14),
                            child: FxText.bodyLarge(
                              'สถานะงาน',
                              fontWeight: 700,
                            ),
                          ),
                          FxSpacing.height(8),
                          StatefulBuilder(builder: (context, setState) {
                            return GridView.count(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              primary: false,
                              childAspectRatio: 1,
                              shrinkWrap: true,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              crossAxisCount: 3,
                              children: _buildFilterCategoryList(setState),
                            );
                          }),
                          FxSpacing.height(16),
                          Padding(
                            padding: FxSpacing.horizontal(24),
                            child: FxButton.block(
                              borderRadiusAll: 8,
                              onPressed: () {
                                // appController.onSelectedDateRange(
                                //     _dateRangePickerController
                                //         .selectedRange!.startDate!,
                                //     _dateRangePickerController
                                //             .selectedRange!.endDate ??
                                //         _dateRangePickerController
                                //             .selectedRange!.startDate!);
                                controller.reloadAllJobs();
                                Navigator.pop(context);
                              },
                              backgroundColor: customTheme.estatePrimary,
                              child: FxText.titleSmall(
                                "Apply Filters",
                                fontWeight: 700,
                                color: customTheme.estateOnPrimary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          FxSpacing.height(16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _selectQuickAction() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: FxContainer.transparent(
                  height: 250,
                  color: Colors.blue.withOpacity(0.8),
                  padding: FxSpacing.top(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: ListView(
                          children: <Widget>[
                            FxSpacing.height(8),
                            StatefulBuilder(builder: (context, setState) {
                              return GridView.count(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                primary: false,
                                childAspectRatio: 1,
                                shrinkWrap: true,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                crossAxisCount: 3,
                                children: _buildQuickActionMenuList(setState),
                              );
                            }),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: theme.dividerColor,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.barcode,
                                  color: Colors.white),
                              FxContainer.transparent(
                                onTap: () async {
                                  var value =
                                      await FlutterBarcodeScanner.scanBarcode(
                                          "#ff6666",
                                          "Cancel",
                                          true,
                                          ScanMode.BARCODE);
                                  if (value != "-1") {
                                    var response = await controller
                                        .appController.api
                                        .updateJobStatusByBarCode(value);
                                    if (response != null) {
                                      if (response["isSuccess"]) {
                                        Navigator.of(context).pop();
                                        controller.reloadAllJobs(
                                            forceReload: true);
                                      } else {
                                        if (response["errorCode"] ==
                                            "JOB-0003") {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return _globalWidget
                                                    .errorYesNoDialog(context,
                                                        response["message"],
                                                        title2:
                                                            "ท่านต้องการเปลี่ยนสถานะรับงานแทนหรือไม่?",
                                                        acceptPressed:
                                                            () async {
                                                  var response = await controller
                                                      .appController.api
                                                      .updateJobStatusByBarCode(
                                                          value);
                                                  if (response != null) {
                                                    if (response["isSuccess"]) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      controller.reloadAllJobs(
                                                          forceReload: true);
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return _globalWidget
                                                                .errorDialog(
                                                                    context,
                                                                    response[
                                                                        "message"]);
                                                          });
                                                    }
                                                  }
                                                });
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return _globalWidget
                                                    .errorDialog(context,
                                                        response["message"]);
                                              });
                                        }
                                      }
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _globalWidget.errorDialog(
                                              context, "สแกนบาร์โค้ดไม่สำเร็จ ",
                                              title2: '$value');
                                        });
                                  }
                                },
                                child: Row(children: [
                                  FxText.titleLarge("สแกนรับงาน",
                                      color: Colors.white)
                                ]),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomeController>(
      controller: controller,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.isSearchMode) {
              _searchTextController.clear();
              FocusScope.of(context).unfocus();
              controller.reloadAllJobs();
            }
            return false;
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  height: 2,
                  child: controller.showLoading
                      ? LinearProgressIndicator(
                          color: customTheme.estatePrimary,
                          minHeight: 2,
                        )
                      : Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                ),
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget showPopup(HomeController controller) {
    // must use StateSetter to update data between main screen and popup.
    // if use default setState, the data will not update
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('รายการสายส่ง',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Flexible(
              child: ListView(
                padding: EdgeInsets.all(16),
                children:
                    List.generate(appController.routelines.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pop(context);
                          // controller.onSelectedRouteLine(
                          //     appController.routelines[index]);
                          setState(() {});
                        },
                        child: appController.routelines[index] ==
                                appController.selectedRouteLine
                            ? Row(
                                children: [
                                  Text(
                                      appController.routelines[index].routename,
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16)),
                                  Spacer(),
                                  Icon(FontAwesomeIcons.check,
                                      color: Colors.green)
                                  // FxText.labelMedium("เลือก",style: TextStyle(color: Colors.red),),
                                ],
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    appController.routelines[index].routename,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ),
                      ),
                      Divider(
                        height: 32,
                        color: Colors.grey[400],
                      ),
                      appController.routelines.length == index + 1
                          ? Container()
                          : SizedBox.shrink(),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}
