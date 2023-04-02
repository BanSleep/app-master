import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/pages/ordering/widgets/shop_item/shop_item_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopInfoItemWidget extends StatelessWidget {
  const ShopInfoItemWidget(
      {Key? key,
      required this.data,
      required this.onTab,
      required this.selected})
      : super(key: key);
  final RegionShopInfo data;
  final Function onTab;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
                color: (selected) ? AppAllColors.lightAccent : Colors.white),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                data.title,
                style: AppTextStyles.textMediumBold,
                maxLines: 3,
              ),
              SizedBox(
                height: 12.h,
              ),
              ShowItemRowWidget(
                icon: AppIcons.pin,
                title: data.address,
              ),
              ShowItemRowWidget(
                icon: AppIcons.metro,
                title: data.metro,
              ),
              ShowItemRowWidget(
                icon: AppIcons.clock,
                title: data.workTime,
              ),
              ShowItemRowWidget(
                icon: AppIcons.phone,
                title: data.contacts,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
