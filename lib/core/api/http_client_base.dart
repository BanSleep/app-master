import 'package:cvetovik/const/app_const.dart';
import 'package:http/http.dart' as http;

class HttpClientBase extends http.BaseClient {
  final http.Client _client;
  HttpClientBase(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['User-Agent'] = AppConst.uAgent;
    return _client.send(request);
  }
}
