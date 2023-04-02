import 'package:collection/collection.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/cart/models/cart_price_data.dart';
import 'package:cvetovik/pages/cart/provider/cart_price_provider.dart';
import 'package:cvetovik/pages/cart/widgets/cart_bonus_selector.dart';
import 'package:cvetovik/pages/cart/widgets/cart_content_bottom_bar.dart';
import 'package:cvetovik/pages/cart/widgets/cart_discount_widget.dart';
import 'package:cvetovik/pages/cart/widgets/cart_row_widget.dart';
import 'package:cvetovik/pages/ordering/models/discount/discount_data.dart';
import 'package:cvetovik/pages/ordering/providers/current_discount_provider.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/dialog/platform_dialog.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'models/cart_row_add_data.dart';

class CartContent extends ConsumerStatefulWidget {
  const CartContent({
    Key? key,
    required this.mainData,
    required this.addData,
  }) : super(key: key);

  final List<CartMainData> mainData;
  final CartRowAddData addData;

  @override
  ConsumerState createState() => _CartContentState();
}

class _CartContentState extends ConsumerState<CartContent> {
  bool _isLoading = false;
  String promoCode = '';
  late List<CartMainData> mainData;

  int? useBonus;

  @override
  initState() {
    mainData = widget.mainData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var list = ref.watch(cartListProvider);
    return list.when(
      data: (data) {
        mainData = data;
        var state = ref.watch(cartPriceProvider(mainData));
        CartPriceData cartData = CartPriceData.init();

        state.maybeWhen(
            initializing: () {},
            checkedPromoCode: (data) {
              cartData = data;
            },
            loaded: (data) {
              cartData = data;
            },
            orElse: () {});
        return GestureDetector(
            onTap: () {
              AppUi.hideKeyboard(context);
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                bottomNavigationBar: CartContentBottomNavBar(
                    data: cartData,
                    tapAction: (BuildContext context) async {
                      var prov = ref.read(cartPriceProvider(mainData).notifier);
                      await prov.goCheckout(context, promoCode,useBonus);
                    }),
                body: LoadingOverlay(
                    isLoading: _isLoading,
                    opacity: AppUi.opacity,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          10.w,
                          5.h,
                          10.w,
                          10.h,
                        ),
                        child: SafeArea(
                            child: SingleChildScrollView(
                                child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppRes.cart,
                                      style: AppTextStyles.titleSmall),
                                  InkWell(
                                    onTap: () async {
                                      var droidTitle = '${AppRes.clearCart}?';
                                      await PlatformDialog.show(
                                          context: context,
                                          okTitle: AppRes.clearCart,
                                          action: () async {
                                            var prov = ref.read(
                                                cartPriceProvider(mainData)
                                                    .notifier);
                                            await prov.deleteAll();
                                          },
                                          droidTitle: droidTitle);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.w),
                                          child: SvgPicture.asset(
                                            AppIcons.trash,
                                            color: AppAllColors.commonColorsRed,
                                            height: 13.w,
                                            width: 12.w,
                                          ),
                                        ),
                                        Text(AppRes.clearCart,
                                            style: AppTextStyles.textFieldBold
                                                .copyWith(
                                                    color: AppAllColors
                                                        .commonColorsRed,
                                                    fontSize: 11.sp)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              constraints: BoxConstraints(
                                  minHeight: 200, minWidth: double.infinity),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [AppUi.baseShadow],
                                color: Colors.white,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var curr = widget.mainData[index];
                                  bool favorite = false;
                                  if (widget.addData.favs != null) {
                                    var currFav = widget.addData.favs!
                                        .firstWhereOrNull(
                                            (el) => el.id == curr.productId);
                                    if (currFav != null) {
                                      favorite = true;
                                    }
                                  }
                                  List<CartAddData>? add;
                                  if (widget.addData.add != null) {
                                    add = widget.addData.add!
                                        .where((element) =>
                                            element.mainId == curr.id)
                                        .toList();
                                  }
                                  return CartRowWidget(
                                    key: GlobalKey(debugLabel: curr.title),
                                    main: curr,
                                    add: add,
                                    favorite: favorite,
                                  );
                                },
                                itemCount: widget.mainData.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppRes.promoCodeEnter,
                                    style: AppTextStyles.titleSmall)),
                            SizedBox(
                              height: 5.h,
                            ),
                            _promoCodeBloc(context),
                            /*CartPromoCode(
                              callback:
                                  (BuildContext context, String code) async {
                                var priceProv = ref
                                    .read(cartPriceProvider(mainData).notifier);
                                await priceProv.checkPromoCode(context, code);
                              },
                            ),*/
                            SizedBox(
                              height: 20.h,
                            ),
                            CartDiscountWidget(data: cartData),
                            SizedBox(
                              height: 12,
                            ),
                            CartBonusSelector(
                              onChangedBonus: (bonus) {
                                setState(() {
                                  useBonus = bonus;
                                });
                              }, maxPrice: cartData.total,
                            )
                          ],
                        )))))));
      },
      error: (
        error,
        stackTrace,
      ) =>
          Container(),
      loading: () => Container(),
    );
  }

  final keyPromo = GlobalKey();

  _promoCodeBloc(BuildContext context) {
    return Container(
      height: 76.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [AppUi.baseShadow],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppTextField(
              key: keyPromo,
              hint: AppRes.promoCode,
              title: '',
              minLength: 3,
              errorText: AppRes.inputPromoCode,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          SizedBox(
            width: 59.w,
            child: AppButton(
              white: false,
              title: AppRes.ok,
              tap: () async {
                promoCode = (keyPromo.currentState! as GetStrMixin).value();
                var priceProv = ref.read(cartPriceProvider(mainData).notifier);
                await priceProv.checkPromoCode(context, promoCode);
              },
              rightPad: 0.w,
            ),
          ),
        ],
      ),
    );
  }
}
