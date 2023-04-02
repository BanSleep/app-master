import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardPriceWidget extends StatelessWidget {
  const CardPriceWidget({Key? key, required this.price, this.showPiece = true})
      : super(key: key);
  final int price;
  final bool showPiece;

  @override
  Widget build(BuildContext context) {
    var text = '$price ${AppRes.shortCurrency}';
    if (showPiece) {
      text = '$text ${AppRes.perPiece}';
    }
    return Text(
      text,
      style: AppTextStyles.titleLarge22,
      textAlign: TextAlign.start,
    );
  }
}
