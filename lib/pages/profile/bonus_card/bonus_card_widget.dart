import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class BonusCardWidget extends StatelessWidget {
  const BonusCardWidget({
    Key? key,
    required this.bonusCountMess,
    required this.numberCard,
    required this.isInSheet,
  }) : super(key: key);

  final String bonusCountMess;
  final String numberCard;
  final bool isInSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppIcons.bonusBg),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Text(
            bonusCountMess,
            style: AppTextStyles.titleVerySmall.copyWith(
              color: AppAllColors.commonColorsWhite,
            ),
          ),
          8.0.heightBox,
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppAllColors.commonColorsWhite,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: !isInSheet || !numberCard.contains("о")
                ? BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: numberCard.contains("о")
                        ? "1234567890000000"
                        : numberCard.replaceAll(' ', ''),
                    drawText: false,
                    width: 260,
                  )
                : Container(),
          ),
          8.0.heightBox,
          Visibility(
            visible: numberCard.isNotEmpty,
            child: Text(
              numberCard,
              style: AppTextStyles.titleVerySmall.copyWith(
                color: AppAllColors.commonColorsWhite,
              ),
            ),
          ),
        ],
      ),
    );

    // return Stack(
    //   children: <Widget>[
    //     // Container(
    //     //   alignment: Alignment.topCenter,
    //     //   padding: new EdgeInsets.only(
    //     //     top: 100.h,
    //     //   ),
    //     //   child: new Container(
    //     //     height: 10.h,
    //     //     decoration: BoxDecoration(
    //     //       color: Colors.white,
    //     //       borderRadius:
    //     //       BorderRadius.all(Radius.circular(30.r)),
    //     //     ),
    //     //     width: MediaQuery.of(context).size.width,
    //     //   ),
    //     // ),
    //     Container(
    //       alignment: Alignment.topCenter,
    //       // padding: new EdgeInsets.only(right: 10.w, left: 10.w),
    //       child: SizedBox(
    //         height: 112.h,
    //         child: Image.asset(
    //           AppIcons.bonusBg,
    //           height: 112.h,
    //           fit: BoxFit.fitWidth,
    //         ),
    //       ),
    //     ),
    //     Container(
    //       alignment: Alignment.topCenter,
    //       padding: EdgeInsets.only(top: 47.h),
    //       child: Container(
    //         height: 19.h,
    //         width: 200.w,
    //         child: !isInSheet || !numberCard.contains("о")
    //             ? SfBarcodeGenerator(
    //                 symbology: Code39(module: 2),
    //                 value: numberCard.contains("о")
    //                     ? "1234567891010000"
    //                     : numberCard.replaceAll(' ', ''),
    //                 showValue: false,
    //                 barColor: Colors.black,
    //               )
    //             : Container(),
    //       ),
    //     ),
    //     Positioned.fill(
    //       right: 0.0,
    //       top: 9.h,
    //       child: Align(
    //         alignment: Alignment.topCenter,
    //         child: Text(
    //           bonusCountMess,
    //           style: AppTextStyles.titleVerySmall.copyWith(
    //             color: AppAllColors.commonColorsWhite,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Visibility(
    //       visible: numberCard.isNotEmpty,
    //       child: Positioned.fill(
    //         bottom: 13.0.h,
    //         child: Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Text(
    //             numberCard,
    //             style: AppTextStyles.titleVerySmall.copyWith(
    //               color: AppAllColors.commonColorsWhite,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
