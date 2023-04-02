import 'package:cvetovik/models/api/response/region/region_shops_response.dart';

class RegionShopData {
  final String regionId;
  final List<RegionShopInfo> items;

  RegionShopData(this.regionId, this.items);
}
