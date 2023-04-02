import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/db/app_database.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/ordering/widgets/address/select_address_widget.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressEditSheet extends StatefulWidget {
  const AddressEditSheet({Key? key, required this.data}) : super(key: key);
  final AddressData data;
  @override
  _AddressEditSheetState createState() => _AddressEditSheetState();
}

class _AddressEditSheetState extends State<AddressEditSheet> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        //maxHeight: 390.h,
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
              AppRes.changeAddress,
              style: AppTextStyles.titleSmall,
            ),
            SizedBox(
              height: 17.h,
            ),
            SelectAddressWidget(
              data: widget.data,
            ),
          ],
        ),
      ),
    );
  }
}
