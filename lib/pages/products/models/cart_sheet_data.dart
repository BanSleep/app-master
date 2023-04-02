import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';

class CartSheetData {
  final List<CartAddData>? selectedAddItems;
  final Map<String, LinkedDecor>? linkedDecors;
  final int currPrice;
  CartSheetData(this.selectedAddItems, this.linkedDecors, this.currPrice);
}
