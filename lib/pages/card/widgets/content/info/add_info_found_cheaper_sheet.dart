import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/line_sheet.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddInfoFoundCheaperSheet extends StatefulWidget {
  const AddInfoFoundCheaperSheet(
      {Key? key, required this.title, required this.param})
      : super(key: key);

  final String title;
  final String param;

  @override
  _AddInfoFoundCheaperSheetState createState() =>
      _AddInfoFoundCheaperSheetState();
}

class _AddInfoFoundCheaperSheetState extends State<AddInfoFoundCheaperSheet> {
  final keyName = GlobalKey();
  final keyPhone = GlobalKey();
  final keyLink = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var desc =
        '${AppRes.foundCheaperDesc1} "${widget.param}" ${AppRes.foundCheaperDesc2}';
    return IntrinsicHeight(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 36.h,
              ),
              child: LineSheet(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: IntrinsicHeight(
                  child: SingleChildScrollView(
                    //physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Center(
                            child: Text(
                              AppRes.foundCheaper,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.titleLarge,
                            ),
                          ),
                        ),
                        Text(
                          desc,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.textField,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12.0.h),
                          child: AppTextField(
                            key: keyLink,
                            hint: 'http://',
                            title: AppRes.linkToApp,
                            minLength: 10,
                            errorText: AppRes.pleaseInputLink,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: AppTextField(
                            key: keyName,
                            hint: AppRes.hintName,
                            title: AppRes.name,
                            minLength: 4,
                            errorText: AppRes.pleaseInputName,
                          ),
                        ),
                        AppTextField(
                          key: keyPhone,
                          hint: '+7',
                          title: AppRes.phone,
                          textFieldType: TextFieldType.phone,
                          minLength: 10,
                          errorText: AppRes.pleaseInputPhone,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.0.h, top: 25.h),
                          child: SizedBox(
                            height: 44.h,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                var name =
                                    (keyName.currentState! as GetStrMixin)
                                        .value();
                                var phone =
                                    (keyPhone.currentState! as GetStrMixin)
                                        .value();
                                var link =
                                    (keyLink.currentState! as GetStrMixin)
                                        .value();
                                if (name.isNotEmpty &&
                                    phone.isNotEmpty &&
                                    link.isNotEmpty) {
                                  Navigator.pop(context);
                                }
                              },
                              style: AppUi.buttonActionStyle,
                              child: Text(
                                AppRes.save,
                                style: AppTextStyles.titleVerySmall
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
