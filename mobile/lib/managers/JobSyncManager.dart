
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/api/API.dart';
import 'package:slpod/api/RequestInterceptor.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/NonUpdatedJob.dart';

class JobSyncManager {
  static API _api = API(InterceptedClient.build(
    interceptors: [
      RequestInterceptor(),
      //LoggerInterceptor(),
    ],
    //retryPolicy: ExpiredTokenRetryPolicy(),
  ));

  static Future<void> syncJobDetailAll(
      String routelineId, String dateFrom, String dateTo, String status) async {
    var config = Configuration.local([JobDetail.schema]);
    var realm = Realm(config);

    try {
      var jobs = await _api.fetchJobs("", dateFrom, dateTo, status);

      var localJobs =
          realm.all<JobDetail>().query("orderStatus == 17").toList();
      realm.write(() {
        realm.deleteMany<JobDetail>(localJobs);
      });

      realm.write(() {
        for (var i = 0; i < jobs.length; i++) {
          var serverUpdatedTime = DateTime.parse(jobs[i].updatedDateFromServer);
          var localJobs =
              realm.all<JobDetail>().query("id == ${jobs[i].id}").toList();

          jobs[i].latestUpdateTime = serverUpdatedTime;
          if (localJobs.length == 0) {
            realm.add(jobs[i]);
            continue;
          }

          if (serverUpdatedTime.isBefore(localJobs[0].latestUpdateTime!)) {
            continue;
          }

          realm.add(jobs[i], update: true);
        }
      });
    } catch (e) {
      return Future.error("There is something went wrong on server.");
    }
  }

  static Future<void> syncNonUpdatedJob() async {
    final prefs = await SharedPreferences.getInstance();
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    final Connectivity _connectivity = Connectivity();
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var nonUpdatedJobs =
          realm.all<NonUpdatedJob>().query("isUploadSuccess == false AND loginName == '${prefs.getString("username")!}'").toList();
      if (nonUpdatedJobs.isNotEmpty) {
        for (var i = 0; i < nonUpdatedJobs.length; i++) {
          // api.updateNonUpdatedJob(nonUpdatedJobs[i]).then((value) {
          //     if (value["isSuccess"]) {
          //       // realm.write(() {
          //       //   realm.delete<NonUpdatedJob>(nonUpdatedJobs[i]);
          //       // });
          //     } else {
          //       realm.write(() {
          //         nonUpdatedJobs[i].result = value["message"];
          //       });
          //     }
          // }).onError((error, stackTrace) {
          //   realm.write(() {
          //     nonUpdatedJobs[i].result = error.toString();
          //   });
          // });
          // // realm.write(() {
          // //   nonUpdatedJobs[i].isUploadSuccess = true;
          // //   //realm.delete<NonUpdatedJob>(nonUpdatedJobs[i]);
          // // });
          // continue;
          try {
            var result = await _api.updateNonUpdatedJob(nonUpdatedJobs[i]);
            if (result["isSuccess"]) {
              realm.write(() {
                nonUpdatedJobs[i].isUploadSuccess = true;
                nonUpdatedJobs[i].result = null;
              });
            } else {
              throw result["message"];
            }
          } catch (e) {
            realm.write(() {
              nonUpdatedJobs[i].result = e.toString();
            });
            //return Future.error(e.toString());
          }
        }
      }
    } else {
      return Future.error("No Internet Connection.");
    }
  }

  // static Future<void> _deleteAllFile(NonUpdatedJob job) async {
  //   if (job.signImagePath.isNotEmpty) {
  //     File file = File(job.signImagePath);
  //     await file.delete();
  //   }

  //   for (var i = 0; i < job.imagesPath.length; i++) {
  //     File file = File(job.imagesPath[i]);
  //     await file.delete();
  //   }
  // }
}
