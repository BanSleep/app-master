import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchEmptyResultWidget extends StatelessWidget {
  const SearchEmptyResultWidget({Key? key, required this.search})
      : super(key: key);
  final String search;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getTitle(),
          SizedBox(
            height: 140.h,
          ),
          Center(
              child: Text(AppRes.notFound,
                  style: AppTextStyles.titleLarge
                      .copyWith(color: AppAllColors.lightGrey2))),
          SizedBox(
            height: 70.h,
          ),
          Image.asset(
            AppIcons.notFind,
            width: 252.w,
            height: 272.h,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }

  Widget _getTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, left: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                AppRes.resultSearch,
                style: AppTextStyles.titleSmall,
              )),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              search,
              style: AppTextStyles.titleSmall
                  .copyWith(color: AppAllColors.lightAccent),
            ),
          )
        ],
      ),
    );
  }
}
