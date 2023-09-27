import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/utils/navigation_helper.dart';
import 'package:slpod/views/LoginScreenPage.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';

class RequestInterceptor implements InterceptorContract {
  var globalWidget = GlobalWidget();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final cache = await SharedPreferences.getInstance();
      data.headers[HttpHeaders.contentTypeHeader] = "application/json";
      data.headers["x-api-key"] = "2aed8b06-b9a1-4ae2-b1cd-849a3f15f686";

      if (cache.getString("deviceInfo") != null) {
        String deviceInfoJsonStr = cache.getString("deviceInfo")!;
        List<int> bytes = utf8.encode(deviceInfoJsonStr);
        data.headers["x-data-encrypt"] = base64.encode(bytes);
      }

      data.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${cache.getString("accessToken")}';
    } catch (e) {
      print(e);
    }
    //print(data.params);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      showDialog(
          context: NavigationService.navigatorKey.currentContext!,
          builder: (context) => globalWidget
                  .errorDialog(context, "Token Expired. Please Login again.",
                      acceptPressed: () {
                Navigator.of(
                        NavigationService.navigatorKey.currentState!.context)
                    .pushReplacementNamed("/login");
              }));
    }
    return data;
  }
}
