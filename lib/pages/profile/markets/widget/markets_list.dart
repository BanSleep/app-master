import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/models/provider/region_shop_data.dart';
import 'package:cvetovik/pages/profile/markets/widget/market_list_item.dart';
import 'package:flutter/cupertino.dart';

class MarketsList extends StatelessWidget {
  final List<RegionShopInfo> list;

  const MarketsList({required this.list, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => list.isEmpty
      ? Center(
          child: Text(
            'Магазинов здесь не найдено',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black),
          ),
        )
      : Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 120, bottom: 150),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (c, index) => SizedBox(
              height: 12,
            ),
            padding: EdgeInsets.zero,
            itemBuilder: (c, index) => MarketListItem(
              region: list[index],
            ),
            itemCount: list.length,
          ),
        );
}
