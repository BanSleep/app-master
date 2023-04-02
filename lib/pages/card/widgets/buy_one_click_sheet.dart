import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/services/providers/new_order_provider.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_theme_provider.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/order_request.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/user/personal/personal_start_model.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyOneClickSheet extends ConsumerStatefulWidget {
  const BuyOneClickSheet({Key? key, this.item}) : super(key: key);
  final ProductData? item;
  @override
  _BuyOneClickSheetState createState() => _BuyOneClickSheetState();
}

class _BuyOneClickSheetState extends ConsumerState<BuyOneClickSheet> {
  final keyName = GlobalKey();
  final keyPhone = GlobalKey();
  late Color color;

  bool _buttonFlag = false;

  bool isButtonDisabled() {
    return _buttonFlag;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(personalStartModelProvider);
    final info = state.whenOrNull(loaded: (data, info) => info.data);

    bool isDark = ref.read(appThemeStateProvider);
    color = (isDark) ? AppColors.darkBackground : Colors.white;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: 374.h,
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.h,
                        bottom: 36.h,
                      ),
                      child: LineSheet(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Center(
                        child: Text(
                          AppRes.buyOneClick,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                    ),
                    Text(
                      AppRes.contact10min,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.textField,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: AppTextField(
                        key: keyName,
                        hint: AppRes.hintName,
                        title: AppRes.name,
                        minLength: 4,
                        errorText: AppRes.pleaseInputName,
                        text: info == null ? null : info.firstname,
                      ),
                    ),
                    AppTextField(
                      key: keyPhone,
                      hint: '+7',
                      title: AppRes.phone,
                      textFieldType: TextFieldType.phone,
                      minLength: 10,
                      errorText: AppRes.pleaseInputPhone,
                      text: info == null ? null : "+${info.phone}",
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0.h, top: 25.h),
                      child: SizedBox(
                        height: 44.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isButtonDisabled()
                              ? null
                              : () async {
                                  var name =
                                      (keyName.currentState! as GetStrMixin)
                                          .value();
                                  var phone =
                                      (keyPhone.currentState! as GetStrMixin)
                                          .value();

                                  if (name.isNotEmpty && phone.isNotEmpty) {
                                    setState(() {
                                      _buttonFlag = true;
                                    });
                                    var newOrderProv =
                                        ref.read(newOrderProvider);
                                    var productCartProv =
                                        ref.read(productCartProvider);
                                    if (widget.item != null) {
                                      var products = await productCartProv
                                          .getProductForOrder(widget.item!.id);
                                      int orderId = await newOrderProv
                                          .createOrder(OrderRequest(
                                              name: name,
                                              phone: phone,
                                              products: products));
                                      if (orderId > 0) {
                                        Navigator.pop(context, orderId);
                                        var cartDao = ref.read(cartDaoProvider);
                                        await cartDao
                                            .deleteProduct(widget.item!.id);
                                      } else {
                                        AppUi.showToastFromRes(context, false);
                                        Navigator.pop(context, false);
                                      }
                                    }
                                  }
                                },
                          style: AppUi.buttonActionStyle,
                          child: Text(
                            AppRes.send,
                            style: AppTextStyles.titleVerySmall
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0.h),
                      child: Text(
                        AppRes.agreePersonalData,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textField,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
