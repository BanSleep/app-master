import 'package:cvetovik/models/api/response/order/geocoder_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'http_client_base.dart';

final yandexGeocoderApiProvider = Provider<YandexGeocoderApi>((ref) {
  return YandexGeocoderApi();
});

class YandexGeocoderApi {
  Future<String?> getAddressFromPoint(String point) async {
    var entity = await _getEntity(point);
    if (entity != null) {
      return entity.geoObject.name;
    }
    return null;
  }

  Future<Point?> getPointFromAddress(String address) async {
    var entity = await _getEntity(address);
    if (entity != null) {
      final data = entity.geoObject.point.pos.split(' ');
      return Point(
          latitude: double.parse(data[1]), longitude: double.parse(data[0]));
    }
    return null;
  }

  Future<FeatureMember?> _getEntity(String value) async {
    try {
      final endpointUrl = 'https://geocode-maps.yandex.ru/1.x/';
      Map<String, String> queryParams = {
        "apikey": "e18a6ce2-6b89-4326-8711-ad272164d9b8",
        "format": "json",
        "geocode": "$value",
        "results": "1",
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var requestUrl = endpointUrl + '?' + queryString;

      var url = Uri.parse(requestUrl);
      var client = HttpClientBase(http.Client());
      try {
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var res = geocoderResponseFromJson(response.body);
          if (res.response.geoObjectCollection.featureMember.length > 0) {
            FeatureMember? curr =
                res.response.geoObjectCollection.featureMember.first;
            return curr;
          }
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
