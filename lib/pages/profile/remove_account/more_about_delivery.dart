import 'dart:developer';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/profile/delivery_info/delivery_info.dart';
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

  static const List<String> titles = [
    'Доставка в пригород по ценам города',
    'Доставка антивирус+',
    'Условия самовывоза из розничных магазинов',
    'Условия и стоимость доставки',
    'Повторная доставка',
  ];
  static const List<String> text = [
    'Доставка в пригородные районы, обычно стоит дороже, чем по городу? Мы решили это исправить и сделали специальные условия доставки в пригород!',
    'Мы понимаем, что не можем оставаться в стороне и игнорировать сложившуюся ситуацию в стране. Сейчас особенно важно заботиться о собственном здоровье и здоровье своих близких.',
    'Если Вы выбрали букет или композицию в нашем розничном магазине, Вы можете заказать услугу доставки. ',
    'При оформлении заказа в розничных магазинах. Если Вы выбрали букет или композицию в нашем розничном магазине, Вы можете заказать услугу доставки.  ',
    'Если в заказе был указан неверный адрес или другие данные, а также если получатель отсутствует по указанному адресу или отказывается принять товар, по какой бы то ни было причине, заказ считается выполненным. ',
  ];

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
                  height: 152.h,
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
                              ? zonesColor[index - 1].withOpacity(0.1 )
                              : null,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            12.h.heightBox,
                            Text(
                              index == 0
                                  ? 'Общие положения'
                                  : 'Зона доставки №${index}',
                              style: AppTextStyles.textMedium.copyWith(
                                color: index != 0
                                    ? zonesColor[index - 1]
                                    : null,
                              ),
                            ),
                            12.h.heightBox,
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
                                      color: index != 0
                                          ? zonesColor[index - 1]
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            12.h.heightBox,
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
                                        color: index != 0
                                            ? zonesColor[index - 1]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            12.h.heightBox,
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Cont(index).paddingOnly(bottom: 12);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget Cont(int index) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff0000000F),
            offset: Offset(0, 4),
            blurRadius: 15,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MoreAboutDelivery.titles[index],
            style: AppTextStyles.descriptionMedium10
                .copyWith(color: AppAllColors.black),
          ),
          7.w.heightBox,
          Row(
            children: [
              SizedBox(
                width: 215.w,
                child: Text(
                  MoreAboutDelivery.text[index],
                  style: AppTextStyles.descriptionMedium
                      .copyWith(color: AppAllColors.lightBlack),
                ),
              ),
              const Spacer(),
              SvgPicture.asset(AppIcons.arrow_down),
            ],
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 9.w);
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

// void parseZonesDeliveryInformation(List<TimeRangeData> timeRanges) {
//   List<String> resultStrings = [];
//
//   /// Создаем Map для хранения уникальных значений price
//   final List<Map<int, List<int>>> priceMap = [];
//
//   /// Заполняем Map
//   int oldPrice = timeRanges.first.price;
//   int startHour = timeRanges.first.startHour;
//   int stopHour = timeRanges.first.stopHour;
//   List<int> freeFromIndex = [];
//
//   for (int i = 0; i < timeRanges.length; i++) {
//     final price = timeRanges[i].price;
//     if (i == timeRanges.length - 1) {
//       priceMap.add({
//         price: [startHour, timeRanges[i].stopHour]
//       });
//       freeFromIndex.add(timeRanges[i].freeFrom);
//     }
//     if (price != oldPrice) {
//       stopHour = timeRanges[i - 1].stopHour;
//       priceMap.add({
//         oldPrice: [startHour, stopHour]
//       });
//       freeFromIndex.add(timeRanges[i - 1].freeFrom);
//       startHour = timeRanges[i].startHour;
//     }
//     oldPrice = price;
//   }
//
//   log(freeFromIndex.toString());
//
//   for (int i = 0; i < priceMap.length; i++) {
//     final key = priceMap[i].keys.toList().first;
//     String startHour = '';
//     String stopHour = '';
//     String price = '';
//
//     ///Парсинг startHour в строку
//     if (priceMap[i][key]!.first.toString().length == 1) {
//       startHour = '0${priceMap[i][key]!.first.toString()}:00';
//     } else {
//       startHour = '${priceMap[i][key]!.first.toString()}:00';
//     }
//
//     ///Парсинг stopHour в строку
//     if (priceMap[i][key]!.last.toString().length == 1) {
//       stopHour = '0${priceMap[i][key]!.last.toString()}:00';
//     } else {
//       stopHour = '${priceMap[i][key]!.last.toString()}:00';
//     }
//
//     ///парсинг времени суток
//     List<String> timesOfDay = [];
//     timesOfDay.add(getTimeOfDay(priceMap[i][key]!.first));
//     timesOfDay.add(getTimeOfDay(priceMap[i][key]!.last - 1));
//     if (timesOfDay[0] == 'утреннее' && timesOfDay[1] == 'ночное'){
//       timesOfDay.last = 'дневное';
//       timesOfDay.add('вечернее');
//       timesOfDay.add('ночное');
//     }
//     if (timesOfDay[0] == 'утреннее' && timesOfDay[1] == 'вечернее'){
//       timesOfDay.last = 'дневное';
//       timesOfDay.add('вечернее');
//     }
//     if (timesOfDay[0] == 'дневное' && timesOfDay[1] == 'ночное'){
//       timesOfDay.last = 'вечернее';
//       timesOfDay.add('ночное');
//     }
//     if (timesOfDay[0] == timesOfDay[1]){
//       timesOfDay.removeAt(1);
//     }
//
//     ///Парсинг price в строку
//     price = priceMap[i]
//         .keys
//         .toString()
//         .substring(1, priceMap[i].keys.toString().length - 1);
//
//     ///Парсинг итоговой строки
//     String str = 'В ';
//     for (int idx = 0; idx < timesOfDay.length; idx++) {
//       if (idx == timesOfDay.length - 1){
//         str += timesOfDay[idx];
//       }
//       else{
//         str += timesOfDay[idx] + ', ';
//       }
//     }
//     str = str + ' время суток с $startHour до $stopHour - $priceруб.';
//
//     ///добавление к итоговой строке бесплатную доставку
//     if (freeFromIndex[i] > 0) {
//       str += ', а при заказе от ${freeFromIndex[i]}руб. - бесплатно';
//     }
//     resultStrings.add(str);
//   }
//
//   log(resultStrings.toString());
// }
//
// String getTimeOfDay(int hour) {
//   if (hour >= 6 && hour < 12) {
//     return 'утреннее';
//   } else if (hour >= 12 && hour < 18) {
//     return 'дневное';
//   } else if (hour >= 18 && hour < 24) {
//     return 'вечернее';
//   } else if (hour >= 0 && hour < 6){
//     return 'ночное';
//   }
//   return '';
// }
