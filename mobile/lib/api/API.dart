import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/models/MstType.dart';
import 'package:slpod/models/NonUpdatedJob.dart';

import '../models/JobDetail.dart';
import '../models/ResultResponse.dart';
import '../models/RouteLine.dart';

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    String method,
    Uri url, {
    required this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  /// Freezes all mutable fields and returns a
  /// single-subscription [http.ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress?.call(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}

class API {
  // String baseUrl = "http://192.168.1.36:4000/api";
  late String domainName = "express.sltransport.co.th:4000";
  // late String domainName = "192.168.1.36:4000";
  late String baseUrl;
  InterceptedClient client;

  API(this.client) {
    baseUrl = "http://$domainName/api";
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    var parsedData;
    try {
      final response = await client.post("$baseUrl/auth/login".toUri(),
          body: jsonEncode({'login_name': username, 'password': password}));
      if (response.statusCode == 200) {
        parsedData =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        return Future.error(
          "Error while fetching.",
          StackTrace.fromString("${response.body}"),
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception catch (error) {
      print(error);
      return Future.error('Unexpected error 😢');
    }

    return parsedData;
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    var parsedData;
    try {
      final response = await client.get("$baseUrl/user/info".toUri());
      if (response.statusCode == 200) {
        parsedData =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        return Future.error(
          "Error while fetching.",
          StackTrace.fromString("${response.body}"),
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception catch (error) {
      print(error);
      return Future.error('Unexpected error 😢');
    }

    return parsedData;
  }

  Future<List<RouteLine>> fetchAllRouteLine() async {
    List<RouteLine> parsedData;
    try {
      final response = await client.get("$baseUrl/routeline/list".toUri());
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        parsedData =
            (ResultResponse<RouteLine>().mapData(decodedResponse, (item) {
          return RouteLineJ.fromJson(item);
        }).result as List<RouteLine>);
      } else {
        return Future.error(
          "Error while fetching.",
          StackTrace.fromString("${response.body}"),
        );
      }
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception catch (error) {
      print(error);
      return Future.error('Unexpected error 😢');
    }

    return parsedData;
  }

  Future<List<JobDetail>> fetchJobs(
    String routelineId,
    String dateFrom,
    String dateTo,
    String status,
    // bool forceReload,
  ) async {
    List<JobDetail> parsedData = [];
    try {
      // var localData = RepositoryManager.getJobDetailsAll();
      // if (forceReload || localData.length == 0) {
      try {
        final response = await client.get(
            "$baseUrl/job/list?date_from=$dateFrom&date_to=$dateTo&status=$status"
                .toUri());
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<String, dynamic>;
          parsedData =
              (ResultResponse<JobDetail>().mapData(decodedResponse, (item) {
            return JobDetailJ.fromJson(item);
          }).result as List<JobDetail>);
        } else {
          return Future.error(
            "Error while fetching.",
            StackTrace.fromString("${response.body}"),
          );
        }
      } on SocketException {
        return Future.error('No Internet connection 😑');
      } on FormatException {
        return Future.error('Bad response format 👎');
      } on Exception catch (error) {
        print(error);
        return Future.error('Unexpected error 😢');
      }

      //   realm.write(() {
      //     // realm.addAll(parsedData , update: true);
      //     realm.addAll(parsedData, update: true);
      //   });
      //   //realm.close();

      //   parsedData = realm.all<JobDetail>().toList();
      // } else {
      //   parsedData = localData.toList();
      //   await Future.delayed(Duration(milliseconds: 100));
      // }
    } catch (e) {
      var test = "";
    } finally {
      //realm.close();
    }

    return parsedData;
  }

  Future<Map<String, dynamic>?> updateJobStatusByBarCode(String barcode,
      {bool forceUpdate = false}) async {
    try {
      try {
        final response = await client.get((forceUpdate)
            ? "$baseUrl/job/receive-job?barcode=$barcode&forceUpdate=$forceUpdate"
                .toUri()
            : "$baseUrl/job/receive-job?barcode=$barcode".toUri());
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<String, dynamic>;
          return decodedResponse;
        } else {
          return Future.error(
            "Error while fetching.",
            StackTrace.fromString("${response.body}"),
          );
        }
      } on SocketException {
        return Future.error('No Internet connection 😑');
      } on FormatException {
        return Future.error('Bad response format 👎');
      } on Exception catch (error) {
        print(error);
        return Future.error('Unexpected error 😢');
      }
    } catch (e) {
    } finally {}
    return null;
  }

  Future<Map<String, dynamic>> updateNonUpdatedJob(
      NonUpdatedJob nonUpdatedJobs) async {
    // for (var i = 0; i < nonUpdatedJobs.length; i++) {

    // }
    try {
      final cache = await SharedPreferences.getInstance();
      Map<String, String> headers = {
        "x-api-key": "2aed8b06-b9a1-4ae2-b1cd-849a3f15f686",
        "Authorization": "Bearer ${cache.getString("accessToken")}"
      };
      final request = MultipartRequest(
        'POST',
        Uri.http(domainName, 'api/job/update-job'),
        onProgress: (bytes, totalBytes) {
          // FlutterForegroundTask.updateService(
          //   notificationTitle: 'Uploading ${nonUpdatedJobs.length} Jobs',
          //   notificationText: (bytes / totalBytes).toString(),
          // );
        },
      );
      request.headers.addAll(headers);
      request.fields['jobIds'] = nonUpdatedJobs.jobIds;
      request.fields['remarkCatId'] =
          nonUpdatedJobs.targetRemarkCategoryId.toString();
      request.fields['complacency'] =
          nonUpdatedJobs.selectedComplacencyLevel.toString();
      request.fields['order_status'] =
          nonUpdatedJobs.targetOrderStatus.toString();
      request.fields['mobile_date'] = nonUpdatedJobs.createdDate.toString();
      request.fields['specialRemark'] = nonUpdatedJobs.specialRemark ?? "";
      request.fields['latitude'] = nonUpdatedJobs.latitude ?? "";
      request.fields['longitude'] = nonUpdatedJobs.longitude ?? "";

      if (nonUpdatedJobs.signImagePath.isNotEmpty) {
        var file = File(nonUpdatedJobs.signImagePath);
        final fileStream = http.ByteStream.fromBytes(file.readAsBytesSync());
        final length = await file.length();

        request.files.add(new http.MultipartFile(
            'signatureImage', fileStream, length,
            filename: path.basename(nonUpdatedJobs.signImagePath),
            contentType: MediaType('image', 'jpeg')));
      }

      for (var j = 0; j < nonUpdatedJobs.imagesPath.length; j++) {
        var file = File(nonUpdatedJobs.imagesPath[j]);
        final fileStream = http.ByteStream.fromBytes(file.readAsBytesSync());
        final length = await file.length();
        request.files.add(new http.MultipartFile('images', fileStream, length,
            filename: nonUpdatedJobs.imagesPath[j],
            contentType: MediaType('image', 'jpeg')));
      }

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr) as Map<String, dynamic>;
    } on SocketException {
      return Future.error('No Internet connection 😑');
    } on FormatException {
      return Future.error('Bad response format 👎');
    } on Exception catch (error) {
      print(error);
      return Future.error('Unexpected error 😢');
    }
  }

  Future<List<MstType>> fetchRemark() async {
    List<MstType> parsedData = [];
    // Create a Configuration object
    var config = Configuration.local([MstType.schema]);
    // Opean a Realm
    var realm = Realm(config);
    try {
      try {
        final response = await client
            .get("$baseUrl/master-data/list-status-category/11".toUri());
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes))
              as Map<String, dynamic>;
          parsedData =
              (ResultResponse<MstType>().mapData(decodedResponse, (item) {
            return MstTypeJ.fromJson(item);
          }).result as List<MstType>);
        } else {
          return Future.error(
            "Error while fetching.",
            StackTrace.fromString("${response.body}"),
          );
        }
      } on SocketException {
        return Future.error('No Internet connection 😑');
      } on FormatException {
        return Future.error('Bad response format 👎');
      } on Exception catch (error) {
        print(error);
        return Future.error('Unexpected error 😢');
      }

      // realm.write(() {
      //   // realm.addAll(parsedData , update: true);
      //   realm.addAll(parsedData, update: true);
      // });
      //realm.close();

      // parsedData = realm
      //     .all<JobDetail>()
      //     .query("routelineId == '$routelineId' AND orderStatus == '$status'")
      //     .toList();
    } catch (e) {
    } finally {
      //realm.close();
    }

    return parsedData;
  }
}
