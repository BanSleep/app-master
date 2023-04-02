import 'package:cvetovik/models/api/response/region/region_info_response.dart';
import 'package:cvetovik/pages/products/models/enum/product_badges.dart';
import 'package:cvetovik/pages/products/widget/content/circle_image_widget.dart';
import 'package:cvetovik/widgets/product/badges/product_badge_widget.dart';
import 'package:cvetovik/widgets/product/badges/product_bonus_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsBadgesHelper {
  final int bonus;
  final List<String>? chips;
  final Promos? promos;
  List<ProductBadges> _actions = [];
  List<ProductBadges> _badges = [];
  ProductsBadgesHelper(this.bonus, this.chips, this.promos) {
    if (chips != null && chips!.length > 0) {
      List<ProductBadges> rawBadges = [];
      chips!.forEach((el) {
        if (el == 'new') {
          rawBadges.add(ProductBadges.newItem);
        } else {
          var item = EnumToString.fromString(ProductBadges.values, el);
          if (item != null) {
            rawBadges.add(item);
          }
        }
      });
      //if (rawBadges.length>0)
      {
        rawBadges.forEach((el) {
          switch (el) {
            case ProductBadges.hour:
            case ProductBadges.hot:
            case ProductBadges.newItem:
            case ProductBadges.cashback:
            case ProductBadges.bprice:
              _badges.add(el);
              break;
            case ProductBadges.promo1:
            case ProductBadges.promo2:
            case ProductBadges.promo3:
              _actions.add(el);
              break;
          }
        });
      }
    }
  }

  Widget getActions() {
    if (_actions.length > 0) {
      //var res = promos !=null;
      //print(promos!.promo1.toString());

      List<Widget> children =
          _actions.map((e) => CircleImageWidget(source: _getImage(e))).toList();
      return Padding(
        padding: EdgeInsets.only(left: 7.5.w),
        child: Row(
          children: children,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  List<ProductBadgeWidget> getBadges({bool isSmall = true}) {
    return _badges
        .map((e) => ProductBadgeWidget(
              badge: e,
              isSmall: isSmall,
            ))
        .toList();
  }

  Widget getBadgesWithBonus({bool isSmall = false}) {
    List<Widget> children = [];
    if (bonus > 0) {
      children.add(ProductBonusWidget(
        bonus: bonus,
        isSmall: isSmall,
      ));
      //children.add(ProductBadge(badge:ProductBadges.hour ,));
    }
    if (_badges.length > 0) {
      var bItems = getBadges(isSmall: isSmall);
      children.addAll(bItems);
    }
    if (children.length > 0)
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    else
      return SizedBox.shrink();
  }

  String? _getImage(ProductBadges e) {
    String? res;
    if (promos != null) {
      switch (e) {
        case ProductBadges.hour:
        case ProductBadges.hot:
        case ProductBadges.newItem:
        case ProductBadges.cashback:
        case ProductBadges.bprice:
          break;
        case ProductBadges.promo1:
          if (promos!.promo1 != null) res = promos!.promo1!.image;
          break;
        case ProductBadges.promo2:
          if (promos!.promo2 != null) res = promos!.promo2!.image;
          break;
        case ProductBadges.promo3:
          if (promos!.promo3 != null) res = promos!.promo3!.image;
          break;
      }
    }
    return res;
  }
}
