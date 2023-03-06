import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:realm/realm.dart';
import 'package:slpod/api/API.dart';
import 'package:slpod/api/RequestInterceptor.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/extensions/extensions.dart';
import 'package:slpod/handler/UpdateNonUpdatedJobErrorHandler.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/NonUpdatedJob.dart';
import 'package:slpod/repositories/job_repostitory.dart';

class JobSyncManager {
  static API api = API(InterceptedClient.build(
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
    var jobs = await api.fetchJobs("", dateFrom, dateTo, status);

    var localJobs = realm.all<JobDetail>();
    realm.write(() {
      for (var i = 0; i < localJobs.length; i++) {
        var job = localJobs[i];
        var foundItem = jobs.where((element) => element.id == job.id).toList();
        if(foundItem.length == 0)
          realm.delete(job);
      }
    });

    realm.write(() {
      for (var i = 0; i < jobs.length; i++) {
        var serverUpdatedTime = DateTime.parse(jobs[i].updatedDateFromServer);
        var localJobs = realm.all<JobDetail>().query("id == ${jobs[i].id}").toList();

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
  }

  static Future<void> syncNonUpdatedJob() async {
    var config = Configuration.local([NonUpdatedJob.schema]);
    var realm = Realm(config);
    final Connectivity _connectivity = Connectivity();
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var nonUpdatedJobs =
          realm.all<NonUpdatedJob>().query("isUploadSuccess == false").toList();
      if (nonUpdatedJobs.isNotEmpty) {
        for (var i = 0; i < nonUpdatedJobs.length; i++) {
          // api.updateNonUpdatedJob(nonUpdatedJobs[i]).then((value) {
          //     if (value["isSuccess"]) {
          //       realm.write(() {
          //         realm.delete<NonUpdatedJob>(nonUpdatedJobs[i]);
          //       });
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
          var result = await api.updateNonUpdatedJob(nonUpdatedJobs[i]);
          try {
            if (result["isSuccess"]) {
              //_deleteAllFile(nonUpdatedJobs[i]);
              realm.write(() {
                nonUpdatedJobs[i].isUploadSuccess = true;
                //realm.delete<NonUpdatedJob>(nonUpdatedJobs[i]);
              });
            } else {
              throw result["message"];
            }
          } catch (e) {
            var jobIds = nonUpdatedJobs[i].jobIds.split(',');
            for (var i = 0; i < jobIds.length; i++) {
              try {
                await JobRepository.updateJobDetail(
                    jobIds[i].toInt(), JobStatus.SENDING);
              } catch (e) {
                print(e);
              }
            }

            realm.write(() {
              nonUpdatedJobs[i].result = e.toString();
            });

            return Future.error(e.toString());
          }
        }
      }
    } else {
      return Future.error("No Internet Connection.");
    }
  }

  static Future<void> _deleteAllFile(NonUpdatedJob job) async {
    if (job.signImagePath.isNotEmpty) {
      File file = File(job.signImagePath);
      await file.delete();
    }

    for (var i = 0; i < job.imagesPath.length; i++) {
      File file = File(job.imagesPath[i]);
      await file.delete();
    }
  }
}
