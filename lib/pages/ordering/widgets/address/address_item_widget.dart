import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/pages/ordering/new_address_page.dart';
import 'package:cvetovik/widgets/dialog/platform_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressItemWidget extends ConsumerWidget {
  const AddressItemWidget(
      {Key? key,
      required this.data,
      this.selected = false,
      required this.onTab})
      : super(key: key);

  final AddressData data;
  final bool selected;
  final Function onTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var title = (data.title != null) ? data.title! : '';
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Dismissible(
        key: Key(data.address),
        confirmDismiss: (DismissDirection direction) async {
          await _dismissibleAction(direction, context, ref);
          return null;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
                color: (selected) ? AppAllColors.lightAccent : Colors.white),
            color: Colors.white,
          ),
          height: 57.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onTab();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: title.isNotEmpty,
                          child: Text(
                            title,
                            style: AppTextStyles.textMediumBold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: 260.w,
                          child: Text(
                            data.address,
                            style: AppTextStyles.textLessMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      /*await AppUi.showAppBottomSheet(
                        context: context,
                        child: AddressEditSheet(
                          data: data,
                        ),
                      );*/
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewAddressPage(
                                  data: data,
                                )
                            //OrderingPage()
                            ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: SvgPicture.asset(
                        AppIcons.edit,
                        height: 18.h,
                        width: 18.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dismissibleAction(
      DismissDirection direction, BuildContext context, WidgetRef ref) async {
    if (direction == DismissDirection.startToEnd) {
      await PlatformDialog.show(
          context: context,
          okTitle: AppRes.delete,
          action: () async {
            var dao = ref.read(addressDaoProvider);
            await dao.deleteAddress(item: data);
          },
          droidTitle: AppRes.deleteAddress);
    }
  }
}
