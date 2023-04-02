import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class DiscountRowWidget extends StatelessWidget {
  const DiscountRowWidget(
      {Key? key, required this.title, required this.value, this.bold = false})
      : super(key: key);
  final String title;
  final int value;
  final bool bold;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: (bold)
              ? AppTextStyles.smallTitle13
              : AppTextStyles.smallTitle13NotBold,
        ),
        Text(
          '${value.toString()}${AppRes.shortCurrency}',
          style: AppTextStyles.textLarge,
        ),
      ],
    );
  }
}
