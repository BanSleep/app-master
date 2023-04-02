import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/new_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewAddressButton extends StatelessWidget {
  const NewAddressButton({
    Key? key,
    this.resizeAvoid = false,
  }) : super(key: key);
  final bool resizeAvoid;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewAddressPage(
                      resizeAvoid: resizeAvoid,
                    )),
          );
        },
        style: AppUi.buttonActionStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                AppRes.newAddress,
                style: AppTextStyles.titleVerySmall
                    .copyWith(color: Colors.white, fontSize: 13.sp),
              ),
            ),
            SizedBox(
              height: 18.r,
              width: 18.r,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
