import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:slpod/api/API.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/managers/JobSyncManager.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import 'package:flutter/material.dart';
import "package:slpod/extensions/jobdetail_extension.dart";
import 'package:slpod/repositories/job_repostitory.dart';

import '../models/JobDetail.dart';
import '../utils/navigation_helper.dart';

enum SendJobTypes { none, list, group_barcode, customer, receiver }

enum SelectionJobType { receive_job, send_job }

class HomeController extends BaseController {
  late bool showLoading = true;
  late List<MapEntry<int, String>> status = [];
  late int selectedJobStatus = JobStatus.SENDING;
  late bool roleAdmin = false;
  late bool isSearchMode = false;
  late bool toggleCameraButton = false;
  late bool isShowList = false;
  late List<JobDetail> jobs = [];
  late List<JobDetailWrapper> filteredJobs = [];
  late List<JobDetailWrapper> selectedJobs = [];
  late List<JobDetail> selectedJobIds = [];
  late SendJobTypes selectedJobType = SendJobTypes.none;
  late SelectionJobType selectionJobType = SelectionJobType.receive_job;
  late Stream<dynamic> _sendJobEventSubscription;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() async {
    super.initState();

    status = []
      ..add(MapEntry(JobStatus.SENDING, getOrderStatusTitle(JobStatus.SENDING)))
      ..add(MapEntry(JobStatus.SENT, getOrderStatusTitle(JobStatus.SENT)))
      ..add(MapEntry(JobStatus.REJECT_SENDING,
          getOrderStatusTitle(JobStatus.REJECT_SENDING)));

    JobRepository.listenJobDetail((event) {
      reloadAllJobs();
      clearAllSelection();
    });
  }

  @override
  void dispose() {
    //appController.sendJobEventStreamController.close();
    // _sendJobEventSubscription();
    JobRepository.cancelJobDetail();
    super.dispose();
  }

  @override
  void onReady() async {
    super.onReady();
    reloadAllJobs(forceReload: true);
  }

  // onSelectedRouteLine(RouteLine routeline) async {
  //   await appController.onSelectedRouteLine(routeline);
  //   await reloadAllJobs();
  //   update();
  // }

  onSelectedJobStatus(int status) {
    selectedJobStatus = status;
    selectionJobType = SelectionJobType.receive_job;
    clearAllSelection();
    update();
  }

  onResetFilter() {
    selectedJobStatus = JobStatus.SENDING;
    update();
  }

  getOrderStatusTitle(int orderStatus) {
    switch (orderStatus) {
      case JobStatus.SENDING:
        return "งานที่รับแล้ว";
      case JobStatus.SENT:
        return "งานที่ส่งแล้ว";
      case JobStatus.REJECT_SENDING:
        return "งานที่ยกเลิก";
      default:
        return "";
    }
  }

  Color getOrderStatusColor(int orderStatus) {
    switch (orderStatus) {
      case JobStatus.SENDING:
        return Colors.yellow.shade700;
      case JobStatus.SENT:
        return Colors.green;
      case JobStatus.REJECT_SENDING:
        return Colors.red.shade300;
    }
    return Colors.white;
  }

  Future<void> reloadAllJobs({bool forceReload = false}) async {
    isSearchMode = false;
    showLoading = true;
    selectedJobIds.clear();
    update();

    if (selectedJobStatus == JobStatus.SENDING) {
      ConnectivityResult connectResult =
          await Connectivity().checkConnectivity();
      if (forceReload && connectResult != ConnectivityResult.none) {
        try {
          await JobSyncManager.syncJobDetailAll(
              "",
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.now().subtract(Duration(days: 30))),
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.now().add(Duration(days: 30))),
              "17");
        } catch (e) {
        }
      }

