import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/card/widgets/buy_one_click_sheet.dart';
import 'package:cvetovik/pages/ordering/order_result_page.dart';
import 'package:flutter/material.dart';

class BuyOneClickButton extends StatelessWidget {
  const BuyOneClickButton(
      {Key? key, required this.height, required this.width, this.item})
      : super(key: key);
  final double height;
  final double width;
  final ProductData? item;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height, width: width),
      child: ElevatedButton(
        onPressed: () async {
          var res = await AppUi.showAppBottomSheet(
              context: context,
              child: BuyOneClickSheet(
                item: item,
              ),
              isShape: true);
          if (res != null && res is int && res > 0) {
            print(res);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderResultPage(
                        orderId: res,
                      )
                  //OrderingPage()
                  ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: AppUi.buttonRoundedBorder,
            side: BorderSide(width: 1, color: AppColors.primary),
            primary: Colors.white),
        child: Text(
          AppRes.oneClick,
          style: AppTextStyles.textMediumBold
              .copyWith(color: AppAllColors.lightAccent),
        ),
      ),
    );
  }
}
