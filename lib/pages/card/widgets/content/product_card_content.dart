import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/comments_response.dart';
import 'package:cvetovik/models/api/response/linked/linked_products_response.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/card/widgets/card_price_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/comment/new_product_comment_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/comment/product_comments_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/info/card_add_info_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/linked_products_content.dart';
import 'package:cvetovik/pages/card/widgets/content/saving/your_saving_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/variant/price_variants_widget.dart';
import 'package:cvetovik/pages/card/widgets/images_slider/product_images_slider.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:cvetovik/pages/products/widget/buy_product/button_title_widget.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:cvetovik/widgets/app_divider_old.dart';
import 'package:cvetovik/widgets/product/app_html_widget.dart';
import 'package:cvetovik/widgets/product/badges/product_badges_helper.dart';
import 'package:cvetovik/widgets/product/expander_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_unescape/html_unescape.dart';

class ProductCardContent extends ConsumerStatefulWidget {
  const ProductCardContent(
      {Key? key,
      required this.data,
      this.info,
      this.linkedProducts,
      this.comments,
      required this.favorite,
      required this.item})
      : super(key: key);
  final ProductCardData data;
  final RegionInfo? info;
  final Map<String, LinkedProduct>? linkedProducts;
  static const double padVertical = 8;
  final CommentData? comments;
  final bool favorite;
  final ProductData item;
  @override
  _ProductCardContentState createState() => _ProductCardContentState();
}

class _ProductCardContentState extends ConsumerState<ProductCardContent> {
  late bool isSelected;
  late Version? _version;
  late PriceVariantsWidget priceVariants;
  double _top = -1;
  final double _height = 260.h;
  bool _isCollapsed = false;
  bool _isFirstTap = false;
  late ScrollController _scrollController;
  bool _isBouquet = false;
  final _unescape = HtmlUnescape();
  late ProductCardPrice _price;
  @override
  void initState() {
    _scrollController = ScrollController();
    if (widget.data.versions != null && widget.data.versions!.length == 1) {
      var first = widget.data.versions!.first;
      if (first.prices.length == 1) {
        var price = first.prices.first;
        if (price.price > 350) _isBouquet = true;
      }
    }
    isSelected = widget.favorite;
    initVersion();
    var cartTitleProv = ref.read(cartTitleProvider.notifier);
    priceVariants = PriceVariantsWidget(
      versions: widget.data.versions!,
      onSelect: _selectVersion,
      title: '', //AppRes.heightRose,
      selectedTitle: cartTitleProv.state.versionTitle,
    );
    super.initState();
  }

