import 'dart:convert';

import 'package:cvetovik/core/api/api_base.dart';
import 'package:cvetovik/core/api/http_client_base.dart';
import 'package:cvetovik/models/api/response/token_response.dart';
import 'package:cvetovik/models/api/response/token_result.dart';
import 'package:cvetovik/models/app/app_device_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final registerApiProvider = Provider<RegisterApi>((ref) => RegisterApi());

class RegisterApi extends ApiBase {
  Future<TokenResult> getTokenFromApi(AppDeviceInfo info) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };
      var url = getUrl('device/registration/');
      var body = json.encode(info.toJson());
      var client = HttpClientBase(http.Client());
      try {
        var response = await client.post(url, body: body, headers: headers);
        if (response.statusCode == successCode) {
          var body = response.body;
          var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
          TokenResponse data = TokenResponse.fromJson(jsonResponse);
          return TokenResult(token: data.data.token, id: data.data.id);
        } else {
          return TokenResult(error: response.reasonPhrase);
        }
      } finally {
        client.close();
      }
    } catch (e) {
      return TokenResult(error: e.toString());
    }
  }
}
