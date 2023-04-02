import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/services/providers/navbar_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';

class FavoriteEmptyWidget extends ConsumerWidget {
  const FavoriteEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: _getBottomNavBar(ref),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            10.w,
            10.h,
            10.w,
            10.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(AppRes.favorites, style: AppTextStyles.titleSmall),
              ]),
              Padding(
                padding: EdgeInsets.only(
                  top: 94.h,
                  bottom: 70.h,
                ),
                child: Text(AppRes.yourFavoritesEmpty,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleLarge
                        .copyWith(color: AppAllColors.lightGrey2)),
              ),
              Image.asset(
                AppIcons.emptyFav,
                width: 292.w,
                height: 220.h,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBottomNavBar(WidgetRef ref) {
    return Container(
      height: 77.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 31.h),
        child: Consumer(
          builder: (BuildContext context, watch, _) {
            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: 44.h,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  ref.read(navBarProvider).onTap(TabItem.catalog);
                },
                style: AppUi.buttonActionStyle,
                child: Text(
                  AppRes.inCatalog,
                  style: AppTextStyles.titleVerySmall
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
