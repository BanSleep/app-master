import 'dart:convert';
import 'dart:developer';

import 'package:cvetovik/core/api/api_base.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/models/api/shared/device_register.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeApiProvider = Provider<HomeApi>((ref) => HomeApi());

class HomeApi extends ApiBase {
  Future<RegionResponse> getRegions(
    DeviceRegister deviceRegister,
    LocalClientInfo clientInfo,
  ) async {
    var response = await getPostResponse(
      'regions/list/',
      deviceRegister: deviceRegister,
      clientInfo: clientInfo,
    );
    var result = getResult<RegionResponse>(
        response,
        (e) => RegionResponse.fromJson(e),
        RegionResponse(result: false, data: {}));
    return result;
  }

  Future<RegionInfoResponse> getRegionInfo(
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
  ) async {
    try{
      String path = 'regions/info/${deviceRegister.regionId}/';
      var response = await getPostResponse(
        path,
        deviceRegister: deviceRegister,
        clientInfo: clientInfo,
      );
      try{
        var result = getResult<RegionInfoResponse>(
            response,
                (e) {

              return RegionInfoResponse.fromJson(e);
            },
            RegionInfoResponse(result: false));
print(result.data!.toString()+'actual141');
        return result;
      }catch(e){
        print(e.toString()+'actual142');
        throw Exception();
      }


    }catch(e){
      print(e.toString()+'ero2');
      throw Exception();
    }

  }

  Future<DeliveryInfoResponse> getDeliveryInfo(
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
  ) async {
    print("DEVIDE ${deviceRegister.regionId}");
    String path = 'regions/delivery_info/${deviceRegister.regionId}/';
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: clientInfo,
    );
    log("result: ${response.body}"); // тут еще есть даты
    var result = getResult<DeliveryInfoResponse>(
        // в этой строчке мы теряем даты и отходим к default
        response,
        (e) => DeliveryInfoResponse.fromJson(e),
        DeliveryInfoResponse(result: false));
    // тут уже взят default
    return result;
  }

  Future<RegionShopsResponse> getRegionShops(
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
  {int? regionId}
  ) async {
    var id = regionId!=null?regionId:deviceRegister.regionId;

    String path = 'regions/shops_list/$id/';
    var response = await getPostResponse(path,
        deviceRegister: deviceRegister, clientInfo: clientInfo);

    var data = json.decode(utf8.decode(response.bodyBytes));
    print(data.toString()+'shops141');

    var result = getResult<RegionShopsResponse>(
        response,
        (e) => RegionShopsResponse.fromJson(e),
        RegionShopsResponse(result: false));
    return result;
  }
}