  void initVersion({String title = ''}) {
    var cartTitleProv = ref.read(cartTitleProvider.notifier);
    if (title.isNotEmpty) {
      cartTitleProv.state = cartTitleProv.state.copyWith(versionTitle: title);
    } else {
      ref.read(cartTitleProvider.notifier).state.versions =
          widget.data.versions!;
    }
    var cartProv = ref.read(productCartProvider);
    _version = cartProv.getVersion(title: title);
    var currPrice = cartProv.getProductPrice();
    if (currPrice != null) {
      _price = currPrice;
    } else {
      if (_version != null) {
        _price = _version!.prices.first;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    items.add(widget.data.mainImage);
    items.addAll(widget.data.additionalImages);

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          leadingWidth: AppUi.leadingWidth,
          automaticallyImplyLeading: false,
          leading: AppBackButton(
            color: getIconColor(),
            tap: () {
              if (_isFirstTap) {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
                _isFirstTap = false;
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: _getTopTitle()),
          expandedHeight: _height,
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: true,
          backgroundColor: AppColors.lightBg2,
          actions: [
            Center(
              child: InkWell(
                onTap: () async {
                  var dao = ref.read(favoritesDaoProvider);
                  int res = 0;
                  if (!isSelected) {
                    res = await dao.insertFav(widget.item);
                  } else {
                    res = await dao.deleteFav(widget.data.id);
                  }
                  if (res > 0) {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14.0, top: 0),
                  child: SvgPicture.asset(
                    AppIcons.heard,
                    color: getFavColor(),
                    height: AppUi.iconSize,
                    width: AppUi.iconSize,
                  ),
                ),
              ),
            )
          ],
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _top = constraints.biggest.height;
              var currCollapsed = checkCollapsed();
              if (currCollapsed != _isCollapsed) {
                _isFirstTap = _isCollapsed;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _isFirstTap = !_isCollapsed;
                  setState(() {
                    _isCollapsed = currCollapsed;
                  });
                });
              }

              return FlexibleSpaceBar(
                  centerTitle: true,
                  background: (currCollapsed)
                      ? null
                      : ProductImagesSlider(
                          items: items,
                          height: _height,
                          mark: (widget.data.averageMark != null)
                              ? widget.data.averageMark.toString()
                              : null,
                        ));
            },
          ),
        ),
        SliverList(delegate: SliverChildListDelegate(_buildContent(context))),
      ],
    );
  }

  String _titleConvert() {
    return _unescape.convert(widget.data.title);
  }

  Text _getTitleWidget() {
    return Text(_titleConvert(),
        textAlign: TextAlign.start, style: AppTextStyles.titleSmall);
  }

  Widget _getTopTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Text(_titleConvert(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: AppTextStyles.titleSmall),
    );
  }

  Color getFavColor() {
    if (isSelected) {
      return AppAllColors.commonColorsRed;
    } else {
      return _isCollapsed ? AppAllColors.lightBlack : Colors.white;
    }
  }

  Color getIconColor() {
    return _isCollapsed ? AppAllColors.lightBlack : Colors.white;
  }

  bool checkCollapsed() => _top > -1 && _top < 80.h;

  List<Widget> _buildContent(BuildContext context) {
    List<Widget> children = [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppUi.pagePadding,
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: ProductCardContent.padVertical),
                  child: Text('${AppRes.sku}  ${widget.data.sku}',
                      textAlign: TextAlign.start,
                      style: AppTextStyles.textFieldSmall),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ProductCardContent.padVertical),
                  child: Visibility(
                    child: _getTitleWidget(),
                    visible: !_isCollapsed,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: ProductCardContent.padVertical),
                  child: Text(widget.data.descriptionShort,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.textLessMedium
                          .copyWith(color: AppAllColors.lightDarkGrey)),
                ),
                /*Padding(
                  padding: const EdgeInsets.symmetric(vertical: padVertical),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SvgPicture.asset(
                          AppIcons.car,
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Expanded(
                        child: Text(AppRes.delivery,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .text17
                                .copyWith(color: AppColors.itemTitle)),
                      ),
                    ],
                  ),
                ),*/
                _getVariantBlock(),
              ],
            ),
          ),
          if (widget.data.descriptionFull.isNotEmpty)
            textHtmlArea(widget.data.descriptionFull),
          Padding(
            padding: AppUi.pagePadding,
            child: Column(
              children: [
                _getWarranty(),
                _getDelivery(),
                _getPayment(),
                SizedBox(height: 48),
                if (widget.info != null)
                  CardAddInfoWidget(
                    delivery: widget.info!.textProductTabDelivery,
                    freeCard: widget.info!.textProductButtonFreeCard,
                    photoControl: widget.info!.textProductButtonPhotoControl,
                    discount: widget.item.title,
                  ),
                SizedBox(height: 48),
                if (widget.linkedProducts != null)
                  LinkedProductsContent(
                    linkedProducts: widget.linkedProducts,
                  ),
                if (widget.comments != null)
                  ProductCommentsWidget(
                    comments: widget.comments!,
                    title: _titleConvert(),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 25.0, bottom: 82.h),
                  child: SizedBox(
                    height: 36.h,
                    width: 149.w,
                    child: ElevatedButton(
                      style: AppUi.buttonActionStyle,
                      onPressed: () async {
                        await AppUi.showAppBottomSheet(
                            context: context,
                            child: NewProductCommentWidget(
                              item: widget.item,
                            ),
                            isShape: true);
                      },
                      child: ButtonTitleWidget(
                          height: 14.h,
                          width: 14.h,
                          icon: AppIcons.feedback,
                          title: AppRes.giveFeedback,
                          style: AppTextStyles.textMediumBold
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                //ProductCounter(),
              ],
            ),
          ),
        ],
      ),
    ];

    return children;
  }

  Widget textHtmlArea(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppUi.pagePadding.horizontal / 2,
        vertical: ProductCardContent.padVertical,
      ),
      color: AppColors.textArea,
      child: AppHtmlWidget(text),
    );
  }

  Widget textTab(String title, String body) {
    return ExpanderCard(
      headerColor: AppColors.textArea,
      title: title,
      child: Container(
        width: double.infinity,
        color: AppColors.textArea,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: AppDividerOld(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: textHtmlArea(body),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWarranty() {
    if (widget.info != null && widget.info!.textProductTabWarranty.isNotEmpty) {
      return textTab(AppRes.warranty, widget.info!.textProductTabWarranty);
    } else
      return Container();
  }

  Widget _getDelivery() {
    if (widget.info != null && widget.info!.textProductTabDelivery.isNotEmpty) {
      return textTab(AppRes.delivery, widget.info!.textProductTabDelivery);
    } else
      return Container();
  }

  Widget _getPayment() {
    if (widget.info != null && widget.info!.textProductTabPayment.isNotEmpty) {
      return textTab(AppRes.payment, widget.info!.textProductTabPayment);
    } else
      return Container();
  }

  Widget _getBalls(double padVertical, int bonus) {
    if (bonus > 0)
      return Padding(
        padding: EdgeInsets.symmetric(vertical: padVertical),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    /*SvgPicture.asset(
                AppIcons.balls2,
                height: 24.h,
                width: 24.h,
              ),*/
                    Image.asset(
                  AppIcons.balls2,
                  width: 24.h,
                  height: 24.h,
                  fit: BoxFit.fill,
                )),
            Expanded(
              child: Text('${AppRes.youGive} $bonus ${AppRes.balls}',
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: AppTextStyles.textField),
            ),
          ],
        ),
      );
    else {
      return SizedBox.shrink();
    }
  }

  Widget _getPriceWithBadges(int price) {
    var badges = ProductsBadgesHelper(0, widget.data.badges,
        widget.info != null ? widget.info!.promos : null);
    var wPrice = CardPriceWidget(
      price: price,
      showPiece: !_isBouquet,
    );
    List<Widget> children = [];
    children.add(wPrice);
    //children.addAll(badges.getBadges());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        wPrice,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: badges.getBadges(isSmall: false),
        )
      ],
    );
  }

  void _selectVersion(String title) {
    setState(() {
      initVersion(title: title);
    });
  }

  Widget _getVariantBlock() {
    // log("check one variant ${widget.data.versions![0].toJson()}");
    if (_version != null)
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getBalls(ProductCardContent.padVertical, _price.bonus),
          //_choiceVariants(),

          if (_isBouquet || widget.data.versions == null)
            SizedBox.shrink()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.data.versions![0].prices.length >= 2)
                  YourSavingWidget(
                    versionData: _version!,
                  ),
                if (widget.data.versions!.length >= 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: ProductCardContent.padVertical),
                    child: priceVariants,
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: ProductCardContent.padVertical),
            child: _getPriceWithBadges(_price.price),
          )
        ],
      );
    else
      return SizedBox.shrink();
  }
}
