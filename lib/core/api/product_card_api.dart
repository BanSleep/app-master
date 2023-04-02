import 'package:cvetovik/models/api/response/comments_response.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
import 'package:cvetovik/models/api/shared/local_client_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_base.dart';

final productCardApiProvider =
    Provider<ProductCardApi>((ref) => ProductCardApi());

class ProductCardApi extends ApiBase {
  Future<ProductCardResponse> getProductCard({
    required DeviceRegisterAdd deviceRegister,
    required int id,
    required LocalClientInfo clientInfo,
  }) async {
    try {
      String path = 'products/view/$id/';
      var response = await getPostResponse(
        path,
        deviceRegister: deviceRegister,
        clientInfo: clientInfo,
      );
      var result = getResult<ProductCardResponse>(
          response,
          (e) => ProductCardResponse.fromJson(e),
          ProductCardResponse(result: false));
      return result;
    } catch (e) {
      print(e);
      return ProductCardResponse(result: false);
    }
  }

  Future<CommentData?> getComments({
    required DeviceRegisterAdd deviceRegister,
    required int id,
    required LocalClientInfo clientInfo,
  }) async {
    String path = 'products/comments/$id/';
    var response = await getPostResponse(
      path,
      deviceRegister: deviceRegister,
      clientInfo: clientInfo,
    );
    var result = getResult<CommentsResponse>(response,
        (e) => CommentsResponse.fromJson(e), CommentsResponse(result: false));
    if (result.result &&
        result.data != null &&
        result.data!.comments != null &&
        result.data!.comments!.length > 0) {
      return result.data;
    } else
      return null;
  }
}
