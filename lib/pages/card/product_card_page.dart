import 'package:cvetovik/core/services/providers/region_info_provider.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/card/product_card_model.dart';
import 'package:cvetovik/pages/card/widgets/content/product_card_content.dart';
import 'package:cvetovik/pages/products/widget/buy_product/buy_one_click_button.dart';
import 'package:cvetovik/pages/products/widget/buy_product/show_cart_sheet_button.dart';
import 'package:cvetovik/widgets/state/app_error_widget.dart';
import 'package:cvetovik/widgets/state/loading_widget.dart';
import 'package:cvetovik/widgets/state/not_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ProductCardPage extends ConsumerStatefulWidget {
  const ProductCardPage(
      {Key? key,
      required this.item,
      required this.favorite,
      this.alreadyInCart = false})
      : super(key: key);
  final ProductData item;
  final bool favorite;
  final bool alreadyInCart;

  @override
  _ProductCardPageState createState() => _ProductCardPageState();
}

class _ProductCardPageState extends ConsumerState<ProductCardPage> {
  bool isLoaded = false;
  bool isOpenCartSheet = false;

  bool? isOneClick;

  getOneClick() async {
    var set = ref.read(settingsProvider);
    var regData = set.getDeviceRegisterWithRegion();
    var info = await ref.read(repositoryInfoProvider).getRegionInfo(regData);

    setState(() {
      if (info != null && info.oneClickAvailable) {
        isOneClick = true;
      } else {
        isOneClick = false;
      }
    });
  }

  @override
  void initState() {
    getOneClick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('*** ${widget.item.id}');
    final state = ref.watch(productCardModelProvider(widget.item.id));
    Widget? body;
    state.maybeWhen(
      loaded: (data, info, linkedProducts, comments) {
        isLoaded = true;
        body = LoadingOverlay(
          isLoading: isOpenCartSheet,
          opacity: AppUi.opacity,
          child: ProductCardContent(
              data: data.data!,
              info: info,
              linkedProducts: linkedProducts,
              comments: comments,
              favorite: widget.favorite,
              item: widget.item),
        );
      },
      orElse: () => body = Container(),
      initializing: () => body = LoadingWidget(),
      emptyData: () => body = NotDataWidget(),
      error: (String? text) {
        body = AppErrorWidget(
          text: text,
          tryAgain: () async {
            await _getModel().load();
          },
        );
      },
    );

    return Scaffold(
      body: body,
      bottomNavigationBar: (isLoaded) ? _getBottomNav(context) : null,
    );
  }

  ProductCardModel _getModel() {
    var model = ref.read(productCardModelProvider(widget.item.id).notifier);
    return model;
  }

  Widget _getBottomNav(context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isOneClick != null && isOneClick!)
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: BuyOneClickButton(
                    height: 38.h,
                    width: 100.w,
                    item: widget.item,
                  ),
                ),
              Expanded(
                child: ShowCartSheetButton(
                  item: widget.item,
                  height: 38.h,
                  onLoad: _onLoadInCart,
                  alreadyInCart: widget.alreadyInCart,
                  largeFont: true,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onLoadInCart(bool state) {
    if (this.mounted) {
      setState(() {
        isOpenCartSheet = state;
      });
    }
  }
}
