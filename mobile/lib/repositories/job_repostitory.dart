import 'dart:async';

import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/api/API.dart';
import 'package:slpod/api/RequestInterceptor.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/NonUpdatedJob.dart';

class JobRepository {
  static late StreamSubscription<RealmResultsChanges<JobDetail>>? _subscription;

  static listenJobDetail(
      void Function(RealmResultsChanges<JobDetail>)? onData) {
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);
    _subscription = realm.all<JobDetail>().changes.listen(onData);
  }

  static cancelJobDetail() {
    if (_subscription != null) {
      _subscription!.cancel();
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
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    return realm
        .all<NonUpdatedJob>()
        .query("isUploadSuccess == $isUploadSuccess")
        .toList();
  }
}
