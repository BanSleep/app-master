import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/card/widgets/content/variant/price_variants_widget.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/products/models/cart_sheet_data.dart';
import 'package:cvetovik/pages/products/widget/buy_product/buy_actions_widget.dart';
import 'package:cvetovik/pages/products/widget/buy_product/decor_list_widget.dart';
import 'package:cvetovik/widgets/product/counter/product_counter_widget.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';

class AddProductToCartSheet extends ConsumerStatefulWidget {
  AddProductToCartSheet({
    required this.data,
    required this.price,
    required this.item,
    required this.versionTitle,
    this.versions,
  });

  final CartSheetData data;

  final int price;
  final ProductData item;
  final List<Version>? versions;
  final String versionTitle;

  @override
  _AddProductToCartSheetState createState() => _AddProductToCartSheetState();
}

class _AddProductToCartSheetState extends ConsumerState<AddProductToCartSheet> {
  late Widget variants;
  final _unescape = HtmlUnescape();

  @override
  void initState() {
    super.initState();
    variants = _getVariants();
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = ref.watch(cartTitleProvider);
    List<Widget> headerChildren = [];
    List<Widget> footerChildren = [];
    List<Widget> contentChildren = [];

    headerChildren.add(Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: LineSheet(),
    ));
    headerChildren.add(variants);
    headerChildren.add(ProductCounterWidget(
      price: widget.price,
    ));

    if (widget.data.linkedDecors != null) {
      var itemsDecor = widget.data.linkedDecors!.values
          .map((e) =>
              DecorListWidget(decor: e, selected: widget.data.selectedAddItems))
          .toList();
      contentChildren.addAll(itemsDecor);
    }

    contentChildren.add(Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              AppRes.total,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.start,
            ),
            //add
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppRes.additionally,
                    style: AppTextStyles.textField,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    cartProvider.addTitle,
                    style: AppTextStyles.titleVerySmall,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7.5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150.w,
                    child: Text(
                      _title(),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textField,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    cartProvider.mainTitle,
                    style: AppTextStyles.titleVerySmall,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));

    footerChildren
        .add(BuyActionsWidget(price: widget.price, item: widget.item));

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height * 0.5,
          maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Padding(
        padding: EdgeInsets.only(
            left: 10.0.w, right: 10.0.w, top: 8.h, bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: headerChildren,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: contentChildren,
              ),
            ),
            Column(
              children: footerChildren,
            ),
          ],
        ),
      ),
    );
  }

  String _title() => _unescape.convert(widget.item.title);

  Widget _getVariants() {
    void _onSelectVersion(String title) {
      var cartTitleProv = ref.read(cartTitleProvider.notifier);
      cartTitleProv.state = cartTitleProv.state.copyWith(versionTitle: title);
      var cartProv = ref.read(productCartProvider);
      cartProv.updateTitle(prev: widget.data.currPrice);
    }

    if (_existsVersions()) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: PriceVariantsWidget(
            title: '', //AppRes.heightRose,
            selectedTitle: widget.versionTitle,
            onSelect: _onSelectVersion,
            versions: widget.versions!),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  bool _existsVersions() =>
      widget.versions != null && widget.versions!.length > 1;
}
