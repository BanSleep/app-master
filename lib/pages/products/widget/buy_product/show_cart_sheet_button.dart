import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/const/app_typedef.dart';
import 'package:cvetovik/core/api/product_card_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/products/widget/buy_product/add_product_to_cart_sheet.dart';
import 'package:cvetovik/pages/products/widget/buy_product/button_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowCartSheetButton extends ConsumerStatefulWidget {
  const ShowCartSheetButton(
      {Key? key,
      required this.item,
      required this.height,
      this.onLoad,
      this.initProv = false,
      this.alreadyInCart = false,
      this.largeFont = false})
      : super(key: key);
  final ProductData item;
  final double height;
  final bool initProv;
  final bool alreadyInCart;
  final bool largeFont;
  final OnProcess? onLoad;
  @override
  ConsumerState createState() => _ShowCartSheetButtonState();
}

class _ShowCartSheetButtonState extends ConsumerState<ShowCartSheetButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.height),
      child: ElevatedButton(
        onPressed: () async {
          await _addInCart(context, ref);
        },
        child: ButtonTitleWidget(
          height: 13.h,
          width: 12.h,
          icon: AppIcons.inCart,
          title: (widget.alreadyInCart) ? AppRes.alreadyInCart : AppRes.inCart,
          style: getStyle(),
        ),
        style: AppUi.buttonActionStyle,
      ),
    );
  }

  TextStyle getStyle() => widget.largeFont
      ? AppTextStyles.textMediumBold.copyWith(color: Colors.white)
      : AppTextStyles.textSmallBold.copyWith(color: Colors.white);

  bool _isRun = false;
  Future<void> _addInCart(BuildContext context, WidgetRef ref) async {
    try {
      if (_isRun) {
        await Future.delayed(Duration(milliseconds: 500));
        return;
      }
      if (widget.onLoad != null) {
        widget.onLoad!(true);
      }
      _isRun = true;
      var productCart = ref.read(productCartProvider);
      var set = ref.read(settingsProvider);
      var api = ref.read(productCardApiProvider);
      var cartTitleProv = ref.read(cartTitleProvider.notifier);
      if (widget.initProv) {
        cartTitleProv.state.init();
      }
      var regData = set.getDeviceRegisterWithRegion();
      var clientInfo = set.getLocalClientInfo();

      List<Version>? versions = cartTitleProv.state.versions;
      int price = widget.item.price;
      ProductCardResponse product = await api.getProductCard(
          deviceRegister: regData, id: widget.item.id, clientInfo: clientInfo);
      if (versions == null) {
        if (product.result &&
            product.data != null &&
            product.data!.versions != null) {
          versions = product.data!.versions;
          var title = versions!.first.title;
          cartTitleProv.state = cartTitleProv.state
              .copyWith(versions: versions, versionTitle: title);
        }
      }
      if (versions != null) {
        var startPrice =
            versions.first.prices.firstWhere((element) => element.minNum == 0);
        price = startPrice.price;
      }
      var sheetData = await productCart.prepareShowAddProductToCartSheet(
          context,
          widget.item,
          price,
          (product.result && product.data != null)
              ? product.data!.catalogId
              : 0);
      try {
        if (widget.onLoad != null) {
          widget.onLoad!(false);
        }
        await AppUi.showAppBottomSheet(
            context: context,
            isShape: true,
            child: AddProductToCartSheet(
              price: price,
              item: widget.item,
              data: sheetData,
              versions: versions,
              versionTitle: cartTitleProv.state.versionTitle,
            ));
      } catch (e) {
        print(e);
      }
    } finally {
      _isRun = false;
    }
  }
}
