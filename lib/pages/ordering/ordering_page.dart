import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/delivery_info_response.dart';
import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:cvetovik/pages/cart/widgets/cart_discount_widget.dart';
import 'package:cvetovik/pages/ordering/models/order_result_data.dart';
import 'package:cvetovik/pages/ordering/models/payment_method_data.dart';
import 'package:cvetovik/pages/ordering/order_result_page.dart';
import 'package:cvetovik/pages/ordering/providers/center_position_provider.dart';
import 'package:cvetovik/pages/ordering/providers/current_discount_provider.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/current_zone_provider.dart';
import 'package:cvetovik/pages/ordering/providers/ordering/ordering_bloc.dart';
import 'package:cvetovik/pages/ordering/widgets/ordering_item_widget.dart';
import 'package:cvetovik/pages/ordering/widgets/tab/ordering_courier_widget.dart';
import 'package:cvetovik/pages/ordering/widgets/tab/ordering_self_get_widget.dart';
import 'package:cvetovik/pages/payment/payment_page.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/product/expander_widget.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'mixin/address_mixin.dart';

class OrderingPage extends ConsumerStatefulWidget {
  const OrderingPage(
      {Key? key, required this.deliveryInfo, required this.cartData,
       this.useBonus,
      })
      : super(key: key);
  final DeliveryInfo deliveryInfo;
  final CartPriceData cartData;
  final int? useBonus;

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends ConsumerState<OrderingPage> with AddressMixin {
  GlobalKey keyCourier = GlobalKey();
  GlobalKey keyGetSelf = GlobalKey();

  GlobalKey keyTabCourier = GlobalKey();
  GlobalKey keyTabGetSelf = GlobalKey();
  bool _isLoading = false;
  PaymentMethodData? paymentInfo;

  List<String> deliveryPayments = [];
  List<String> pickUpPayments = [];

  getRegionInfo() async {
    print('cal141');
    try{
      var set = ref.read(settingsProvider);
      var regData = set.getDeviceRegisterWithRegion();
      var info = await ref.read(repositoryInfoProvider).getRegionInfo(regData);
      setState(() {
        deliveryPayments = info!.payments!.delivery;
        pickUpPayments = info.payments!.pickUp;
      });
    }catch(e){
      print(e.toString()+'ero141');
    }


  }

  @override
  void initState() {
    getRegionInfo();
    var bloc = ref.read(orderingBlocProvider);
    print('delivery info: ${widget.deliveryInfo}');
    bloc.init(
        context: context,
        getOrderData: _getOrderData,
        isCourier: _isCourier(),
        deliveryInfo: widget.deliveryInfo);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (keyCourier.currentState as OrderingItemWidgetState).onSelected(true);
      var pos = bloc.getCenterPosition();
      if (pos != null) {
        var prov = ref.read(centerPositionProvider.notifier);
        prov.state = pos;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var timeRanges =
        ref.read(orderingBlocProvider).getTimeRanges(DateTime.now(), null);
    // var _temp = timeRanges.map((e) => e.toJson()).toSet();
    // log("TIME RANGES $_temp");
    var deliveryPrice = ref.watch(currentDeliveryPriceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _getBottomNavbar(deliveryPrice),
      appBar: AppBar(
        leading: AppBackButton(
          tap: () => Navigator.pop(context),
        ),
        title: Text(
          AppRes.checkout,
          style:
              AppTextStyles.titleLarge.copyWith(color: AppAllColors.lightBlack),
        ),
        centerTitle: true,
        leadingWidth: AppUi.leadingWidth,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: AppUi.opacity,
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 8.h), //46
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppRes.delivery,
                          style: AppTextStyles.titleSmall)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: ButtonsTabBar(
                    onTap: _updateTab,
                    duration: 1,
                    labelStyle: AppTextStyles.textLessMediumBold
                        .copyWith(color: Colors.green),
                    backgroundColor: Colors.white,
                    unselectedBackgroundColor: AppAllColors.lightGrey,
                    physics: NeverScrollableScrollPhysics(),
                    tabs: [
                      Tab(
                        child: OrderingItemWidget(
                          key: keyCourier,
                          title: AppRes.courier,
                          id: 0,
                        ),
                      ),
                      Tab(
                        child: OrderingItemWidget(
                          key: keyGetSelf,
                          title: AppRes.selfGet,
                          id: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  children: [
                    OrderingCourierWidget(onSelectPayment: (data){
                     paymentInfo=data;
                    },
                      payments: deliveryPayments,
                      key: keyTabCourier,
                      deliveryInfo: widget.deliveryInfo,
                      timeRanges: timeRanges, paymentData: paymentInfo,
                    ),
                    OrderingSelfGetWidget(onSelectPayment: (data){
                      paymentInfo=data;
                    },paymentInfo: paymentInfo,
                      payments: pickUpPayments,
                      key: keyTabGetSelf,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _selected = 0;

  int _currentDeliveryPrice = 0;

  void _updateTab(int id) {
    _selected = id;
    if (id == 0) {
      (keyCourier.currentState as OrderingItemWidgetState).onSelected(true);
      (keyGetSelf.currentState as OrderingItemWidgetState).onSelected(false);
      if (_currentDeliveryPrice > 0) {
        var deliveryPriceProv = ref.read(currentDeliveryPriceProvider.notifier);
        deliveryPriceProv.state = _currentDeliveryPrice;
        _currentDeliveryPrice = 0;
      }
    } else {
      (keyCourier.currentState as OrderingItemWidgetState).onSelected(false);
      (keyGetSelf.currentState as OrderingItemWidgetState).onSelected(true);
      var deliveryPriceProv = ref.read(currentDeliveryPriceProvider.notifier);
      if (deliveryPriceProv.state > 0) {
        _currentDeliveryPrice = deliveryPriceProv.state;
        deliveryPriceProv.state = 0;
      }
    }
    setState(() {
      paymentInfo=null;
    });


    var bloc = ref.read(orderingBlocProvider);
    bloc.updateIsCourier(_isCourier());
  }

  Widget _getBottomNavbar(int price) {
    CartPriceData cartData = widget.cartData.copyWith(deliveryPrice: price);
    var finalPrice = cartData.total;
    print("Final price: $finalPrice");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpanderWidget(
          child: CartDiscountWidget(data: cartData),
          title: AppRes.total2,
        ),
        Container(
          color: Colors.white,
          height: 46.h,
          child: AppButton(
            title: AppRes.payment2,
            white: false,
            tap: () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                var paymentWidget =
                    await ref.read(orderingBlocProvider).checkPayment(paymentInfo,widget.useBonus);
                if (paymentWidget != null) {
                  var bloc = ref.read(orderingBlocProvider);
                  //Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderResultPage(
                              orderId: bloc.orderId,
                              openRootPage: true,
                              price: price.toString(),
                            )
                        //OrderingPage()
                        ),
                  );

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaymentPage(
                        paymentWidget: paymentWidget,
                        price: finalPrice,
                      ),
                    ),
                  );
                }
              } finally {
                if (this.mounted)
                  setState(() {
                    _isLoading = false;
                  });
              }
            },
          ),
        ),
      ],
    );
  }

  bool _isCourier() => _selected == 0;

  OrderResultData _getOrderData() {
    late OrderResultData res;
    if (_isCourier()) {
      res = (keyTabCourier.currentState as GetOrderMixin).value();
      //res.request!.promoCode = '';
    } else {
      res = (keyTabGetSelf.currentState as GetOrderMixin).value();
    }
    if (res.request != null) {
      var discount = ref.read(discountProvider.notifier).state;
      res.request!.promoCode = discount.promoCode;
    }
    return res;
  }
}
