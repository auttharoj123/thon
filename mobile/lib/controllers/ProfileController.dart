import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/repositories/job_repostitory.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';

enum ShopStatus { close, open }

class ProfileController extends BaseController {
  late ShopStatus shopStatus;
  late GlobalWidget _globalWidget = GlobalWidget();

  ProfileController() {
    shopStatus = ShopStatus.open;
  }

  void changeShopStatus(ShopStatus shopStatus) {
    this.shopStatus = shopStatus;
    update();
  }

  void logout() async {
    var unsuccessCount = await JobRepository.countNonUpdatedJobNotSuccess();
    if (unsuccessCount > 0) {
      showDialog(
          context: context,
          builder: (context) => _globalWidget.errorDialog(context,
              "ท่านยังมีงานที่ยังไม่ได้อัพโหลด กรุณาอัพโหลดก่อนทำการออกจากระบบ"));
    } else {
      await appController.logout();
    }
    //Navigator.pushReplacementNamed(context, '/login');
    //Navigator.pop(context);
  }

  @override
  String getTag() {
    return "profile_controller";
  }
}
