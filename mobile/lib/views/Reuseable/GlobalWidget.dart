import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:slpod/controllers/TabMainController.dart';

import '../../constants/SLConsts.dart';

class GlobalWidget {
  Widget menuButton() {
    return FxContainer.transparent(
      onTap: () {
        var controller = FxControllerStore.putOrFind(TabMainController(),
            tag: 'tab_main_controller');
        controller.handleToggleMenu();
      },
      color: Colors.blue.shade700,
      marginAll: 0,
      paddingAll: 10,
      child: Icon(Icons.dashboard, color: Colors.white),
    );
  }

  Widget satisfactionView(controller) {
    void _satisfactionSelected(int point) {
      controller.point = point;
      controller.update();
    }

    return FxContainer.transparent(
        paddingAll: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     FxText.bodyLarge("คะแนนความพึงพอใจ",
            //         fontSize: 21, fontWeight: 700),
            //   ],
            // ),
            FxSpacing.height(20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    FxContainer.transparent(
                      paddingAll: 0,
                      onTap: () {
                        _satisfactionSelected(5);
                      },
                      child: Icon(Icons.emoji_emotions_outlined,
                          color: (controller.point == 5)
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
                        _satisfactionSelected(4);
                      },
                      child: Icon(Icons.sentiment_satisfied_alt,
                          color: (controller.point == 4)
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
                        _satisfactionSelected(3);
                      },
                      child: Icon(Icons.sentiment_neutral,
                          color: (controller.point == 3)
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
                        _satisfactionSelected(2);
                      },
                      paddingAll: 0,
                      child: Icon(Icons.sentiment_dissatisfied_outlined,
                          color: (controller.point == 2)
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
                        _satisfactionSelected(1);
                      },
                      paddingAll: 0,
                      child: Icon(Icons.sentiment_very_dissatisfied_outlined,
                          color: (controller.point == 1)
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
        ));
  }

  Widget errorYesNoDialog(context, title,
      {title2 = "", void Function()? acceptPressed}) {
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
                    FontAwesomeIcons.circleXmark,
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
                          TextSpan(text: title),
                          TextSpan(
                              text: title2,
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
                        },
                        child: FxText.bodyMedium("ตกลง",
                            letterSpacing: 0.4, color: Colors.white)),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget showLoading() {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Column(
            children: [
              Lottie.asset("assets/animations/lottie/loading.json"),
              FxText("กำลังบันทึกข้อมูล...", color: Colors.white,)
            ],
          )
        ),
      ),
    );
  }

  Widget errorDialog(context, title, {title2 = ""}) {
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
                    FontAwesomeIcons.circleXmark,
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
                          TextSpan(text: title),
                          TextSpan(
                              text: title2,
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
                    FxButton(
                        backgroundColor: SLColor.LIGHTBLUE2,
                        borderRadiusAll: 4,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: FxText.bodyMedium("ตกลง",
                            letterSpacing: 0.4, color: Colors.white)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
