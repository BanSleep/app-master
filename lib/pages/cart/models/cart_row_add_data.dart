import 'package:cvetovik/core/db/app_database.dart';

class CartRowAddData {
  final List<CartAddData>? add;
  final List<FavoriteData>? favs;

  CartRowAddData(this.add, this.favs);
}
