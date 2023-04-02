import 'package:cvetovik/core/db/app_database.dart';

class RowProviderData {
  final CartMainData main;
  final List<CartAddData>? add;

  RowProviderData(this.main, this.add);
}
