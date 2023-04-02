import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:cvetovik/pages/profile/markets/widget/market_info_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketListItem extends StatelessWidget {
  final RegionShopInfo region;

  const MarketListItem({required this.region, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          showMarketInfoBottomSheet(context, region);
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        region.title,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      Text(
                        region.address,maxLines: 2,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: AppAllColors.lightDarkGrey),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                RotatedBox(
                    quarterTurns: 2,
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIcons.iArrowLeft,
                        width: 24,
                        height: 24,
                        color: AppColors.primary,
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
}
