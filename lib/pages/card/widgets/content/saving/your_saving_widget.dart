import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/product_card_response.dart';
import 'package:cvetovik/pages/card/widgets/content/saving/saving_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourSavingWidget extends StatelessWidget {
  const YourSavingWidget({Key? key, required this.versionData})
      : super(key: key);
  final Version versionData;
  @override
  Widget build(BuildContext context) {
    var prices =
        versionData.prices.where((element) => element.minNum > 0).toList();
    if (prices.isNotEmpty)
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Container(
          height: 87.h,
          width: double.infinity,
          color: AppAllColors.lightGreyInfo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 7.h, top: 16.h),
                child: Text(AppRes.yourSaving,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.textMediumBold),
              ),
              Wrap(
                spacing: 32.0.w,
                runSpacing: 6.0,
                children: prices
                    .map((e) => SavingItemWidget(
                          data: e,
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      );
    else
      return SizedBox.shrink();
  }
}
