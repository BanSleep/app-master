import 'dart:convert';

import 'package:cvetovik/core/api/api_base.dart';
import 'package:cvetovik/models/api/request/comment_request.dart';
import 'package:cvetovik/models/api/request/filter_request.dart';
import 'package:cvetovik/models/api/request/search_param_request.dart';
import 'package:cvetovik/models/api/response/filter_reponse.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/shared/simple_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'http_client_base.dart';

final productApiProvider = Provider<ProductApi>((ref) => ProductApi());

class ProductApi extends ApiBase {
  Future<String?> getCatalogInfo({
    required int catalogId,
    required DeviceRegisterAdd deviceRegister,
  }) async {
    try {
      var headers = deviceRegister.toJson();
      String path = 'catalogs/info/$catalogId/';
      var url = getUrl(path);

      var client = HttpClientBase(http.Client());
      try {
        var response = await client.post(
          url,
          headers: headers,
        );
        print(response.request!.url.toString() + 'bannerUrl');
        print(response.body.toString() + 'bannerBody');
        if (response.statusCode == successCode) {
          var data = json.decode(utf8.decode(response.bodyBytes));
          if (data['result'] != null && data['result'] as bool) {
            return data['data']['info_text'].toString();
          } else {
            return null;
          }
        } else {
          return null;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProductsResponse> getProducts(
      {required DeviceRegisterAdd deviceRegister,
      required int parentId,
      FilterRequest? filter}) async {
    try {
      var headers = deviceRegister.toJson();
      String path = 'products/list_catalog/$parentId/';
      var url = getUrl(path);
      Object? body;
      if (filter != null) {
        headers.putIfAbsent(
          'Content-Type',
          () => 'application/json',
        );
        body = json.encode(filter.toJson());
      }
      var client = HttpClientBase(http.Client());
      try {
        var response = await client.post(url, headers: headers, body: body);
        if (response.statusCode == successCode) {
          var data = json.decode(utf8.decode(response.bodyBytes));
          var res = ProductsResponse.fromJson(data);
          return res;
        } else {
          return ProductsResponse(result: false);
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print(e);
      return ProductsResponse(result: false);
    }
  }

  Future<ProductsResponse> searchProducts(
    String text,
    DeviceRegisterAdd deviceRegister,
    SortData? sortData,
    LocalClientInfo clientInfo,
  ) async {
    String path = 'products/search/';
    if (sortData == null) {
      sortData = SortData(direction: 'down', field: 'popularity');
    }
    var param = SearchParamRequest(searchText: text, sort: sortData);
    var body = json.encode(param.toJson());
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      body: body,
      jsonBody: true,
      clientInfo: clientInfo,
    );
    var result = getResult<ProductsResponse>(response,
        (e) => ProductsResponse.fromJson(e), ProductsResponse(result: false));
    return result;
  }

  Future<bool> addComment(
    CommentRequest comment,
    DeviceRegisterAdd deviceRegister,
    int productId,
    LocalClientInfo clientInfo,
  ) async {
    String path = 'products/add_comment/$productId/';
    var jsonComment = jsonEncode(comment);
    var response = await getPostResponse(path,
        clientInfo: clientInfo,
        deviceRegister: deviceRegister,
        body: jsonComment,
        jsonBody: true);
    var result = getResult<SimpleResponse>(response,
        (e) => SimpleResponse.fromJson(e), SimpleResponse(result: false));
    return result.result;
  }

  Future<FilterResponse> getFilters(
    DeviceRegisterAdd deviceRegister,
    int catalogId,
    LocalClientInfo clientInfo,
  ) async {
    try {
      String path = 'catalogs/filters/$catalogId/';
      var response = await getPostResponse(
        path,
        deviceRegister: deviceRegister,
        clientInfo: clientInfo,
      );
      var result = getResult<FilterResponse>(response,
          (e) => FilterResponse.fromJson(e), FilterResponse(result: false));
      return result;
    } catch (e) {
      print(e);
      return FilterResponse(result: false);
    }
  }
}
