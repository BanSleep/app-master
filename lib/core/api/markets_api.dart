import 'dart:convert';
import 'dart:developer';

import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/request/promo_code_request.dart';
import 'package:cvetovik/models/api/response/cabinet/activate_bonus_card_response.dart';
import 'package:cvetovik/models/api/response/cabinet/check_code_response.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/models/api/response/cabinet/edit_profile_response.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_address_list_response.dart';
import 'package:cvetovik/models/api/response/cabinet/payment_widget_response.dart';
import 'package:cvetovik/models/api/response/cabinet/promo_code_response.dart';
import 'package:cvetovik/models/api/response/cabinet/favorite_date_list_response.dart';
import 'package:cvetovik/models/api/response/order/order_list_response.dart';
import 'package:cvetovik/models/api/response/order/order_response.dart';
import 'package:cvetovik/models/api/response/order/order_view_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/api/response/shared/simple_response.dart';
import 'package:cvetovik/models/api/shared/device_register.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_base.dart';

typedef OnSaveCookie = Future<void> Function(String cookie);

final marketsApi = Provider<MarketsApi>((ref) => MarketsApi());

class MarketsApi extends ApiBase {
  final String cookieName = 'set-cookie';

  Future<List<RegionModel>> getRegions(
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "regions/list/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );

    var data = json.decode(utf8.decode(response.bodyBytes));
    print(data.toString() + 'regions141');

    if (data['result'] != null && data['result'] as bool) {
      var list = data['data'] as Map<String, dynamic>;
      var ourList = list.values.map((e) => RegionModel.fromJson(e)).toList();

      return ourList;
    } else {
      return [];
    }
  }

  Future<String> getInfoText(
      DeviceRegister deviceRegister, LocalClientInfo localInfo,
      {required String pageName}) async {
    String path = "pages/get/$pageName/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );

    var data = json.decode(utf8.decode(response.bodyBytes));
    print(data.toString() + 'regions141');

    if (data['result'] != null && data['result'] as bool) {
      return data['data']['text'];
    } else {
      return '';
    }
  }
}
