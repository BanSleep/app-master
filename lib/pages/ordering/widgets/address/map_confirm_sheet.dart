import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/region/region_shops_response.dart';
import 'package:cvetovik/widgets/app_button.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapConfirmSheet extends ConsumerWidget {
  const MapConfirmSheet({Key? key, required this.shop}) : super(key: key);
  final RegionShopInfo shop;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final set = ref.read(settingsProvider);
    final String city = set.getCurrentRegionTitle();
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: AppUi.sheetDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8.h,
            ),
            LineSheet(),
            SizedBox(
              height: 17.h,
            ),
            Text(
              AppRes.appNameShop,
              style: AppTextStyles.titleSmall,
            ),
            SizedBox(
              height: 15.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppRes.city,
                      style: AppTextStyles.descriptionMedium10,
                    ),
                    Text(
                      city,
                      style: AppTextStyles.descriptionMedium10Black,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      AppRes.street,
                      style: AppTextStyles.descriptionMedium10,
                    ),
                    Text(
                      shop.address,
                      style: AppTextStyles.descriptionMedium10Black,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      AppRes.timeWork,
                      style: AppTextStyles.descriptionMedium10,
                    ),
                    Text(
                      shop.workTime,
                      style: AppTextStyles.descriptionMedium10Black,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      AppRes.phone,
                      style: AppTextStyles.descriptionMedium10,
                    ),
                    Text(
                      shop.contacts,
                      style: AppTextStyles.descriptionMedium10Black,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                  ],
                ),
              ),
            ),
            AppButton(
              white: false,
              title: AppRes.getHere,
              tap: () async {
                Navigator.pop(context, true);
              },
            ),
            SizedBox(
              height: 31.h,
            ),
          ],
        ),
      ),
    );
  }
}
