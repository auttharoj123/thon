import 'package:flutter/cupertino.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/controllers/BaseController.dart';

enum ShopStatus { close, open }

class ProfileController extends BaseController {
  late ShopStatus shopStatus;

  ProfileController() {
    shopStatus = ShopStatus.open;
  }

  void changeShopStatus(ShopStatus shopStatus) {
    this.shopStatus = shopStatus;
    update();
  }

  void logout() async {
    await appController.logout();
    Navigator.pushReplacementNamed(context, '/');
    //Navigator.pop(context);
  }

  @override
  String getTag() {
    return "profile_controller";
  }
}
