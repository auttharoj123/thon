import 'package:flutter/material.dart';
import 'package:slpod/controllers/BaseController.dart';
import 'package:slpod/managers/JobSyncManager.dart';
import 'package:slpod/models/NonUpdatedJob.dart';
import 'package:slpod/repositories/job_repostitory.dart';

class NonUpdateJobLogHistoryController extends BaseController {
  List<NonUpdatedJob> jobs = [];
  int selectedGroup = 0;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();

    JobRepository.listenNonUpdatedJob((event) {
      loadData();
    });
  }

  @override
  void dispose() {
    JobRepository.cancelNonUpdatedJob();
    super.dispose();
  }

  @override
  void onReady() async {
    super.onReady();
    await removeData(false);
    await loadData();
  }

  loadData() async {
    jobs = await JobRepository.getAllNonUpdatedJob(selectedGroup == 0);
    update();
  }

  removeData(bool removeAll) async {
    await JobRepository.removeAllNonUpdatedJob(removeAll: removeAll);
    loadData();
  }

  syncAllJob() async {
    try {
      isUploading = true;
      update();
      await JobSyncManager.syncNonUpdatedJob();
    } finally {
      isUploading = false;
      loadData();
    }
  }

  @override
  String getTag() {
    return "non_update_job_history_controller";
  }
}
