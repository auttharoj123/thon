import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final cache = await SharedPreferences.getInstance();

      // data.params['appid'] = "2aed8b06-b9a1-4ae2-b1cd-849a3f15f686";
      // data.params['units'] = 'metric';
      data.headers[HttpHeaders.contentTypeHeader] = "application/json";
      data.headers["x-api-key"] = "2aed8b06-b9a1-4ae2-b1cd-849a3f15f686";
      data.headers[HttpHeaders.authorizationHeader] = 'Bearer ${cache.getString("accessToken")}';
    } catch (e) {
      print(e);
    }
    //print(data.params);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
