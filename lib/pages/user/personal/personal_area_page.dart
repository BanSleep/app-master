import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/helpers/reset_account_state.dart';
import 'package:cvetovik/core/services/providers/navbar_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/models/enums/app/set_key.dart';
import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/calc_delivery.dart';
import 'package:cvetovik/pages/profile/bonus_card/bonus_card_info_sheet.dart';
import 'package:cvetovik/pages/profile/bonus_card/bonus_card_utils.dart';
import 'package:cvetovik/pages/profile/bonus_card/bonus_card_widget.dart';
import 'package:cvetovik/pages/profile/calc_delivery.dart';
import 'package:cvetovik/pages/profile/delivery_counter/delivery_counter.dart';
import 'package:cvetovik/pages/profile/favorite_addresses/favorite_addresses_page.dart';
import 'package:cvetovik/pages/profile/favorite_dates/favorite_dates_page.dart';
import 'package:cvetovik/pages/profile/info/info_base_page.dart';
import 'package:cvetovik/pages/profile/markets/markets_screen.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_model.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_page.dart';
import 'package:cvetovik/pages/profile/orders/order_list/orders_preview_widget.dart';
import 'package:cvetovik/pages/profile/profile_navigation.dart';
import 'package:cvetovik/pages/profile/profile_page.dart';
import 'package:cvetovik/pages/profile/register_page.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/region/region_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PersonalAreaPage extends ConsumerStatefulWidget {
  final List<Region> items;
  final ClientData? info;

  const PersonalAreaPage({
    Key? key,
    this.info,
    required this.items,
  }) : super(key: key);

  @override
  _PersonalAreaPageState createState() => _PersonalAreaPageState();
}

class _PersonalAreaPageState extends ConsumerState<PersonalAreaPage> {
  final double radius = 16.r;
  late ClientData? relevantInfo = widget.info;

  @override
  void initState() {
    super.initState();
    if (relevantInfo == null) {
      ref.read(personalStartModelProvider).whenOrNull(
            loaded: (_, client) => relevantInfo = client.data,
          );
    }
  }

  // late ClientData? relevantInfo;