      jobs = await JobRepository.getJobDetailsByOrderStatus(
          selectedJobStatus.toString());
    } else if (selectedJobStatus == JobStatus.SENT ||
        selectedJobStatus == JobStatus.REJECT_SENDING) {
      jobs = await appController.api.fetchJobs(
          "",
          DateFormat("yyyy-MM-dd").format(appController.fromDate),
          DateFormat("yyyy-MM-dd").format(appController.toDate),
          selectedJobStatus.toString());
    }

    selectedJobType = SendJobTypes.group_barcode;
    searchJobs("", selectedJobStatus);
    showLoading = false;
    clearAllSelection();
    update();
  }

  void selectionJobTypeChanged(SelectionJobType type) {
    selectionJobType = type;
    clearAllSelection();
    update();
  }

  void goToJobDetailPage(JobDetail jobDetail) {
    Navigator.pushNamed(
        NavigationService.navigatorKey.currentContext!, "/job_detail",
        arguments: jobDetail);
  }

  void clearAllSelection() {
    filteredJobs.forEach((element) {
      element.isChecked = false;
      element.items.forEach((element) {
        element.isChecked = false;
      });
    });
    selectedJobIds.clear();
    selectedJobs.clear();
    update();
  }

  Future<List<JobDetail>> searchJobByBarcode(String value) async {
    return jobs.where((element) => element.barcode == value).toList();
  }

  void selectJobByBarcode(List<JobDetail> items) async {
    if (items.length > 0) {
      var foundItem = items.where((item1) {
        return selectedJobIds.contains(item1);
      });

      if (foundItem.length == 0) {
        var wrapper = List<JobDetailWrapper>.from(
            items.toJobDetailWrapper(JobDetailGroupBy.barcode));
        wrapper.forEach((element) {
          element.isChecked = true;
          element.items.forEach((element) {
            element.isChecked = true;
            selectedJobIds.add(element);
          });
        });
        filteredJobs.addAll(wrapper);
        update();
      }
    }
  }

  Future<String> searchJobsForSend(String text) async {
    var jobs = await searchJobByBarcode(text);
    if (jobs.length > 0) {
      var foundItem = jobs.where((item) {
        return selectedJobIds.contains(item);
      });

      if (foundItem.length == 0) {
        selectedJobs.addAll(jobs.toJobDetailWrapper(JobDetailGroupBy.barcode));
        selectedJobIds.addAll(jobs);
        update();
        return '';
      } else {
        return 'บาร์โค้ด $text ได้ถูกเลือกแล้ว';
      }
    }
    return 'ไม่พบบาร์โค้ด $text';
  }

  void searchJobs(String text, int status) async {
    isSearchMode = text.isNotEmpty;

    showLoading = true;
    update();

    List<JobDetail> filteredData = jobs.where((element) {
      if (element.orderStatus != status) return false;
      return element.barcode.toLowerCase().contains(text.toLowerCase()) ||
          element.jobNumber.toLowerCase().contains(text.toLowerCase()) ||
          element.goodsDetails.toLowerCase().contains(text.toLowerCase()) ||
          element.receiverName.toLowerCase().contains(text.toLowerCase()) ||
          element.receiverAddress.toLowerCase().contains(text.toLowerCase()) ||
          element.customerName.toLowerCase().contains(text.toLowerCase()) ||
          element.contactName.toLowerCase().contains(text.toLowerCase()) ||
          element.contactTelephone.toLowerCase().contains(text.toLowerCase()) ||
          element.reference1.toLowerCase().contains(text.toLowerCase()) ||
          element.reference2.toLowerCase().contains(text.toLowerCase()) ||
          element.reference3.toLowerCase().contains(text.toLowerCase()) ||
          element.remark.toLowerCase().contains(text.toLowerCase());
    }).toList();
    // if (selectedJobType == SendJobTypes.list ||
    //     selectedJobType == SendJobTypes.none) {
    //   filteredData = jobs.where((element) {
    //     if (element.orderStatus != status) return false;
    //     return element.barcode.toLowerCase().contains(text.toLowerCase()) ||
    //         element.jobNumber.toLowerCase().contains(text.toLowerCase()) ||
    //         element.goodsDetails.toLowerCase().contains(text.toLowerCase()) ||
    //         element.receiverName.toLowerCase().contains(text.toLowerCase()) ||
    //         element.receiverAddress
    //             .toLowerCase()
    //             .contains(text.toLowerCase()) ||
    //         element.customerName.toLowerCase().contains(text.toLowerCase()) ||
    //         element.contactName.toLowerCase().contains(text.toLowerCase()) ||
    //         element.contactTelephone
    //             .toLowerCase()
    //             .contains(text.toLowerCase()) ||
    //         element.reference1.toLowerCase().contains(text.toLowerCase()) ||
    //         element.reference2.toLowerCase().contains(text.toLowerCase()) ||
    //         element.reference3.toLowerCase().contains(text.toLowerCase()) ||
    //         element.remark.toLowerCase().contains(text.toLowerCase());
    //   }).toList();
    // } else if (selectedJobType == SendJobTypes.customer) {
    //   if (text.isNotEmpty) {
    //     filteredData = jobs.where((element) {
    //       return element.customerName
    //           .toLowerCase()
    //           .contains(text.toLowerCase());
    //     }).toList();
    //   }
    // } else if (selectedJobType == SendJobTypes.group_barcode) {
    //   filteredData = jobs.where((element) {
    //     return element.barcode.toLowerCase().contains(text.toLowerCase());
    //   }).toList();
    // } else if (selectedJobType == SendJobTypes.receiver) {
    //   if (text.isNotEmpty) {
    //     filteredData = jobs.where((element) {
    //       return element.receiverName
    //           .toLowerCase()
    //           .contains(text.toLowerCase());
    //     }).toList();
    //   }
    // }

    // realTotalJobs = filteredData.length;
    filteredJobs =
        List.from(filteredData.toJobDetailWrapper(JobDetailGroupBy.barcode));
    showLoading = false;
    update();
  }

  @override
  String getTag() {
    return "home_controller";
  }
}
