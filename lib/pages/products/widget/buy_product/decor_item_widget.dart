import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/linked/linked_decors_response.dart';
import 'package:cvetovik/pages/cart/provider/product_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecorItemWidget extends ConsumerStatefulWidget {
  const DecorItemWidget(
      {Key? key, required this.item, required this.isSelected})
      : super(key: key);
  final DecorProduct item;
  final bool isSelected;

  @override
  _DecorItemWidgetState createState() => _DecorItemWidgetState();
}

class _DecorItemWidgetState extends ConsumerState<DecorItemWidget> {
  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  late bool isSelected;
  @override
  Widget build(BuildContext context) {
    final double radius = 8.r;
    var price = widget.item.price.toString() + AppRes.shortCurrency;
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
          var productCart = ref.read(productCartProvider);
          productCart.updateDecor(isSelected, widget.item);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: (isSelected)
                    ? AppAllColors.lightAccent
                    : Colors.transparent),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          width: 164.w,
          //height: 48.h,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius)),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: AppTextStyles.textFieldSmall
                              .copyWith(color: AppAllColors.lightBlack)),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0.h),
                        child: Text(
                          price,
                          style: AppTextStyles.textMedium9,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
