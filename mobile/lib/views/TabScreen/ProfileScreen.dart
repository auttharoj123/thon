import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/ProfileController.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:slpod/theme/constant.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData theme;
  late ProfileController controller;
  late OutlineInputBorder outlineInputBorder;
  GlobalWidget _globalWidget = GlobalWidget();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(ProfileController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProfileController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context) + 16, 20, 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleRow(),
                    FxSpacing.height(20),
                    // statistics(),
                    // FxSpacing.height(24),
                    // status(),
                    // FxSpacing.height(24),
                    account(),
                    FxSpacing.height(32),
                    other(),
                    FxSpacing.height(32),
                    logout()
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget titleRow() {
    return Row(
      children: [
        Row(
          children: [
            Container(
              padding: FxSpacing.xy(0, 10),
              child: _globalWidget.menuButton(),
            ),
            FxSpacing.width(20),
            FxText.titleLarge("โปรไฟล์", color: Colors.black)
          ],
        ),
      ],
    );
  }

  Widget statistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: FxContainer(
              paddingAll: 12,
              child: Row(
                children: [
                  FxContainer(
                      paddingAll: 10,
                      color: Constant.softColors.green.color,
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Constant.softColors.green.onColor,
                      )),
                  FxSpacing.width(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodySmall(
                        'งานที่ส่งแล้ว',
                        fontWeight: 600,
                      ),
                      FxSpacing.height(4),
                      FxText.bodyMedium(
                        '114',
                        fontWeight: 600,
                      ),
                    ],
                  )
                ],
              ),
            )),
            FxSpacing.width(16),
            Expanded(
                child: FxContainer(
              paddingAll: 10,
              child: Row(
                children: [
                  FxContainer(
                      paddingAll: 10,
                      color: Constant.softColors.blue.color,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: Constant.softColors.blue.onColor,
                      )),
                  FxSpacing.width(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodySmall(
                        'งานที่รอการอัปโหลด',
                        fontWeight: 600,
                      ),
                      FxSpacing.height(4),
                      FxText.bodyMedium(
                        '284',
                        fontWeight: 600,
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
        FxSpacing.height(16),
        Row(
          children: [
            Expanded(
                child: FxContainer(
              paddingAll: 12,
              child: Row(
                children: [
                  FxContainer(
                      paddingAll: 10,
                      color: Constant.softColors.violet.color,
                      child: Icon(
                        FeatherIcons.users,
                        size: 18,
                        color: Constant.softColors.violet.onColor,
                      )),
                  FxSpacing.width(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxText.bodySmall(
                        'Users',
                        fontWeight: 600,
                      ),
                      FxSpacing.height(4),
                      FxText.bodyMedium(
                        '489',
                        fontWeight: 600,
                      ),
                    ],
                  )
                ],
              ),
            )),
            FxSpacing.width(16),
            Expanded(
                child: FxContainer(
              paddingAll: 10,
              child: Row(
                children: [
                  FxContainer(
                      paddingAll: 10,
                      color: Constant.softColors.pink.color,
                      child: Icon(
                        Icons.alt_route_outlined,
                        size: 18,
                        color: Constant.softColors.pink.onColor,
                      )),
                  FxSpacing.width(12),
                  Row(
                    children: [
                      FxText.bodySmall(
                        'View All',
                        fontWeight: 600,
                      ),
                      FxSpacing.width(4),
                      Icon(
                        FeatherIcons.chevronRight,
                        size: 16,
                      )
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }

  Widget status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          'Shop Status',
          fontWeight: 600,
          muted: true,
        ),
        FxSpacing.height(20),
        Row(
          children: [
            FxContainer(
              onTap: () {
                controller.changeShopStatus(ShopStatus.close);
              },
              color: controller.shopStatus == ShopStatus.close
                  ? theme.colorScheme.primaryContainer
                  : null,
              padding: FxSpacing.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Icon(Icons.work_off_outlined,
                      size: 20,
                      color: controller.shopStatus == ShopStatus.close
                          ? theme.colorScheme.onPrimaryContainer
                          : null),
                  FxSpacing.width(8),
                  FxText.bodySmall("Close",
                      color: controller.shopStatus == ShopStatus.close
                          ? theme.colorScheme.onPrimaryContainer
                          : null)
                ],
              ),
            ),
            FxSpacing.width(16),
            FxContainer(
              onTap: () {
                controller.changeShopStatus(ShopStatus.open);
              },
              color: controller.shopStatus == ShopStatus.open
                  ? theme.colorScheme.primaryContainer
                  : null,
              padding: FxSpacing.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Icon(Icons.work_outline,
                      size: 20,
                      color: controller.shopStatus == ShopStatus.open
                          ? theme.colorScheme.onPrimaryContainer
                          : null),
                  FxSpacing.width(8),
                  FxText.bodySmall("Open",
                      color: controller.shopStatus == ShopStatus.open
                          ? theme.colorScheme.onPrimaryContainer
                          : null)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget account() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          child: CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/profile/avatar_place.png'),
          ),
        ),
        FxSpacing.width(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText("${controller.appController.loginName}"),
            FxText(
                "${controller.appController.fName} ${controller.appController.lName}")
          ],
        )
      ],
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     FxText.bodySmall(
    //       'My Account',
    //       fontWeight: 600,
    //       muted: true,
    //     ),
    //     FxSpacing.height(20),
    //     Row(
    //       children: [
    //         FxContainer(
    //           paddingAll: 8,
    //           color: Constant.softColors.blue.color,
    //           child: Icon(
    //             Icons.person,
    //             size: 20,
    //             color: Constant.softColors.blue.onColor,
    //           ),
    //         ),
    //         FxSpacing.width(16),
    //         Expanded(child: FxText.bodyMedium('Login Name')),
    //         FxSpacing.width(16),
    //         FxText.bodyLarge(
    //           "",
    //           color: Colors.grey,
    //         )
    //       ],
    //     ),
    //     FxSpacing.height(20),
    //     Row(
    //       children: [
    //         FxContainer(
    //           paddingAll: 8,
    //           color: Constant.softColors.blue.color,
    //           child: Icon(
    //             Icons.person,
    //             size: 20,
    //             color: Constant.softColors.blue.onColor,
    //           ),
    //         ),
    //         FxSpacing.width(16),
    //         Expanded(child: FxText.bodyMedium('ชื่อ')),
    //         FxSpacing.width(16),
    //         FxText.bodyLarge(
    //           "",
    //           color: Colors.grey,
    //         )
    //       ],
    //     ),
    //     FxSpacing.height(20),
    //     Row(
    //       children: [
    //         FxContainer(
    //           paddingAll: 8,
    //           color: Constant.softColors.blue.color,
    //           child: Icon(
    //             Icons.person,
    //             size: 20,
    //             color: Constant.softColors.blue.onColor,
    //           ),
    //         ),
    //         FxSpacing.width(16),
    //         Expanded(child: FxText.bodyMedium('นามสกุล')),
    //         FxSpacing.width(16),
    //         FxText.bodyLarge(
    //           "",
    //           color: Colors.grey,
    //         )
    //       ],
    //     ),
    // FxSpacing.height(16),
    // Row(
    //   children: [
    //     FxContainer(
    //       paddingAll: 8,
    //       color: Constant.softColors.green.color,
    //       child: Icon(
    //         Icons.location_on_outlined,
    //         size: 20,
    //         color: Constant.softColors.green.onColor,
    //       ),
    //     ),
    //     FxSpacing.width(16),
    //     Expanded(child: FxText.bodyMedium('Shop Location')),
    //     FxSpacing.width(16),
    //     Icon(
    //       FeatherIcons.chevronRight,
    //       size: 20,
    //     )
    //   ],
    // ),
    // FxSpacing.height(16),
    // Row(
    //   children: [
    //     FxContainer(
    //       paddingAll: 8,
    //       color: Constant.softColors.orange.color,
    //       child: Icon(
    //         Icons.privacy_tip_outlined,
    //         size: 20,
    //         color: Constant.softColors.orange.onColor,
    //       ),
    //     ),
    //     FxSpacing.width(16),
    //     Expanded(child: FxText.bodyMedium('Privacy')),
    //     FxSpacing.width(16),
    //     Row(
    //       children: [
    //         FxText.bodySmall(
    //           'Action Needed',
    //           color: theme.colorScheme.error,
    //           fontWeight: 600,
    //         ),
    //         FxSpacing.width(4),
    //         Icon(
    //           FeatherIcons.chevronRight,
    //           size: 18,
    //           color: theme.colorScheme.error,
    //         )
    //       ],
    //     )
    //   ],
    // ),
    //   ],
    // );
  }

  Widget other() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          'Settings',
          fontWeight: 600,
          muted: true,
        ),
        FxSpacing.height(20),
        Row(
          children: [
            FxContainer(
              paddingAll: 8,
              color: Constant.softColors.blue.color,
              child: Icon(
                Icons.settings,
                size: 20,
                color: Constant.softColors.blue.onColor,
              ),
            ),
            FxSpacing.width(16),
            Expanded(child: FxText.bodyMedium('Version')),
            FxSpacing.width(16),
            FxText.bodyLarge(
              SLAppl.VERSION,
              color: Colors.grey,
            )
          ],
        ),
        // FxSpacing.height(16),
        // Row(
        //   children: [
        //     FxContainer(
        //       paddingAll: 8,
        //       color: Constant.softColors.green.color,
        //       child: Icon(
        //         Icons.location_on_outlined,
        //         size: 20,
        //         color: Constant.softColors.green.onColor,
        //       ),
        //     ),
        //     FxSpacing.width(16),
        //     Expanded(child: FxText.bodyMedium('Shop Location')),
        //     FxSpacing.width(16),
        //     Icon(
        //       FeatherIcons.chevronRight,
        //       size: 20,
        //     )
        //   ],
        // ),
        // FxSpacing.height(16),
        // Row(
        //   children: [
        //     FxContainer(
        //       paddingAll: 8,
        //       color: Constant.softColors.orange.color,
        //       child: Icon(
        //         Icons.privacy_tip_outlined,
        //         size: 20,
        //         color: Constant.softColors.orange.onColor,
        //       ),
        //     ),
        //     FxSpacing.width(16),
        //     Expanded(child: FxText.bodyMedium('Privacy')),
        //     FxSpacing.width(16),
        //     Row(
        //       children: [
        //         FxText.bodySmall(
        //           'Action Needed',
        //           color: theme.colorScheme.error,
        //           fontWeight: 600,
        //         ),
        //         FxSpacing.width(4),
        //         Icon(
        //           FeatherIcons.chevronRight,
        //           size: 18,
        //           color: theme.colorScheme.error,
        //         )
        //       ],
        //     )
        //   ],
        // ),
      ],
    );
  }

  Widget logout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FxText.bodySmall(
        //   'My Account',
        //   fontWeight: 600,
        //   xMuted: true,
        // ),
        // FxSpacing.height(8),
        // FxButton.text(
        //     padding: FxSpacing.zero,
        //     onPressed: () {},
        //     child: FxText.bodyMedium(
        //       'Switch to another account',
        //       color: theme.colorScheme.primary,
        //       fontWeight: 600,
        //     )),
        // FxSpacing.height(20),
        Center(
          child: FxButton(
              backgroundColor: theme.colorScheme.errorContainer,
              elevation: 0,
              borderRadiusAll: Constant.buttonRadius.small,
              onPressed: () {
                controller.logout();
              },
              child: FxText(
                'Logout',
                color: theme.colorScheme.onErrorContainer,
                fontWeight: 600,
              )),
        )
      ],
    );
  }
}
