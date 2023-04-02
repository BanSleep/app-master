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
import 'package:cvetovik/models/api/response/shared/simple_response.dart';
import 'package:cvetovik/models/api/shared/device_register.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_base.dart';

typedef OnSaveCookie = Future<void> Function(String cookie);

final cabinetApiProvider = Provider<CabinetApi>((ref) => CabinetApi());

class CabinetApi extends ApiBase {
  final String cookieName = 'set-cookie';

  Future<SimpleResponse> sendSms(
    String phone,
    DeviceRegisterAdd deviceRegister,
    OnSaveCookie saveCookie,
  ) async {
    String path = 'cabinet/authorization/send_sms/';
    var body = jsonEncode(<String, String>{
      'phone': phone,
    });

    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      body: body,
      jsonBody: true,
      clientInfo: LocalClientInfo(null, null),
    );

    String? cookie = response.headers[cookieName];
    if (cookie != null) {
      await saveCookie(cookie);
    }
    var result = getResult<SimpleResponse>(response,
        (e) => SimpleResponse.fromJson(e), SimpleResponse(result: false));
    return result;
  }

  Future<CheckCodeResponse> checkCode(String phone, String code,
      DeviceRegisterAdd deviceRegister, String cookie) async {
    String path = 'cabinet/authorization/check_code/';
    var body = jsonEncode(<String, String>{'phone': phone, 'code': code});
    // log("cabinet/authorization/check_code/ $body");
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      body: body,
      jsonBody: true,
      cookie: cookie,
      clientInfo: LocalClientInfo(null, null),
    );
    var result = getResult<CheckCodeResponse>(response,
        (e) => CheckCodeResponse.fromJson(e), CheckCodeResponse(result: false));
    log("cabinet/authorization/check_code/ new user: ${result.data?.newUser}");
    return result;
  }

  Future<SimpleResponse> sendSmsRemoveAccount(
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
    OnSaveCookie saveCookie,
  ) async {
    String path = 'cabinet/profile/delete/check/';

    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      jsonBody: true,
      clientInfo: clientInfo,
    );

    String? cookie = response.headers[cookieName];
    if (cookie != null) {
      await saveCookie(cookie);
    }

    var result = getResult<SimpleResponse>(response,
        (e) => SimpleResponse.fromJson(e), SimpleResponse(result: false));
    return result;
  }

  Future<CheckCodeResponse> checkCodeRemoveAccount(
    String code,
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo clientInfo,
    String cookie,
  ) async {
    String path = 'cabinet/profile/delete/confirm/';
    var body = jsonEncode(<String, String>{'code': code});
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      body: body,
      jsonBody: true,
      clientInfo: clientInfo,
      cookie: cookie,
    );
    var result = getResult<CheckCodeResponse>(response,
        (e) => CheckCodeResponse.fromJson(e), CheckCodeResponse(result: false));
    return result;
  }

  Future<int> newOrder(
    DeviceRegisterAdd deviceRegister,
    LocalClientInfo localInfo,
    OrderRequest body,
  ) async {
    print("new order request accessed! ${body.deliveryAddressAdditional}");
    print("${body.paymentMethod} paymentType");
    String path = 'cabinet/new_order/';
    var jsonBody = jsonEncode(body);
    var response = await getPostResponse(path,
        deviceRegister: deviceRegister,
        clientInfo: localInfo,
        body: jsonBody,
        jsonBody: true);
    var result = getResult<OrderResponse>(response,
        (e) => OrderResponse.fromJson(e), OrderResponse(result: false));
    return (result.data != null) ? result.data!.orderId : 0;
  }

  Future<PromoCodeResponse> checkPromoCode(
    DeviceRegisterAdd deviceRegister,
    PromoCodeRequest body,
    LocalClientInfo clientInfo,
  ) async {
    String path = 'cabinet/check_promocode/';
    var jsonBody = jsonEncode(body);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      body: jsonBody,
      jsonBody: true,
      clientInfo: clientInfo,
    );
    var result = getResult<PromoCodeResponse>(response,
        (e) => PromoCodeResponse.fromJson(e), PromoCodeResponse(result: false));
    return result;
  }

  Future<ClientInfoResponse> getClientInfo(
      DeviceRegister deviceRegister, LocalClientInfo localInfo) async {
    String path = 'cabinet/info/';
    var response = await getPostResponse(path,
        deviceRegister: deviceRegister, clientInfo: localInfo);
    var result = getResult<ClientInfoResponse>(
        response,
        (e) => ClientInfoResponse.fromJson(e),
        ClientInfoResponse(result: false));
    return result;
  }

  Future<String> getPayWidget(int orderId, DeviceRegister deviceRegister,
      LocalClientInfo localInfo) async {
    String path = 'cabinet/pay_order/$orderId/';
    var response = await getPostResponse(path,
        deviceRegister: deviceRegister, clientInfo: localInfo);
    var result = getResult<PaymentWidgetResponse>(
        response,
        (e) => PaymentWidgetResponse.fromJson(e),
        PaymentWidgetResponse(result: false));
    return result.result ? result.data!.widget : '';
  }

  Future<EditProfileResponse> editProfile(EditProfileModel data,
      DeviceRegister deviceRegister, LocalClientInfo localInfo) async {
    String path = "cabinet/profile/edit/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    // print("cabinet profile edit: response ${response.}");
    var result = getResult<EditProfileResponse>(
      response,
      (e) => EditProfileResponse.fromJson(e),
      EditProfileResponse(result: false),
    );
    return result;
  }

  Future<ActivateBonusCardResponse> activateBonusCard(
      ActivateBonusCardModel data,
      DeviceRegister deviceRegister,
      LocalClientInfo localInfo) async {
    String path = "cabinet/activate_bonus_card/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    // print("cabinet profile edit: response ${response.}");
    var result = getResult<ActivateBonusCardResponse>(
      response,
      (e) => ActivateBonusCardResponse.fromJson(e),
      ActivateBonusCardResponse(result: false),
    );
    return result;
  }

  Future<OrderListResponse> getOrders(
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/orders/list/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<OrderListResponse>(
      response,
      (e) => OrderListResponse.fromJson(e),
      OrderListResponse(result: false),
    );
    return result;
  }

  Future<OrderDetailsResponse> getOrder(
    int orderId,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/orders/view/$orderId/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<OrderDetailsResponse>(
      response,
      (e) => OrderDetailsResponse.fromJson(e),
      OrderDetailsResponse(result: false),
    );
    return result;
  }

  Future<FavoriteDateListResponse> getFavoriteDates(
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/events/list/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<FavoriteDateListResponse>(
      response,
      (e) => FavoriteDateListResponse.fromJson(e),
      FavoriteDateListResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> addFavoriteDate(
    AddFavoriteDateRequest data,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/events/add/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> editFavoriteDate(
    int eventId,
    EditFavoriteDateRequest data,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/events/edit/$eventId/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> deleteFavoriteDate(
    int eventId,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/events/delete/$eventId/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }

  Future<FavoriteAddressListResponse> getFavoriteAddresses(
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/addresses/list/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<FavoriteAddressListResponse>(
      response,
      (e) => FavoriteAddressListResponse.fromJson(e),
      FavoriteAddressListResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> addFavoriteAddress(
    AddFavoriteAddressRequest data,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/addresses/add/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> editFavoriteAddress(
    int addressId,
    EditFavoriteAddressRequest data,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/addresses/edit/$addressId/";
    var body = jsonEncode(data);
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
      body: body,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }

  Future<SimpleResponse> deleteFavoriteAddress(
    int addressId,
    DeviceRegister deviceRegister,
    LocalClientInfo localInfo,
  ) async {
    String path = "cabinet/addresses/delete/$addressId/";
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: localInfo,
    );
    var result = getResult<SimpleResponse>(
      response,
      (e) => SimpleResponse.fromJson(e),
      SimpleResponse(result: false),
    );
    return result;
  }
}
