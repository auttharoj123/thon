import 'package:date_format/date_format.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:slpod/components/expansion_tile_partial.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import 'package:slpod/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/SLState.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import "package:slpod/extensions/jobdetail_extension.dart";

import 'package:timezone/data/latest.dart' as tz;
// import 'single_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../controllers/HomeController.dart';
import '../../loading_effect.dart';

// import 'models/category.dart';
// import 'models/doctor.dart';

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
  late TextEditingController _customerSearchController;
  late SuggestionsBoxController _suggestBoxController;
  late DateRangePickerController _dateRangePickerController;
  late AnimationController _appBarAnimationController;
  late Animation<double> _appBarAnimation;
  // dynamic color;

  @override
  void initState() {
    super.initState();
    _setupAnimateAppbar();
    tz.initializeTimeZones();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    controller = FxControllerStore.putOrFind(HomeController());
    _dateRangePickerController = DateRangePickerController();
    _searchTextController = TextEditingController();
    _customerSearchController = TextEditingController();
    _suggestBoxController = SuggestionsBoxController();
    _scrollController = ScrollController();
  }

  void _setupAnimateAppbar() {
    // use this function and paramater to animate top bar
    _appBarAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _appBarAnimation = Tween<double>(
      begin: 0.0,
      end: 130.0,
    ).animate(_appBarAnimationController);
  }

  // Widget _buildSingleCategory(
  //     {int? index,
  //     String? categoryName,
  //     IconData? categoryIcon,
  //     Color? color}) {
  //   return Padding(
  //     padding: FxSpacing.right(16),
  //     child: FxContainer(
  //       paddingAll: 8,
  //       borderRadiusAll: 8,
  //       bordered: true,
  //       border: Border.all(color: customTheme.border, width: 1),
  //       color: selectedCategory == index
  //           ? customTheme.card
  //           : theme.scaffoldBackgroundColor,
  //       onTap: () {
  //         setState(() {
  //           selectedCategory = index!;
  //         });
  //       },
  //       child: Row(
  //         children: [
  //           FxContainer.rounded(
  //             child: FaIcon(
  //               categoryIcon,
  //               color: Colors.white, //customTheme.medicarePrimary,
  //               size: 18,
  //             ),
  //             color: color, //theme.colorScheme.onBackground.withAlpha(16),
  //             paddingAll: 10,
  //           ),
  //           FxSpacing.width(8),
  //           FxText.labelMedium(
  //             categoryName!,
  //             fontWeight: 600,
  //           ),
  //           FxSpacing.width(8),
  //           FxText.labelMedium(
  //             "(200)",
  //             fontWeight: 600,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // List<Widget> _buildCategoryList() {
  //   List<Widget> list = [];

  //   list.add(FxSpacing.width(24));

  //   for (int i = 0; i < controller.categoryList.length; i++) {
  //     list.add(_buildSingleCategory(
  //         index: i,
  //         categoryName: controller.categoryList[i].category,
  //         categoryIcon: controller.categoryList[i].categoryIcon,
  //         color: controller.categoryList[i].color));
  //   }
  //   return list;
  // }

  // List<Widget> _buildJobList() {
  //   List<Widget> list = [];

  //   list.add(FxSpacing.width(16));

  //   for (int i = 0; i < controller.jobs.length; i++) {
  //     list.add(_buildJobListItem(controller.jobs[i]));
  //     list.add(FxSpacing.height(10));
  //   }
  //   return list;
  // }

  Widget _buildJobDetailWrapperItem(JobDetail job) {
    var titleFontSize = 18.0;
    // if (isGroupType) {
    //   return FxContainer.transparent(
    //     padding: FxSpacing.only(left: 10, right: 10),
    //     onTap: () {
    //       _searchTextController.text = job.barcode;
    //       _appBarAnimationController.animateTo(0,
    //           duration: Duration(milliseconds: 300), curve: Curves.ease);
    //       _scrollController.animateTo(0,
    //           duration: Duration(milliseconds: 300), curve: Curves.ease);
    //       controller.searchJobs(job.barcode);
    //     },
    //     bordered: false,
    //     borderRadiusAll: 0,
    //     child: FxContainer.bordered(
    //       borderRadiusAll: 20,
    //       color: Colors.white,
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         FxContainer(
    //                           color: Colors.blue.shade50,
    //                           child: Icon(
    //                             FontAwesomeIcons.barcode,
    //                             color: Colors.blue,
    //                             size: 15,
    //                           ),
    //                         ),
    //                         FxSpacing.width(20),
    //                         FxText.titleLarge(
    //                           "${job.barcode}",
    //                           fontWeight: 600,
    //                           // color: Colors.blue,
    //                         ),
    //                       ],
    //                     ),
    //                     Stack(
    //                       children: [
    //                         // Transform.translate(
    //                         //   offset: Offset(0, 5),
    //                         //   child:
    //                         // ),
    //                         Transform.translate(
    //                           offset: Offset(0, 0),
    //                           child: FxContainer(
    //                               child: FxText.titleSmall(
    //                                   controller
    //                                       .getOrderStatusTitle(job.orderStatus),
    //                                   fontWeight: 600,
    //                                   color: Colors.white),
    //                               paddingAll: 8,
    //                               color: controller
    //                                   .getOrderStatusColor(job.orderStatus)),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //                 FxSpacing.height(20),
    //                 Container(
    //                   child: Row(
    //                     children: [
    //                       // FxSpacing.width(1),
    //                       Icon(
    //                         FontAwesomeIcons.calendar,
    //                         color: Colors.blue,
    //                         size: 20,
    //                       ),
    //                       FxSpacing.width(10),
    //                       FxText(
    //                         "${formatDate(job.deliveryDateEx, [
    //                               dd,
    //                               '/',
    //                               mm,
    //                               '/',
    //                               yyyy,
    //                               ' ',
    //                               HH,
    //                               ':',
    //                               nn
    //                             ])}",
    //                         fontWeight: 600,
    //                         fontSize: titleFontSize,
    //                         color: Colors.grey,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 FxSpacing.height(20),
    //                 (job.remark.isNotEmpty)
    //                     ? FxContainer(
    //                         color: Colors.red.shade100,
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.stretch,
    //                           children: [
    //                             FxText(
    //                               "หมายเหตุ : ",
    //                               xMuted: false,
    //                               fontSize: titleFontSize,
    //                               color: Colors.red,
    //                             ),
    //                             FxSpacing.width(2),
    //                             FxText(
    //                               job.remark,
    //                               xMuted: false,
    //                               color: Colors.red,
    //                               fontSize: titleFontSize,
    //                               maxLines: 5,
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                           ],
    //                         ),
    //                       )
    //                     : Container()
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    return FxContainer.transparent(
      padding: FxSpacing.only(left: 10, right: 10),
      bordered: false,
      borderRadiusAll: 0,
      child: FxContainer.bordered(
        onTap: () {
          if (controller.toggleSendJobButton) {
            if (!job.isChecked) {
              job.isChecked = true;
              controller.selectedJobIds.add(job);
            } else {
              job.isChecked = false;
              controller.selectedJobIds.remove(job);
            }
            setState(() {});
          }
          // else {
          //   controller.goToJobDetailPage(job);
          // }
        },
        borderRadiusAll: 20,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTileNew(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            (controller.toggleSendJobButton)
                                ? Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: job.isChecked
                                              ? Icon(
                                                  Icons.check,
                                                  size: 20.0,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  size: 20.0,
                                                  color: Colors.blue,
                                                ),
                                        ),
                                      ),
                                      FxSpacing.width(10),
                                    ],
                                  )
                                : Container(),
                            // Icon(
                            //   Icons.list_alt,
                            //   color: Colors.blue,
                            //   size: 20,
                            // ),
                            FxSpacing.width(10),
                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            FxText.titleLarge(
                                              "${job.barcode}",
                                              fontWeight: 600,
                                              // color: Colors.blue,
                                            ),
                                            // FxSpacing.width(10),
                                            // (job.remark.isNotEmpty)
                                            //     ? FxContainer.roundBordered(
                                            //         paddingAll: 0,
                                            //         color: Colors.red,
                                            //         child: Row(
                                            //           children: [
                                            //             Icon(
                                            //               FontAwesomeIcons
                                            //                   .exclamation,
                                            //               color: Colors.white,
                                            //               size: 15,
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            //     : Container(),
                                          ],
                                        ),
                                        FxText(
                                          job.jobNumber,
                                          xMuted: true,
                                          fontSize: titleFontSize,
                                        ),
                                      ],
                                    ),
                                    FxContainer(
                                        child: FxText.titleSmall(
                                            controller.getOrderStatusTitle(
                                                job.orderStatus),
                                            fontWeight: 600,
                                            color: Colors.white),
                                        paddingAll: 8,
                                        color: controller.getOrderStatusColor(
                                            job.orderStatus)),
                                  ],
                                ),
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
                                  ),
                                ],
                              ),
                            ),
                            FxContainer.transparent(
                              onTap: () {
                                controller.goToJobDetailPage(job);
                              },
                              paddingAll: 0,
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.eye,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  FxSpacing.width(10),
                                  FxText(
                                    "View",
                                    fontWeight: 600,
                                    fontSize: titleFontSize,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.all(10),
                    children: [
                      (job.reference3.isNotEmpty)
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText(
                                  "อ้างอิง3 : ",
                                  fontSize: titleFontSize,
                                  xMuted: false,
                                ),
                                FxSpacing.width(2),
                                Flexible(
                                  child: FxText(
                                    job.reference3,
                                    xMuted: true,
                                    maxLines: 2,
                                    fontSize: titleFontSize,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          FxText(
                            "วันที่บิล : ",
                            fontSize: titleFontSize,
                            xMuted: false,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            "${formatDate(job.receiveDateEx, [
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
                            xMuted: true,
                            fontSize: titleFontSize,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FxText(
                            "วันที่ใบคุม : ",
                            fontSize: titleFontSize,
                            xMuted: false,
                          ),
                          FxSpacing.width(2),
                          FxText.titleMedium(
                            "${formatDate(job.deliveryDocumentDateEx, [
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
                            xMuted: true,
                            fontSize: titleFontSize,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FxText(
                            "วันที่สร้าง : ",
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            "${formatDate(job.createdDateFromServerEx, [
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
                            xMuted: true,
                            fontSize: titleFontSize,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FxText(
                            "จำนวนสินค้า : ",
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            job.qty.toString(),
                            xMuted: true,
                            fontSize: titleFontSize,
                          ),
                        ],
                      ),
                      FxSpacing.height(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FxText(
                            "ลูกค้า : ",
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            job.customerName,
                            xMuted: true,
                            maxLines: 2,
                            fontSize: titleFontSize,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      FxSpacing.height(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FxText(
                            "รายละเอียดสินค้า : ",
                            textAlign: TextAlign.start,
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          // FxSpacing.width(2),
                          FxText(
                            (job.goodsDetails.isNotEmpty)
                                ? job.goodsDetails
                                : 'ไม่มี',
                            xMuted: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            fontSize: titleFontSize,
                          ),
                        ],
                      ),
                      FxSpacing.height(10),
                      // FxDashedDivider(),
                      // FxSpacing.height(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FxText(
                            "ชื่อผู้รับ : ",
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            job.receiverName,
                            xMuted: true,
                            fontSize: titleFontSize,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      FxSpacing.height(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FxText(
                            "ที่อยู่ผู้รับ : ",
                            xMuted: false,
                            fontSize: titleFontSize,
                          ),
                          FxSpacing.width(2),
                          FxText(
                            job.receiverFullAddress,
                            xMuted: true,
                            maxLines: 10,
                            fontSize: titleFontSize,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      FxSpacing.height(10),
                      (job.remark.isNotEmpty)
                          ? FxContainer(
                              color: Colors.red.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCustomerList(JobDetail item) {
  //   //var titleFontSize = 18.0;
  //   // return StickyHeader(
  //   //     header: FxText.titleLarge(wrapper.title),
  //   //     content: Container(child: FxText("Test")));

  //   return FxContainer.transparent(
  //       padding: FxSpacing.only(left: 10, right: 10),
  //       onTap: () {
  //         // if (controller.toggleSendJobButton) {
  //         //   if (!job.isChecked) {
  //         //     job.isChecked = true;
  //         //     controller.selectedJobIds.add(job);
  //         //   } else {
  //         //     job.isChecked = false;
  //         //     controller.selectedJobIds.remove(job);
  //         //   }
  //         //   setState(() {});
  //         // } else {
  //         //   controller.goToJobDetailPage(job);
  //         // }
  //       },
  //       bordered: false,
  //       borderRadiusAll: 0,
  //       child: FxContainer.bordered(
  //         borderRadiusAll: 20,
  //         color: Colors.white,
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ExpansionTile(
  //                     title: FxText.titleMedium(
  //                       "${wrapper.title}",
  //                       fontWeight: 600,
  //                       // color: Colors.blue,
  //                     ),
  //                     children: [
  //                       Container(
  //                         child: ListView.builder(
  //                             itemCount: wrapper.items.length,
  //                             itemBuilder: (context, index) {
  //                               return Container(
  //                                 child: FxText.titleMedium(
  //                                     wrapper.items[index].barcode),
  //                               );
  //                             }),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  Widget _buildJobList() {
    // var jobs = controller.filteredJobs;
    // if (controller.isSearchMode) {
    //   if (controller.selectedJobType == SendJobTypes.customer) {
    //     var jobs = controller.filteredJobs
    //         .toJobDetailWrapper(JobDetailGroupBy.customer);
    //     return ListView.builder(
    //         controller: _scrollController,
    //         padding: FxSpacing.top(295),
    //         itemCount: controller.jobs.length,
    //         itemBuilder: (context, index) {
    //           return Column(
    //             children: [
    //               _buildCustomerList(jobs[index]),
    //               FxSpacing.height(10)
    //             ],
    //           );
    //         });
    //   } else if (controller.selectedJobType == SendJobTypes.receiver) {
    //     var jobs = controller.filteredJobs
    //         .toJobDetailWrapper(JobDetailGroupBy.receiver);
    //   } else if (controller.selectedJobType == SendJobTypes.group_barcode) {
    //     var jobs = controller.filteredJobs
    //         .toJobDetailWrapper(JobDetailGroupBy.barcode);
    //   }
    // }
    if (controller.selectedJobType == SendJobTypes.customer ||
        controller.selectedJobType == SendJobTypes.receiver) {
      return ListView.builder(
          controller: _scrollController,
          padding: FxSpacing.top(260),
          itemCount: controller.filteredJobs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildJobDetailWrapperItem(controller.filteredJobs[index]),
                FxSpacing.height(10)
              ],
            );
          });
    } else if (controller.selectedJobType == SendJobTypes.group_barcode) {
      return GroupedListView<JobDetail, String>(
        padding: FxSpacing.top(260),
        controller: _scrollController,
        elements: controller.filteredJobs,
        groupBy: (element) => element.barcode,
        groupSeparatorBuilder: (String groupByValue) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FxContainer(
                color: SLColor.LIGHTBLUE2,
                child: FxText('# $groupByValue',
                    color: Colors.white, fontSize: 21),
              ),
              FxSpacing.height(20)
            ],
          );
        },
        itemBuilder: (context, element) {
          return Column(
            children: [
              _buildJobDetailWrapperItem(element),
              FxSpacing.height(20)
            ],
          );
        },
        // itemComparator: (item1, item2) =>
        //     item1['name'].compareTo(item2['name']), // optional
        useStickyGroupSeparators: false, // optional
        floatingHeader: true, // optional
        order: GroupedListOrder.ASC, // optional
      );
    }
    return ListView.builder(
        controller: _scrollController,
        padding: FxSpacing.top(260),
        itemCount: controller.filteredJobs.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildJobDetailWrapperItem(controller.filteredJobs[index]),
              FxSpacing.height(10)
            ],
          );
        });
    // if (controller.toggleSendJobButton) {
    //   var jobs = controller.jobs.toJobDetailList();
    //   return ListView.builder(
    //       controller: _scrollController,
    //       padding: FxSpacing.top(295),
    //       itemCount: controller.jobs.length,
    //       itemBuilder: (context, index) {
    //         return Column(
    //           children: [
    //             _buildJobDetailWrapperItem(jobs[index], false),
    //             FxSpacing.height(10)
    //           ],
    //         );
    //       });
    // }

    // return ListView.builder(
    //     controller: _scrollController,
    //     padding: FxSpacing.top(295),
    //     itemCount: controller.jobs.length,
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: [
    //           _buildJobDetailWrapperItem(controller.jobs[index].items[0],
    //               controller.jobs[index].items.length > 1),
    //           FxSpacing.height(10)
    //         ],
    //       );
    //     });
  }

  Widget _buildBody() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((_scrollController.hasClients)) {
        _scrollController.addListener(() {
          _appBarAnimationController.animateTo(_scrollController.offset / 130);
        });
        _scrollController.position.isScrollingNotifier.addListener(() {
          if (!_scrollController.position.isScrollingNotifier.value) {
            if (_scrollController.offset > 30 &&
                _scrollController.offset < 130) {
              _appBarAnimationController.animateTo(1,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
              _scrollController.animateTo(130,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            } else {
              if (_scrollController.offset < 30) {
                _appBarAnimationController.animateTo(0,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              }
            }
          } else {
            print('scroll is started');
          }
        });
      }
    });

    return Stack(children: [
      (controller.showLoading)
          ? SingleChildScrollView(
              padding: FxSpacing.top(290),
              child: LoadingEffect.getSearchLoadingScreen(
                context,
              ))
          : Container(color: Colors.grey.shade100, child: _buildJobList()),
      AnimatedBuilder(
          animation: _appBarAnimationController,
          builder: (context, child) {
            return Column(
              children: [
                Container(
                  color: Colors.grey.shade100,
                  padding: FxSpacing.only(
                      top: 220 - _appBarAnimation.value,
                      left: 20,
                      right: 20,
                      bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FxText(
                        'งานทั้งหมด (${controller.filteredJobs.length})',
                        fontWeight: 700,
                        fontSize: 16,
                      ),
                      (controller.toggleSendJobButton)
                          ? FxContainer.bordered(
                              color: Colors.green.shade100,
                              paddingAll: 4,
                              child: FxText(
                                'งานที่เลือก ${controller.selectedJobIds.length} งาน',
                                fontWeight: 700,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            );
          }),
      Container(
        child: AnimatedBuilder(
          animation: _appBarAnimationController,
          builder: (context, child) {
            return FxContainer(
                padding: FxSpacing.all(10),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: SLColor.LIGHTBLUE2,
                child: _appBar(),
                height: 210 - _appBarAnimation.value);
          },
        ),
      )
    ]);
  }

  Widget _buildSearchWidget() {
    if (controller.selectedJobType == SendJobTypes.group_barcode) {
      var jobs = controller.jobs.toJobDetailWrapper(JobDetailGroupBy.barcode);
      return Card(
        margin: FxSpacing.zero,
        child: TypeAheadField(
          suggestionsBoxController: _suggestBoxController,
          hideOnEmpty: true,
          keepSuggestionsOnSuggestionSelected: true,
          hideKeyboard: true,
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(fontFamily: 'Kanit'),
            controller: _customerSearchController,
            decoration: InputDecoration(
                contentPadding: FxSpacing.only(left: 20),
                labelStyle: TextStyle(fontFamily: 'Kanit'),
                hintStyle: TextStyle(fontFamily: 'Kanit'),
                counterStyle: TextStyle(fontFamily: 'Kanit'),
                suffixIcon: FxContainer.transparent(
                  padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
                  onTap: () async {
                    controller.selectedJobIds = [];
                    _suggestBoxController.close();
                  },
                  child: Icon(FontAwesomeIcons.xmark,
                      color: customTheme.medicarePrimary, size: 20),
                ),
                border: OutlineInputBorder(),
                hintText: 'ค้นหาบาร์โค้ด'),
          ),
          suggestionsCallback: (pattern) {
            return jobs.where((data) =>
                data.title.toLowerCase().contains(pattern.toLowerCase()));
          },
          noItemsFoundBuilder: (context) {
            return Container(
                color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
          },
          itemBuilder: (context, JobDetailWrapper suggestion) {
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                        title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: suggestion.isChecked,
                              onChanged: (value) {},
                            ),
                            FxText('# ${suggestion.title}',
                                fontSize: 21, color: Colors.blue),
                          ],
                        ),
                        FxText(suggestion.items[0].receiverAddress,
                            fontSize: 18, muted: true)
                      ],
                    )),
                    Divider(height: 2)
                  ],
                ),
              );
            });
          },
          onSuggestionSelected: (JobDetailWrapper suggestion) {
            if (!controller.selectedGroupBarcode.contains(suggestion)) {
              controller.selectedGroupBarcode.add(suggestion);
            } else {
              controller.selectedGroupBarcode.remove(suggestion);
            }

            controller.filteredJobs = controller.jobs.where((element) {
              var foundItem = controller.selectedGroupBarcode
                  .where((element2) => element.barcode == element2.title);
              return foundItem.length > 0;
            }).toList();

            setState(() {
              suggestion.isChecked = suggestion.isChecked;
            });
          },
        ),
      );
    } else if (controller.selectedJobType == SendJobTypes.customer) {
      var customers =
          controller.jobs.toJobDetailWrapper(JobDetailGroupBy.customer);
      return Card(
        margin: FxSpacing.zero,
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(fontFamily: 'Kanit'),
            controller: _customerSearchController,
            decoration: InputDecoration(
                contentPadding: FxSpacing.only(left: 20),
                labelStyle: TextStyle(fontFamily: 'Kanit'),
                hintStyle: TextStyle(fontFamily: 'Kanit'),
                counterStyle: TextStyle(fontFamily: 'Kanit'),
                suffixIcon: FxContainer.transparent(
                  padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
                  onTap: () async {
                    _customerSearchController.clear();
                    controller.selectedJobIds = [];
                    controller.searchJobs("",controller.selectedJobStatus);
                  },
                  child: Icon(FontAwesomeIcons.xmark,
                      color: customTheme.medicarePrimary, size: 20),
                ),
                border: OutlineInputBorder(),
                hintText: 'ค้นหาลูกค้า'),
          ),
          suggestionsCallback: (pattern) {
            return customers.where((data) =>
                data.title.toLowerCase().contains(pattern.toLowerCase()));
          },
          noItemsFoundBuilder: (context) {
            return Container(
                color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
          },
          itemBuilder: (context, JobDetailWrapper suggestion) {
            return Container(
              color: Colors.white,
              child: ListTile(title: FxText(suggestion.title)),
            );
          },
          onSuggestionSelected: (JobDetailWrapper suggestion) {
            _customerSearchController.text = suggestion.title;
            controller.searchJobs(_customerSearchController.text,controller.selectedJobStatus);
          },
        ),
      );
    } else if (controller.selectedJobType == SendJobTypes.receiver) {
      var receivers =
          controller.jobs.toJobDetailWrapper(JobDetailGroupBy.receiver);
      return Card(
        margin: FxSpacing.zero,
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(fontFamily: 'Kanit'),
            controller: _customerSearchController,
            decoration: InputDecoration(
                contentPadding: FxSpacing.only(left: 20),
                labelStyle: TextStyle(fontFamily: 'Kanit'),
                hintStyle: TextStyle(fontFamily: 'Kanit'),
                counterStyle: TextStyle(fontFamily: 'Kanit'),
                suffixIcon: FxContainer.transparent(
                  padding: FxSpacing.symmetric(vertical: 10, horizontal: 5),
                  onTap: () async {
                    _customerSearchController.clear();
                    controller.selectedJobIds = [];
                    controller.searchJobs("",controller.selectedJobStatus);
                  },
                  child: Icon(FontAwesomeIcons.xmark,
                      color: customTheme.medicarePrimary, size: 20),
                ),
                border: OutlineInputBorder(),
                hintText: 'ค้นหาลูกค้าปลายทาง'),
          ),
          suggestionsCallback: (pattern) {
            return receivers.where((data) =>
                data.title.toLowerCase().contains(pattern.toLowerCase()));
          },
          noItemsFoundBuilder: (context) {
            return Container(
                color: Colors.white, child: FxText("ไม่พบรายชื่อลูกค้า"));
          },
          itemBuilder: (context, JobDetailWrapper suggestion) {
            return Container(
              color: Colors.white,
              child: ListTile(title: FxText(suggestion.title)),
            );
          },
          onSuggestionSelected: (JobDetailWrapper suggestion) {
            _customerSearchController.text = suggestion.title;
            controller.searchJobs(_customerSearchController.text,controller.selectedJobStatus);
          },
        ),
      );
    }
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
        controller.searchJobs(value,controller.selectedJobStatus);
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
                    controller.searchJobs(_searchTextController.text,controller.selectedJobStatus);
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
                controller.searchJobs(_searchTextController.text,controller.selectedJobStatus);
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

  Widget _appBar() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _appBarAnimationController,
          builder: (context, child) {
            return SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              // padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  // FxSpacing.height(20),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return showPopup(controller);
                              //return Container();
                            },
                          );
                        },
                        child: Opacity(
                          opacity: 1.0 - _appBarAnimation.value / 130,
                          child: Container(
                            // margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FxText.bodySmall(
                                  'สายส่ง',
                                  color: Colors.white,
                                  xMuted: false,
                                  fontSize: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_shipping,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                    FxSpacing.width(4),
                                    FxText.bodySmall(
                                      (appController.selectedRouteLine != null)
                                          ? appController
                                              .selectedRouteLine!.routename
                                          : "",
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: 600,
                                    ),
                                    FxSpacing.width(4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 1.0 - _appBarAnimation.value / 130,
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                              padding: FxSpacing.horizontal(10),
                              child: _buildSearchWidget()),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -_appBarAnimation.value),
                        child: Container(
                          padding: FxSpacing.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxContainer.transparent(
                                child: Column(children: [
                                  Icon(Icons.qr_code_scanner,
                                      color: Colors.white, size: 40),
                                  FxText.titleSmall(
                                    "สแกนรับงาน",
                                    color: Colors.white,
                                  )
                                ]),
                              ),
                              FxContainer.transparent(
                                onTap: () {
                                  _searchTextController.text = "";
                                  resetAppBar();
                                  controller.reloadAllJobs(forceReload: true);
                                },
                                child: Column(children: [
                                  Icon(Icons.sync,
                                      color: Colors.white, size: 40),
                                  FxText.titleSmall(
                                    "โหลดงาน",
                                    color: Colors.white,
                                  )
                                ]),
                              ),
                              FxContainer.transparent(
                                onTap: () {
                                  _selectSizeSheet();
                                },
                                child: Column(children: [
                                  Icon(Icons.tune,
                                      color: Colors.white, size: 40),
                                  FxText.titleSmall(
                                    "Filters",
                                    color: Colors.white,
                                  )
                                ]),
                              ),
                              AbsorbPointer(
                                absorbing: (controller.selectedJobStatus == JobStatus.SENT),
                                child: Opacity(
                                  opacity: (controller.selectedJobStatus == JobStatus.SENT) ? 0.5 : 1.0,
                                  child: FxContainer.transparent(
                                    onTap: () {
                                      if (controller.toggleSendJobButton) {
                                        _showSendJobByConfirmDialog();
                                      } else {
                                        _showSendJobByDialog();
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        Column(children: [
                                          Icon(
                                              (controller.toggleSendJobButton)
                                                  ? FontAwesomeIcons.check
                                                  : Icons.upload,
                                              color:
                                                  (controller.toggleSendJobButton)
                                                      ? Colors.green.shade300
                                                      : Colors.white,
                                              size: 40),
                                          FxText.titleSmall(
                                            (controller.toggleSendJobButton)
                                                ? "ยืนยัน"
                                                : "ส่งงาน",
                                            color: (controller.toggleSendJobButton)
                                                ? Colors.green.shade300
                                                : Colors.white,
                                          )
                                        ])
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
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

  void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    var test = args.value;
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
                          FxSpacing.height(15),
                          Padding(
                            padding: FxSpacing.horizontal(14),
                            child: FxText.bodyLarge(
                              'เลือกวันที่',
                              fontWeight: 700,
                            ),
                          ),
                          Padding(
                            padding: FxSpacing.horizontal(14),
                            child: SfDateRangePicker(
                                controller: _dateRangePickerController,
                                onSelectionChanged: _onDateSelectionChanged,
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                initialSelectedRange: PickerDateRange(
                                  appController.fromDate,
                                  appController.toDate,
                                )),
                          ),
                          // Container(
                          //   child: GridView.count(
                          //     //scrollDirection: Axis.horizontal,
                          //     //child: Row(
                          //     physics: ClampingScrollPhysics(),
                          //     crossAxisCount: 2,
                          //     children: [] ,//_buildFilterCategoryList(),
                          //     //),
                          //   ),
                          // ),
                          // FxSpacing.height(8),
                          // Padding(
                          //   padding: FxSpacing.horizontal(14),
                          //   child: FxText.bodyLarge(
                          //     'แสดงผลตาราง',
                          //     fontWeight: 700,
                          //   ),
                          // ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(children: [
                          //     FxContainer(
                          //       child: Row(
                          //         children: [
                          //           FxText("แสดงทุกรายการ")
                          //         ],
                          //       ),
                          //     ),
                          //     FxContainer(
                          //       child: Row(
                          //         children: [
                          //           FxText("จับกลุ่มบาร์โค้ด")
                          //         ],
                          //       ),
                          //     ),
                          //     FxContainer(
                          //       child: Row(
                          //         children: [
                          //           FxText("ลูกค้าผู้ว่าจ้าง")
                          //         ],
                          //       ),
                          //     ),
                          //     FxContainer(
                          //       child: Row(
                          //         children: [
                          //           FxText("ลูกค้าปลายทาง")
                          //         ],
                          //       ),
                          //     ),
                          //   ]),
                          // ),
                          FxSpacing.height(8),
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
                          // Padding(
                          //   padding: FxSpacing.horizontal(24),
                          //   child: FxText.bodyMedium(
                          //     'Price Range ( ' +
                          //         '${estateHomeController.selectedRange.start.toInt().toString()} - ' +
                          //         '${estateHomeController.selectedRange.end.toInt().toString()} )',
                          //     fontWeight: 700,
                          //   ),
                          // ),
                          // RangeSlider(
                          //     activeColor: customTheme.estatePrimary,
                          //     inactiveColor:
                          //         customTheme.estatePrimary.withAlpha(100),
                          //     max: 10000,
                          //     min: 0,
                          //     values: RangeValues(
                          //         0, 200), //estateHomeController.selectedRange,
                          //     onChanged: (RangeValues newRange) {
                          //       // setState(() =>
                          //       //     estateHomeController.selectedRange = newRange);
                          //     }),
                          // Padding(
                          //   padding: FxSpacing.horizontal(24),
                          //   child: FxText.bodyMedium(
                          //     'Bed Rooms',
                          //     fontWeight: 700,
                          //   ),
                          // ),
                          // FxSpacing.height(8),
                          // SingleChildScrollView(
                          //   padding: FxSpacing.x(24),
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //       children:
                          //           ['Any', '1', '2', '3', '4', '5'].map((element) {
                          //     return InkWell(
                          //         onTap: () {
                          //           setState(() {
                          //             if (estateHomeController.selectedBedRooms
                          //                 .contains(element)) {
                          //               estateHomeController.selectedBedRooms
                          //                   .remove(element);
                          //             } else {
                          //               estateHomeController.selectedBedRooms
                          //                   .add(element);
                          //             }
                          //           });
                          //         },
                          //         child: SingleBed(
                          //           bed: element,
                          //           selected: estateHomeController.selectedBedRooms
                          //               .contains(element),
                          //         ));
                          //   }).toList()),
                          // ),
                          // FxSpacing.height(16),
                          // Padding(
                          //   padding: FxSpacing.horizontal(24),
                          //   child: FxText.bodyMedium(
                          //     'Bath Rooms',
                          //     fontWeight: 700,
                          //   ),
                          // ),
                          // FxSpacing.height(8),
                          // SingleChildScrollView(
                          //   padding: FxSpacing.x(24),
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //       children:
                          //           ['Any', '1', '2', '3', '4', '5'].map((element) {
                          //     return InkWell(
                          //         onTap: () {
                          //           setState(() {
                          //             if (estateHomeController.selectedBathRooms
                          //                 .contains(element)) {
                          //               estateHomeController.selectedBathRooms
                          //                   .remove(element);
                          //             } else {
                          //               estateHomeController.selectedBathRooms
                          //                   .add(element);
                          //             }
                          //           });
                          //         },
                          //         child: SingleBath(
                          //           bath: element,
                          //           selected: estateHomeController.selectedBathRooms
                          //               .contains(element),
                          //         ));
                          // }).toList()),
                          // ),
                          FxSpacing.height(16),
                          Padding(
                            padding: FxSpacing.horizontal(24),
                            child: FxButton.block(
                              borderRadiusAll: 8,
                              onPressed: () {
                                appController.onSelectedDateRange(
                                    _dateRangePickerController
                                        .selectedRange!.startDate!,
                                    _dateRangePickerController
                                            .selectedRange!.endDate ??
                                        _dateRangePickerController
                                            .selectedRange!.startDate!);
                                controller.searchJobs("",controller.selectedJobStatus);
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

  void _showSendJobByConfirmDialog() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (BuildContext buildContext) {
          return FxContainer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FxContainer.transparent(
                    child: Center(child: FxText("กรุณายืนยันการทำรายการ ?")),
                  ),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      resetAppBar();
                      _searchTextController.clear();
                      _suggestBoxController.close();
                      _customerSearchController.clear();
                      controller.toggleSendJobButtonFunc(SendJobTypes.none);
                    },
                    child: FxText("ละทิ้งรายการ",
                        color: Colors.blue, fontSize: 21),
                  ),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: FxText("ยกเลิกงาน", color: Colors.red, fontSize: 21),
                  ),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                          NavigationService.navigatorKey.currentContext!,
                          "/send_job");
                    },
                    child: FxText("ส่งงาน", color: Colors.green, fontSize: 21),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showSendJobByDialog() {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (BuildContext buildContext) {
          return FxContainer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FxContainer.transparent(
                    child: FxText("ส่งงานโดย", fontSize: 21),
                  ),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      controller.toggleSendJobButtonFunc(SendJobTypes.list);
                    },
                    child: FxText("เลือกจากรายการ",
                        fontSize: 21, color: Colors.blue),
                  ),
                  Divider(height: 2),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      resetAppBar();
                      controller
                          .toggleSendJobButtonFunc(SendJobTypes.group_barcode);
                    },
                    child: FxText("จับกลุ่มบาร์โค้ด",
                        fontSize: 21, color: Colors.blue),
                  ),
                  Divider(height: 2),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      resetAppBar();
                      controller.filteredJobs = [];
                      controller.toggleSendJobButtonFunc(SendJobTypes.customer);
                    },
                    child: FxText("ลูกค้าผู้ว่าจ้าง",
                        fontSize: 21, color: Colors.blue),
                  ),
                  Divider(height: 2),
                  FxContainer.transparent(
                    onTap: () {
                      Navigator.of(context).pop();
                      resetAppBar();
                      controller.filteredJobs = [];
                      controller.toggleSendJobButtonFunc(SendJobTypes.receiver);
                    },
                    child: FxText("ลูกค้าปลายทาง",
                        fontSize: 21, color: Colors.blue),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void resetAppBar() {
    _appBarAnimationController.animateTo(0,
        duration: Duration(microseconds: 600), curve: Curves.ease);
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomeController>(
      controller: controller,
      builder: (controller) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              if (controller.isSearchMode) {
                _searchTextController.clear();
                FocusScope.of(context).unfocus();
                resetAppBar();
                controller.reloadAllJobs();
              }
              return false;
            },
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.grey.withOpacity(0.6),
                child: Icon(
                  FontAwesomeIcons.arrowUp,
                ),
                onPressed: () {
                  resetAppBar();
                },
              ),
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
                            color: SLColor.LIGHTBLUE2,
                          ),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
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
                          controller.onSelectedRouteLine(
                              appController.routelines[index]);
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
                          // SizedBox(
                          //     width: double.maxFinite,
                          //     child: OutlinedButton(
                          //     onPressed: () {
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressPage()));
                          //     },
                          //     style: ButtonStyle(
                          //         overlayColor: MaterialStateProperty.all(Colors.transparent),
                          //         shape: MaterialStateProperty.all(
                          //             RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(5.0),
                          //             )
                          //         ),
                          //         side: MaterialStateProperty.all(
                          //           BorderSide(
                          //               color: PRIMARY_COLOR,
                          //               width: 1.0
                          //           ),
                          //         )
                          //     ),
                          //     child: Text(
                          //       'Add New Address',
                          //       style: TextStyle(
                          //           color: PRIMARY_COLOR,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 13
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     )
                          //   ),
                          // )
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
