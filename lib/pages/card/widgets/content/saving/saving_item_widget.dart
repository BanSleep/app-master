import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavingItemWidget extends StatelessWidget {
  const SavingItemWidget({Key? key, required this.data}) : super(key: key);
  final ProductCardPrice data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 7.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppRes.from.toLowerCase()} ${data.minNum} ${AppRes.piece}',
              textAlign: TextAlign.start,
              style: AppTextStyles.textMediumBold
                  .copyWith(color: AppAllColors.lightAccent)),
          Text('${data.price} ${AppRes.shortCurrency}',
              textAlign: TextAlign.start,
              style: AppTextStyles.textMediumBold
                  .copyWith(fontWeight: FontWeight.w100)),
        ],
      ),
    );
  }
}
