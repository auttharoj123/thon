import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:realm/realm.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import 'package:slpod/models/MstType.dart';

import '../models/JobDetail.dart';
import '../models/ResultResponse.dart';
import '../models/RouteLine.dart';
import "package:collection/collection.dart";

class API {
  // String baseUrl = "http://192.168.1.38:3000/api";
  String baseUrl = "http://express.sltransport.co.th:4000/api";
  InterceptedClient client;

  API(this.client);

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
    bool forceReload,
  ) async {
    List<JobDetail> parsedData = [];
    // Create a Configuration object
    var config = Configuration.local([JobDetail.schema]);
    // Opean a Realm
    var realm = Realm(config);
    try {
      realm.write(() {
        realm.deleteAll<JobDetail>();
      });

      var localData =
          realm.all<JobDetail>().query("routelineId == '$routelineId'");
      if (forceReload || localData.length == 0) {
        try {
          final response = await client.get(
              "$baseUrl/job/list?routeline_id=$routelineId&date_from=$dateFrom&date_to=$dateTo&status=$status"
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

        realm.write(() {
          // realm.addAll(parsedData , update: true);
          realm.addAll(parsedData, update: true);
        });
        //realm.close();

        parsedData = realm
            .all<JobDetail>()
            .query("routelineId == '$routelineId'")
            .toList();
      } else {
        parsedData = localData.toList();
        await Future.delayed(Duration(milliseconds: 100));
      }
    } catch (e) {
      var test = "";
    } finally {
      //realm.close();
    }

    return parsedData;
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
