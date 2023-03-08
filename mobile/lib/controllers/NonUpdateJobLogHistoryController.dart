import 'package:flutter/material.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/models/NonUpdatedJob.dart';
import 'package:slpod/repositories/job_repostitory.dart';

class NonUpdateJobLogHistoryController extends BaseController {
  List<NonUpdatedJob> jobs = [];
  int selectedGroup = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void onReady() async {
    super.onReady();
    loadData();
  }

  loadData() async {
    jobs = await JobRepository.getAllNonUpdatedJob(selectedGroup == 0);
    update();
  }

  @override
  String getTag() {
    return "non_update_job_history_controller";
  }
}
