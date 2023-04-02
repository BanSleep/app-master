import 'dart:convert';

import 'package:cvetovik/models/api/request/dadata_request.dart';
import 'package:cvetovik/models/api/response/order/dadata_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'http_client_base.dart';

final dadataApiProvider = Provider<DadataApi>((ref) {
  return DadataApi();
});

class DadataApi {
  static const _suggestionsAPIURL =
      "https://suggestions.dadata.ru/suggestions/api/4_1/rs/";
  static const addressEndpoint = "${_suggestionsAPIURL}suggest/address";

  Future<DadataResponse?> getSuggestion(String query) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Token 4b1baf9daa67e296f79cfe70d5aea6c937eeb112",
        "Content-Type": "application/json",
      };
      //TODO get it from api
      List<DadataLocation> locations = [
        //DadataLocation(kladrId: '78 000 000 000 00')
      ];
      var data = DadataRequest(query: query, locations: locations);

      var url = Uri.parse(addressEndpoint);

      var client = HttpClientBase(http.Client());
      try {
        final response = await client.post(
          url,
          headers: headers,
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          var res = DadataResponse.fromJson(jsonDecode(response.body));
          return res;
        }
      } finally {
        client.close();
      }
    } catch (ex) {
      print(ex);
    }
    return null;
  }
}