  Future<void> _pullRefresh() async {
    setState(() {
      print("Refreshed page");
      final state = ref.watch(personalStartModelProvider);
      ref.read(ordersModelProvider.notifier).reload();
      state.when(
        initializing: () {},
        loaded: (data, info) {
          relevantInfo = info.data;
        },
        error: (String? text) {
          print("on error ref");
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isBonusCard = (widget.info != null &&
        widget.info!.bonusCard != null &&
        widget.info!.bonusCard!.balance != null);

    int count = isBonusCard ? widget.info!.bonusCard!.balance! : 0;

    String numberCard = isBonusCard
        ? widget.info!.bonusCard!.number.toString()
        : 'Бонусная карта. Подробнее';
    if (numberCard.isNotEmpty && !numberCard.contains("о")) {
      numberCard = formattedNumberCard(numberCard);
    }
    String bonusCountMess = '$count ${AppRes.bonus}';

    final state = ref.watch(personalStartModelProvider);
    state.when(
      initializing: () {},
      loaded: (data, info) {
        relevantInfo = info.data;
      },
      error: (String? text) {
        print("on error ref");
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppAllColors.lightAccent,
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    color: AppAllColors.lightAccent,
                    padding: EdgeInsets.only(top: 18.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // виджет, из-за которого происходит ошибка
                              RegionSheet(
                                isWhiteFont: true,
                                items: widget.items,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.exit_to_app_sharp,
                                      size: 24.h,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      var set = ref.read(settingsProvider);
                                      await set.setData<String>(
                                        SetKey.clientToken,
                                        '',
                                      );
                                      await set.setData<int>(
                                          SetKey.clientId, 0);
                                      await resetAppState(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35.r,
                                backgroundColor: AppAllColors.commonColorsWhite,
                              ),
                              SizedBox(
                                width: 22.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        (relevantInfo?.firstname != '' &&
                                                        relevantInfo != null
                                                    ? relevantInfo?.firstname
                                                    : "Имя не указано")
                                                .toString() +
                                            (relevantInfo?.lastname == null ||
                                                    relevantInfo!.lastname!
                                                        .trim()
                                                        .isEmpty
                                                ? ""
                                                : "\n${relevantInfo?.lastname}"),
                                        style:
                                            AppTextStyles.titleSmall.copyWith(
                                          color: AppAllColors.commonColorsWhite,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RegisterPage(
                                              isRegistered: true,
                                              clientData: widget.info,
                                              items: widget.items,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            AppRes.myData,
                                            style: AppTextStyles.textField
                                                .copyWith(
                                              color: AppAllColors
                                                  .commonColorsWhite,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 14.h,
                                            color:
                                                AppAllColors.commonColorsWhite,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppAllColors.lightBackground,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    await AppUi.showAppBottomSheet(
                                      context: context,
                                      child: BonusCardInfoSheet(
                                        isBonusCard,
                                        clientData: widget.info,
                                      ),
                                      isShape: true,
                                    ).then((value) {
                                      if (value == false) {
                                        AppUi.showToast(
                                          context,
                                          "Для активации карты необходимо заполнить все данные в профиле",
                                        );
                                      }

                                      return _pullRefresh();
                                    });
                                  },
                                  child: BonusCardWidget(
                                    bonusCountMess: bonusCountMess,
                                    numberCard: numberCard,
                                    isInSheet: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              OrdersPreviewWidget(),
              // region profilebuttons
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppAllColors.commonColorsWhite,
                  child: Column(
                    children: <Widget>[
                      ProfileNavigationButton(
                          icon: SvgPicture.asset(
                            AppIcons.inCart,
                            height: 16.h,
                            width: 16.h,
                            color: AppAllColors.lightAccent,
                          ),
                          title: AppRes.myOrders,
                          function: () {
                            // ref.read(ordersModelProvider.notifier).load();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => OrdersPage(),
                            //   ),
                            // ).then((value) => ref
                            //     .read(ordersModelProvider.notifier)
                            //     .reload());

                            ref
                                .read(personalStartModelProvider.notifier)
                                .init();
                          }),
                      ProfileNavigationButton(
                          icon: SvgPicture.asset(
                            AppIcons.date,
                            height: 16.h,
                            width: 16.h,
                            color: AppAllColors.lightAccent,
                          ),
                          title: AppRes.greatDates,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoriteDatesPage(),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          icon: SvgPicture.asset(
                            AppIcons.geo,
                            height: 16.h,
                            width: 16.h,
                            color: AppAllColors.lightAccent,
                          ),
                          title: AppRes.likeAddress,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoriteAddressesPage(),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          icon: SvgPicture.asset(
                            AppIcons.geo,
                            height: 16.h,
                            width: 16.h,
                            color: AppAllColors.lightAccent,
                          ),
                          title: AppRes.shops,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MarketsPage(items: [], position: null),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Помощь',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppAllColors.commonColorsWhite,
                  child: Column(
                    children: <Widget>[
                      ProfileNavigationButton(
                          title: AppRes.delivery,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeliveryCalculationScreen(address: 'Санкт-Петербург')
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.paymentMethods,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'oplata',
                                  title: AppRes.paymentMethods,
                                ),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.warranty,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'warranty',
                                  title: AppRes.warranty,
                                ),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.giveBackPolicy,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'obmen_vozvrat',
                                  title: AppRes.giveBackPolicy,
                                ),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.publicOferta,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'oferta',
                                  title: AppRes.publicOferta,
                                ),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.agreement,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'soglashenie',
                                  title: AppRes.agreement,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'О компании',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppAllColors.commonColorsWhite,
                  child: Column(
                    children: <Widget>[
                      ProfileNavigationButton(
                          title: AppRes.information,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'about',
                                  title: AppRes.information,
                                ),
                              ),
                            );
                          }),
                      ProfileNavigationButton(
                          title: AppRes.rekviziti,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBasePage(
                                  pageName: 'rekvizity',
                                  title: AppRes.rekviziti,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),

              // endregion
            ],
          ),
        ),
      ),
    );
  }
}
