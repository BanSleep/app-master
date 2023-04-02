import 'dart:convert';

import 'package:cvetovik/core/api/api_base.dart';
import 'package:cvetovik/core/api/http_client_base.dart';
import 'package:cvetovik/models/api/response/catalog_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final catalogApiProvider = Provider<CatalogApi>((ref) => CatalogApi());

class CatalogApi extends ApiBase {
  Future<CatalogResponse> getCatalogs(
      DeviceRegisterAdd deviceRegister, int parentId) async {
    /*String path = 'catalogs/list/$parentId/';
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
    );
    var result = getResult<CatalogResponse>(response,
        (e) => CatalogResponse.fromJson(e), CatalogResponse(result: false));
    return result;*/
    var headers = deviceRegister.toJson();
    String path = 'catalogs/list/$parentId/';
    var url = getUrl(path);
    var client = HttpClientBase(http.Client());
    try {
      var response = await client.post(url, headers: headers);
      if (response.statusCode == successCode) {
        var str = utf8.decode(response.bodyBytes);
        var data = json.decode(str);
        try {
          var res = CatalogResponse.fromJson(data);
          return res;
        } catch (e) {
          return CatalogResponse(result: true);
        }
      } else {
        return CatalogResponse(result: false);
      }
    } finally {
      client.close();
    }
  }

  Future<Map<String, LinkedProduct>?> getLinkedProducts(
    int id,
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
  ) async {
    String path = 'catalogs/linked_products/$id/';
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: clientInfo,
    );
    var result = getResult<LinkedProductsResponse>(
        response,
        (e) => LinkedProductsResponse.fromJson(e),
        LinkedProductsResponse(result: false));
    if (result.result)
      return result.data;
    else
      return null;
  }

  Future<Map<String, LinkedDecor>?> getLinkedDecors(
    int id,
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
  ) async {
    String path = 'catalogs/linked_decors/$id/';
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: clientInfo,
    );
    var result = getResult<LinkedDecorsResponse>(
        response,
        (e) => LinkedDecorsResponse.fromJson(e),
        LinkedDecorsResponse(result: false));
    if (result.result)
      return result.data;
    else
      return null;
  }
}
