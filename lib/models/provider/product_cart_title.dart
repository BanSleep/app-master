import 'package:cvetovik/models/api/response/product_card_response.dart';

class ProductCartTitle {
  ProductCartTitle(
      {this.actionTitle = '',
      this.addTitle = '',
      this.mainTitle = '',
      this.count = 1,
      this.versionTitle = '',
      this.versions,
      this.price = 0});

  String actionTitle;
  String mainTitle;
  String addTitle;
  int count;
  String versionTitle;
  List<Version>? versions;
  int price;

  void init(
      {String title = '',
      String addTitle = '',
      String mainTitle = '',
      int count = 1,
      String versionTitle = ''}) {
    this.actionTitle = title;
    this.count = count;
    this.mainTitle = mainTitle;
    this.versionTitle = versionTitle;
    this.versions = null;
  }

  ProductCartTitle copyWith(
      {String? actionTitle,
      String? addTitle,
      String? mainTitle,
      int? count,
      String? versionTitle,
      List<Version>? versions,
      int? price}) {
    return ProductCartTitle(
        actionTitle: (actionTitle != null) ? actionTitle : this.actionTitle,
        addTitle: (addTitle != null) ? addTitle : this.addTitle,
        mainTitle: (mainTitle != null) ? mainTitle : this.mainTitle,
        count: (count != null) ? count : this.count,
        versionTitle: (versionTitle != null) ? versionTitle : this.versionTitle,
        versions: (versions != null) ? versions : this.versions,
        price: (price != null) ? price : this.price);
  }
}
