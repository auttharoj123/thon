import 'package:flutter/material.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/models/NonUpdatedJob.dart';
import 'package:slpod/repositories/job_repostitory.dart';

class NonUpdateJobLogHistoryController extends BaseController {
  List<NonUpdatedJob> jobs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void onReady() async {
    super.onReady();
    jobs = await JobRepository.getAllNonUpdatedJob(false);
  }

  @override
  String getTag() {
    return "non_update_job_history_controller";
  }
}
