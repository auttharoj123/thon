import 'package:intl/intl.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import 'package:flutter/material.dart';
import 'package:slpod/models/RouteLine.dart';

import '../models/JobDetail.dart';
import '../utils/navigation_helper.dart';

enum SendJobTypes { none, list, group_barcode, customer, receiver }

class HomeController extends BaseController {
  late bool showLoading = true;
  late List<MapEntry<int, String>> status = [];
  late int selectedJobStatus = JobStatus.SENDING;
  late bool roleAdmin = false;
  late bool isSearchMode = false;
  late bool toggleSendJobButton = false;
  late List<JobDetail> jobs = [];
  late List<JobDetail> filteredJobs = [];
  late List<JobDetail> selectedJobIds = [];
  late List<JobDetailWrapper> selectedGroupBarcode = [];
  late SendJobTypes selectedJobType = SendJobTypes.none;

  @override
  void initState() async {
    super.initState();

    status = []
      ..add(MapEntry(JobStatus.SENDING, getOrderStatusTitle(JobStatus.SENDING)))
      ..add(MapEntry(JobStatus.SENT, getOrderStatusTitle(JobStatus.SENT)))
      ..add(MapEntry(JobStatus.REJECT_SENDING,
          getOrderStatusTitle(JobStatus.REJECT_SENDING)));
  }

  @override
  void onReady() async {
    super.onReady();
    reloadAllJobs();
  }

  onSelectedRouteLine(RouteLine routeline) async {
    await appController.onSelectedRouteLine(routeline);
    await reloadAllJobs();
    update();
  }

  onSelectedJobStatus(int status) {
    selectedJobStatus = status;
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

  getOrderStatusColor(int orderStatus) {
    switch (orderStatus) {
      case JobStatus.SENDING:
        return Colors.yellow.shade700;
      case JobStatus.SENT:
        return Colors.green;
      case JobStatus.REJECT_SENDING:
        return Colors.red.shade300;
    }
  }

  Future<void> reloadAllJobs({bool forceReload = false}) async {
    isSearchMode = false;
    showLoading = true;
    update();
    jobs = await appController.api.fetchJobs(
        appController.selectedRouteLine.routelineId.toString(),
        DateFormat("yyyy-MM-dd").format(appController.fromDate),
        DateFormat("yyyy-MM-dd").format(appController.toDate),
        "17,18,19,20",
        forceReload);

    searchJobs("",selectedJobStatus);//List.from(jobs);
    showLoading = false;
    update();
  }

  void toggleSendJobButtonFunc(SendJobTypes jobType) {
    selectedJobType = jobType;
    toggleSendJobButton = !toggleSendJobButton;

    if (!toggleSendJobButton) {
      // selectedJobIds.forEach((element) {
      //   element.isChecked = false;
      // });
      selectedGroupBarcode.clear();
      selectedJobIds.clear();
      reloadAllJobs();
    }
    update();
  }

  void goToJobDetailPage(JobDetail jobDetail) {
    Navigator.pushNamed(
        NavigationService.navigatorKey.currentContext!, "/job_detail",
        arguments: jobDetail);
  }

  void searchJobs(String text, int status) async {
    isSearchMode = text.isNotEmpty;

    showLoading = true;
    update();

    // var data = await appController.api.fetchJobs(
    //     appController.selectedRouteLine.routelineId.toString(),
    //     DateFormat("yyyy-MM-dd").format(appController.fromDate),
    //     DateFormat("yyyy-MM-dd").format(appController.toDate),
    //     "17",
    //     false);
    //var items = jobs.toJobDetailList();
    //jobs = data.toList();

    List<JobDetail> filteredData = [];
    if (selectedJobType == SendJobTypes.list ||
        selectedJobType == SendJobTypes.none) {
      filteredData = jobs.where((element) {
        if (element.orderStatus != status) return false;
        return element.barcode.toLowerCase().contains(text.toLowerCase()) ||
            element.jobNumber.toLowerCase().contains(text.toLowerCase()) ||
            element.goodsDetails.toLowerCase().contains(text.toLowerCase()) ||
            element.receiverName.toLowerCase().contains(text.toLowerCase()) ||
            element.receiverAddress
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            element.customerName.toLowerCase().contains(text.toLowerCase()) ||
            element.contactName.toLowerCase().contains(text.toLowerCase()) ||
            element.contactTelephone
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            element.reference1.toLowerCase().contains(text.toLowerCase()) ||
            element.reference2.toLowerCase().contains(text.toLowerCase()) ||
            element.reference3.toLowerCase().contains(text.toLowerCase()) ||
            element.remark.toLowerCase().contains(text.toLowerCase());
      }).toList();
    } else if (selectedJobType == SendJobTypes.customer) {
      if (text.isNotEmpty) {
        filteredData = jobs.where((element) {
          return element.customerName
              .toLowerCase()
              .contains(text.toLowerCase());
        }).toList();
      }
    } else if (selectedJobType == SendJobTypes.group_barcode) {
      filteredData = jobs.where((element) {
        return element.barcode.toLowerCase().contains(text.toLowerCase());
      }).toList();
    } else if (selectedJobType == SendJobTypes.receiver) {
      if (text.isNotEmpty) {
        filteredData = jobs.where((element) {
          return element.receiverName
              .toLowerCase()
              .contains(text.toLowerCase());
        }).toList();
      }
    }

    // realTotalJobs = filteredData.length;
    filteredJobs = List.from(filteredData);
    showLoading = false;
    update();
  }

  @override
  String getTag() {
    return "home_controller";
  }
}
