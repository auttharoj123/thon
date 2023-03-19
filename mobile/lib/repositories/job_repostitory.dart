import 'dart:async';
import 'dart:io';

import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/NonUpdatedJob.dart';

class JobRepository {
  static late StreamSubscription<RealmResultsChanges<JobDetail>>? _subscription;
  static late StreamSubscription<RealmResultsChanges<NonUpdatedJob>>?
      _nonUpdaatedJobsubscription;

  static listenJobDetail(
      void Function(RealmResultsChanges<JobDetail>)? onData) {
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);
    _subscription = realm.all<JobDetail>().changes.listen(onData);
  }

  static listenNonUpdatedJob(
      void Function(RealmResultsChanges<NonUpdatedJob>)? onData) {
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    _nonUpdaatedJobsubscription =
        realm.all<NonUpdatedJob>().changes.listen(onData);
  }

  static cancelJobDetail() {
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  static cancelNonUpdatedJob() {
    if (_nonUpdaatedJobsubscription != null) {
      _nonUpdaatedJobsubscription!.cancel();
    }
  }

  static Future<List<JobDetail>> getJobDetailsByOrderStatus(
      String status) async {
    final prefs = await SharedPreferences.getInstance();
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);
    return realm
        .all<JobDetail>()
        .query(
            "orderStatus == $status AND updatedUserFromServer == '${prefs.getString('username')}'")
        .query("orderStatus == $status")
        .toList();
  }

  static Future<List<JobDetail>> getJobDetailsAll(
      String routelineId, String dateFrom, String dateTo, String status) async {
    final prefs = await SharedPreferences.getInstance();
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);
    return realm
        .all<JobDetail>()
        .query("updatedUserFromServer == ${prefs.getString('username')}")
        .toList();
  }

  static Future<int> countNonUpdatedJobNotSuccess() async {
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    var foundItems =
        realm.all<NonUpdatedJob>().query("isUploadSuccess == false");
    return foundItems.length;
  }

  static Future<void> addNonUpdatedJob(NonUpdatedJob job) {
    try {
      var config = Configuration.local([NonUpdatedJob.schema]);
      var realm = Realm(config);

      var foundItems = realm
          .all<NonUpdatedJob>()
          .query("isUploadSuccess == false AND jobIds == '${job.jobIds}'");
      if (foundItems.length > 0) {
        realm.write(() {
          realm.deleteMany(foundItems);
        });
      }

      realm.write(() {
        realm.add<NonUpdatedJob>(job);
      });
    } catch (e) {
      return Future.error("Error on creating NonUpdatedJob");
    }
    return Future(() => {});
  }

  static Future<void> updateJobDetail(int id, int orderStatus) {
    try {
      var config = Configuration.local([JobDetail.schema]);
      var realm = Realm(config);

      realm.write(() {
        var item = realm.all<JobDetail>().query("id == $id").first;
        item.orderStatus = orderStatus;
        item.latestUpdateTime = DateTime.now();
        item.isUpdatedFailed = true;
      });
    } catch (e) {
      return Future.error("Error on updating JobDetail");
    }
    return Future(() => {});
  }

  static Future<List<NonUpdatedJob>> getAllNonUpdatedJob(
      bool isUploadSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    return realm
        .all<NonUpdatedJob>()
        .query(
            "isUploadSuccess == $isUploadSuccess AND loginName == '${prefs.getString("username")}' SORT(createdDate DESC)")
        .toList();
  }

  static Future<void> removeJobDetail(NonUpdatedJob nonUpdatedJob) async {
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);

    var ids = nonUpdatedJob.jobIds.split(',');
    realm.write(() {
      for (var i = 0; i < ids.length; i++) {
        var foundItem = realm
            .all<JobDetail>()
            .query("id == ${ids[i]} AND orderStatus == 18")
            .toList();
        if (foundItem.length > 0) {
          realm.deleteMany<JobDetail>(foundItem);
        }
      }
    });
  }

  static Future<void> removeAllNonUpdatedJob(
      {bool removeAll = false, bool withoutLoginName = false}) async {
    final prefs = await SharedPreferences.getInstance();
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    List<NonUpdatedJob> items;

    if (withoutLoginName) {
      items =
          realm.all<NonUpdatedJob>().query("isUploadSuccess == true").toList();
    } else {
      items = realm
          .all<NonUpdatedJob>()
          .query(
              "isUploadSuccess == true AND loginName == '${prefs.getString("username")}'")
          .toList();
    }

    if (removeAll) {
      for (var i = 0; i < items.length; i++) {
        if (items[i].signImagePath.isNotEmpty) {
          File file = File(items[i].signImagePath);
          if (await file.exists()) await file.delete();
        }

        for (var j = 0; j < items[i].imagesPath.length; j++) {
          File file = File(items[i].imagesPath[j]);
          if (await file.exists()) await file.delete();
        }

        await removeJobDetail(items[i]);
      }

      realm.write(() {
        realm.deleteMany<NonUpdatedJob>(items);
      });
    } else {
      //ลบเฉพาะที่มากกว่า 7 วัน
      var jobs = items.where((element) {
        return element.createdDate
            .add(Duration(days: 7))
            .isBefore(DateTime.now());
      }).toList();

      for (var i = 0; i < jobs.length; i++) {
        if (jobs[i].signImagePath.isNotEmpty) {
          File file = File(jobs[i].signImagePath);
          await file.delete();
        }

        for (var i = 0; i < jobs[i].imagesPath.length; i++) {
          File file = File(jobs[i].imagesPath[i]);
          await file.delete();
        }

        await removeJobDetail(jobs[i]);
      }

      realm.write(() {
        realm.deleteMany(jobs);
      });
    }
  }
}
