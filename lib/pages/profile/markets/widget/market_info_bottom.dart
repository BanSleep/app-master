import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

showMarketInfoBottomSheet(BuildContext context, RegionShopInfo info) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (c) => MarketInfoBottomSheet(
            region: info,
          ),
      isScrollControlled: true,
      useRootNavigator: true);
}

class MarketInfoBottomSheet extends StatelessWidget {
  final RegionShopInfo region;

  const MarketInfoBottomSheet({required this.region, Key? key})
      : super(key: key);

  Point getPointByString(String coordinate) {
    var data = coordinate.split(",");
    print(data.toString());
    return Point(
        latitude: double.parse(data[0].toString()),
        longitude: double.parse(data[1].toString()));
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 320,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Магазин Цветовик',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: CupertinoColors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Город',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  region.title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: CupertinoColors.black),
                )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Улица',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  region.address,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: CupertinoColors.black),
                )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Часы работы',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  region.workTime,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: CupertinoColors.black),
                )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Телефон',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    region.contacts,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: CupertinoColors.black,
                        decoration: TextDecoration.underline),
                  ),
                )),
              ],
            ),
            Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async{
                var point =getPointByString(region.coordinates);
                final Uri geoLauncher = Uri(
                  scheme: 'geo',
                  path: '${point.latitude},${point.longitude}',

                );
                if (!await launchUrl(geoLauncher)) {
                throw Exception('Could not launch $geoLauncher');
                }
              },
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary),
                child: Center(
                  child: Text(
                    'Проложить маршрут',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: CupertinoColors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
