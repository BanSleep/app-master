import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/models/api/shared/device_register_add.dart';
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
  @override
  void initState() {
    print(widget.deliveryInfo.zones!['default']!.zone1);
    List<List<double>> firstZone =
        parseStringToList(widget.deliveryInfo.zones!['default']!.zone1!);
    List<List<double>> secondZone =
        parseStringToList(widget.deliveryInfo.zones!['default']!.zone2 ?? '');

    for (int i = 0; i < 2; i++) {
      mapObjects.add(PolygonMapObject(
        fillColor: i == 0 ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
          strokeColor: i == 0 ? Colors.green.withOpacity(0.5) : Colors.blue.withOpacity(0.5),
          mapId: MapObjectId('zone$i'),
          polygon: Polygon(
              outerRing: LinearRing(
                points: [
                  for (int j = 0; i == 0 ? j < firstZone.length : j < secondZone.length; j++) ...[
                    Point(latitude: i == 0 ? firstZone[j][0] : secondZone[j][0], longitude: i == 0 ? firstZone[j][1] : secondZone[j][1])
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
                          mapCenter.add(double.parse(widget.deliveryInfo.mapCenter.split(',').first));
                          mapCenter.add(double.parse(widget.deliveryInfo.mapCenter.split(',').last));
                          await _controller.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: Point(longitude: mapCenter[1], latitude: mapCenter[0]),
                                  zoom: 8)));
                        },
                      )),
                ),
                12.h.heightBox,
                SizedBox(
                  height: 128.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 128.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          border: index == 0
                              ? Border.all(
                                  color: AppAllColors.lightDarkGrey,
                                  width: 2,
                                )
                              : null,
                          color: index != 0
                              ? AppAllColors.lightGreenBackground
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
                                  : 'Зона доставки №1',
                              style: AppTextStyles.textMedium.copyWith(
                                color: index == 1
                                    ? AppAllColors.lightAccent
                                    : null,
                              ),
                            ),
                            12.h.heightBox,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(index == 0
                                    ? AppIcons.dollar
                                    : AppIcons.sun),
                                const Spacer(),
                                SizedBox(
                                  width: 135.w,
                                  child: Text(
                                    index == 0
                                        ? 'Доставка осуществляется при сумме заказа более 1000 ₽'
                                        : 'В дневное время с 9:00 до 21:00 — 350 ₽',
                                    style: AppTextStyles.descriptionMedium
                                        .copyWith(
                                      color: index == 1
                                          ? AppAllColors.lightAccent
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            12.h.heightBox,
                            Row(
                              children: [
                                SvgPicture.asset(
                                    index == 0 ? AppIcons.time : AppIcons.moon),
                                const Spacer(),
                                SizedBox(
                                  width: 135.w,
                                  child: Text(
                                    index == 0
                                        ? 'Доставка к точному времени — 700 ₽ (только для зоны №1)'
                                        : 'В ночное время с 21:00 до 9:00 - 350руб. + 35руб. за каждый километр от зоны доставки №1',
                                    style: AppTextStyles.descriptionMedium
                                        .copyWith(
                                      color: index == 1
                                          ? AppAllColors.lightAccent
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            12.h.heightBox,
                          ],
                        ).paddingSymmetric(horizontal: 20.w),
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
