import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'auth_code_page.dart';

class AuthNumberPage extends ConsumerStatefulWidget {
  const AuthNumberPage({Key? key}) : super(key: key);

  @override
  _AuthNumberPageState createState() => _AuthNumberPageState();
}

class _AuthNumberPageState extends ConsumerState<AuthNumberPage> {
  //late MaskTextInputFormatter _phoneFormatter;
  bool _agreeRules = false;
  final keyPhone = GlobalKey();
  bool _phoneCompleted = false;

  /*@override
  void initState() {
    _phoneFormatter = MaskTextInputFormatter(
      mask: AppUi.phoneMask,
    );
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.getBackground(false),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppAllColors.commonColorsWhite,
        body: Padding(
          //top 73
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 73.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SvgPicture.asset(
                    AppIcons.logoColor,
                    height: 68.h,
                    width: 57.52.w,
                  ),
                ),
                Padding(
                  //top 76
                  padding: EdgeInsets.only(top: 76.h, bottom: 45.h),
                  child: Center(
                    child: Text(
                      AppRes.enterNumber,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge,
                    ),
                  ),
                ),

                AppTextField(
                  key: keyPhone,
                  hint: '+7',
                  textFieldType: TextFieldType.phone,
                  title: AppRes.yourPhone,
                  minLength: 10,
                  errorText: AppRes.pleaseInputPhone,
                  onChange: (value) {
                    var completed = false;
                    if (value.isNotEmpty &&
                        value.length == AppUi.phoneMask2.length) {
                      completed = true;
                    }
                    if (_phoneCompleted != completed) {
                      setState(() {
                        _phoneCompleted = completed;
                      });
                    }
                  },
                ),

                //TODO move to widget
                Padding(
                  padding: EdgeInsets.only(top: 15.h, bottom: 30.h),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _agreeRules = !_agreeRules;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            width: 26.w,
                            height: 26.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.53.r),
                              color: AppAllColors.lightGrey,
                            ),
                            child: Visibility(
                              visible: _agreeRules,
                              child: SvgPicture.asset(
                                AppIcons.check,
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 11.w),
                          child: Center(
                            child: Text(
                              AppRes.continueAgreeWithCondition,
                              textAlign: TextAlign.left,
                              style: AppTextStyles.descriptionMedium,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    var phone = (keyPhone.currentState! as GetStrMixin).value();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthCodePage(
                          phoneNumber: phone,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: _getActionColor(),
                    ),
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                    ),
                    child: Center(
                      child: Text(
                        AppRes.sendCode,
                        style: AppTextStyles.textLarge.copyWith(
                          color: AppAllColors.commonColorsWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isActive() {
    return (_agreeRules && _phoneCompleted);
  }

  Color _getActionColor() {
    return _isActive() ? AppAllColors.lightAccent : AppAllColors.inactive;
  }
}
