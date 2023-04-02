import 'dart:convert';
import 'dart:developer';

import 'package:cvetovik/core/api/http_client_base.dart';
import 'package:cvetovik/main.dart';
import 'package:cvetovik/models/api/response/base/app_base_response.dart';
import 'package:cvetovik/models/api/shared/device_register.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

typedef T InstanceFromJson<T>(dynamic e);

abstract class ApiBase {
  //static const String baseUrl = "https://beta-app.cvetovik.com/";

  static String getBaseUtl() {
    if (isProd) {
      return "https://app.cvetovik.com/";
    } else {
      return "https://beta-app.cvetovik.com/";
    }
  }

  final int successCode = 200;

  Uri getUrl(String path) {
    var url = "${getBaseUtl()}$path";
    return Uri.parse(url);
  }

  Future<Response> getPostResponse(String strUrl,
      {DeviceRegister? deviceRegister,
      Object? body,
      required LocalClientInfo clientInfo,
      bool jsonBody = false,
      String cookie = ''}) async {
    Map<String, String>? headers;
    if (deviceRegister != null) {
      headers = deviceRegister.toJson();
      if (jsonBody) {
        headers.putIfAbsent(
          'Content-Type',
          () => 'application/json',
        );
      }
      if (cookie.isNotEmpty) {
        headers.putIfAbsent(
          'Cookie',
          () => cookie,
        );
      }

      if (clientInfo.clientToken != null) {
        var clientHeader = clientInfo.toJson().cast<String, String>();
        clientHeader.forEach((key, value) {
          headers!.putIfAbsent(
            key,
            () => value,
          );
        });
      }
    }
    var url = getUrl(strUrl);
    var client = HttpClientBase(http.Client());
    try {
      var response = await client.post(url, headers: headers, body: body);
      print("!response code: ${response.statusCode}");
      print("!response reason: ${response.reasonPhrase}");
      print("!response url: ${response.request!.url}");
      print("!response body: ${response.body}");

      return response;
    } finally {
      client.close();
    }
  }

  T _getResult<T extends AppBaseResponse>(
    Response response,
    T convert(dynamic e),
  ) {
    if (!kReleaseMode) {
      var strBody = utf8.decode(response.bodyBytes);
      print('----- Response ------');
      log("str body ${strBody}");
    }
    final raw = json.decode(utf8.decode(response.bodyBytes));
    var result = convert(raw);
    return result;
  }

  T getResult<T extends AppBaseResponse>(
      Response response, InstanceFromJson resultOk, T resultError) {
    try {
      if (response.statusCode == successCode) {
        var raw = _getResult<T>(response, (e) => resultOk(e));
        return raw;
      } else
        return resultError;
    } catch (e) {
      return resultError;
    }
  }
}
