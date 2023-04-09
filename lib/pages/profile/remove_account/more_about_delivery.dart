import 'dart:developer';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/profile/delivery_info/delivery_info.dart';
import 'package:cvetovik/pages/profile/remove_account/information_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MoreAboutDelivery extends StatefulWidget {
  final DeliveryInfo deliveryInfo;

  MoreAboutDelivery({
    Key? key,
    required this.deliveryInfo,
  }) : super(key: key);

  @override
  State<MoreAboutDelivery> createState() => _MoreAboutDeliveryState();
}

class _MoreAboutDeliveryState extends State<MoreAboutDelivery> {
  late YandexMapController _controller;
  List<MapObject> mapObjects = [];
  DeliveryInfoParse deliveryInfoParse = DeliveryInfoParse();
  static const List<Color> zonesColor = [
    AppAllColors.lightAccent,
    Color.fromRGBO(96, 160, 255, 1),
    Color.fromRGBO(255, 134, 26, 1),
  ];

  @override
  void initState() {
    print(widget.deliveryInfo.zones!['default']!.zone1);
    List<List<double>> firstZone =
        parseStringToList(widget.deliveryInfo.zones!['default']!.zone1!);
    List<List<double>> secondZone =
        parseStringToList(widget.deliveryInfo.zones!['default']!.zone2 ?? '');

    for (int i = 0; i < 2; i++) {
      mapObjects.add(PolygonMapObject(
          fillColor: i == 0
              ? Colors.green.withOpacity(0.2)
              : Colors.blue.withOpacity(0.2),
          strokeColor: i == 0
              ? Colors.green.withOpacity(0.5)
              : Colors.blue.withOpacity(0.5),
          mapId: MapObjectId('zone$i'),
          polygon: Polygon(
              outerRing: LinearRing(
                points: [
                  for (int j = 0;
                      i == 0 ? j < firstZone.length : j < secondZone.length;
                      j++) ...[
                    Point(
                        latitude: i == 0 ? firstZone[j][0] : secondZone[j][0],
                        longitude: i == 0 ? firstZone[j][1] : secondZone[j][1])
                  ]
                ],
              ),
              innerRings: [])));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.h.heightBox,
        Container(
          height: 5.h,
          width: 36.w,
          decoration: BoxDecoration(
            color: AppAllColors.lightDarkGrey,
            borderRadius: BorderRadius.circular(2.5.r),
          ),
        ),
        8.h.heightBox,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                21.h.heightBox,
                Container(
                  height: 222.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15.w)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: YandexMap(
                      mapObjects: mapObjects,
                      onMapCreated: (controller) async {
                        _controller = controller;
                        List<double> mapCenter = [];
                        mapCenter.add(double.parse(
                            widget.deliveryInfo.mapCenter.split(',').first));
                        mapCenter.add(double.parse(
                            widget.deliveryInfo.mapCenter.split(',').last));
                        await _controller.moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: Point(
                                    longitude: mapCenter[1],
                                    latitude: mapCenter[0]),
                                zoom: 8)));
                      },
                    ),
                  ),
                ),
                12.h.heightBox,
                SizedBox(
                  height: 161.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      List<String> deliveryInformation = index == 0
                          ? []
                          : deliveryInfoParse.parseZonesDeliveryInformation(
                              widget.deliveryInfo.timeRanges.timeRangesDefault
                                  .where((element) => element.zone == index)
                                  .toList(),
                            );
                      return Container(
                        //height: 128.h,
                        width: 220.w,
                        decoration: BoxDecoration(
                          border: index == 0
                              ? Border.all(
                                  color: AppAllColors.lightDarkGrey,
                                  width: 2,
                                )
                              : null,
                          color: index != 0
                              ? zonesColor[index - 1].withOpacity(0.1)
                              : null,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.h.heightBox,
                            Text(
                              index == 0
                                  ? 'Общие положения'
                                  : 'Зона доставки №${index}',
                              style: AppTextStyles.textMedium.copyWith(
                                color:
                                    index != 0 ? zonesColor[index - 1] : null,
                              ),
                            ),
                            10.h.heightBox,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0) ...[
                                  SvgPicture.asset(AppIcons.dollar),
                                  const Spacer(),
                                ],
                                SizedBox(
                                  width: 160.w,
                                  child: Text(
                                    index == 0
                                        ? 'Доставка осуществляется при сумме заказа более 1000 ₽'
                                        : ' - ' + deliveryInformation[0],
                                    style: AppTextStyles.descriptionMedium
                                        .copyWith(
                                      fontSize: 9.5.sp,
                                      color: index != 0
                                          ? zonesColor[index - 1]
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.h.heightBox,
                            if (deliveryInformation.length > 1 || index == 0)
                              Row(
                                children: [
                                  if (index == 0) ...[
                                    SvgPicture.asset(AppIcons.time),
                                    const Spacer(),
                                  ],
                                  // SvgPicture.asset(
                                  //     index == 0 ? AppIcons.time : AppIcons.moon),
                                  // const Spacer(),
                                  SizedBox(
                                    width: 160.w,
                                    child: Text(
                                      index == 0
                                          ? 'Доставка к точному времени — 700 ₽ (только для зоны №1)'
                                          : ' - ' + deliveryInformation[1],
                                      style: AppTextStyles.descriptionMedium
                                          .copyWith(
                                        fontSize: 9.5.sp,
                                        color: index != 0
                                            ? zonesColor[index - 1]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            10.h.heightBox,
                            if (deliveryInformation.length > 2)
                              Row(
                                children: [
                                  if (index == 0) ...[
                                    SvgPicture.asset(AppIcons.time),
                                    const Spacer(),
                                  ],
                                  // SvgPicture.asset(
                                  //     index == 0 ? AppIcons.time : AppIcons.moon),
                                  // const Spacer(),
                                  SizedBox(
                                    width: 160.w,
                                    child: Text(
                                      ' - ' + deliveryInformation[2],
                                      style: AppTextStyles.descriptionMedium
                                          .copyWith(
                                        fontSize: 9.5.sp,
                                        color: index != 0
                                            ? zonesColor[index - 1]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            12.h.heightBox,
                          ],
                        ).paddingSymmetric(horizontal: 15.w),
                      ).paddingOnly(right: 12.w, left: 9.w);
                    },
                  ),
                ),
                12.h.heightBox,
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InformationContainer(index: index).paddingOnly(bottom: 12);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<List<double>> parseStringToList(String input) {
    List<List<double>> result = [];

    RegExp exp = RegExp(r"\[([\d\.]+),([\d\.]+)\]");
    Iterable<RegExpMatch> matches = exp.allMatches(input);
    for (RegExpMatch match in matches) {
      double lat = double.parse(match.group(1)!);
      double lon = double.parse(match.group(2)!);
      result.add([lat, lon]);
    }

    return result;
  }
}
