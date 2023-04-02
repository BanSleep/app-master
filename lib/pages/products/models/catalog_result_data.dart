import 'package:cvetovik/models/api/response/product_response.dart';

class CatalogResultData {
  final int id;
  List<ProductData> data;

  CatalogResultData({required this.id, required this.data});
}
