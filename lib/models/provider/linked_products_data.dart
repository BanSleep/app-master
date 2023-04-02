import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';

class LinkedProductData {
  final String regionId;
  final int catalogId;
  final Map<String, LinkedProduct> products;

  LinkedProductData(
      {required this.regionId,
      required this.catalogId,
      required this.products});
}
