import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.price,
    required this.maxPrice,
  }) : super(key: key);

  final int price;
  final int maxPrice;

  @override
  Widget build(BuildContext context) {
    String curr = '';
    if (maxPrice > 0 && maxPrice != price) {
      curr = '${AppRes.from.toLowerCase()} $price';
    } else {
      curr = price.toString();
    }
    return Text(
      '$curr ${AppRes.shortCurrency}',
      style: AppTextStyles.textMedium11,
      textAlign: TextAlign.start,
    );
  }
}
