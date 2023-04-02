import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/helpers/reset_account_state.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/pages/profile/profile_page.dart';
import 'package:cvetovik/pages/profile/register_page.dart';
import 'package:cvetovik/pages/profile/remove_account/remove_account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'remove_account_success_page.dart';

class RemoveAccountPage extends ConsumerStatefulWidget {
  const RemoveAccountPage();

  @override
  _AuthCodePageState createState() => _AuthCodePageState();
}

class _AuthCodePageState extends ConsumerState<RemoveAccountPage> {
  bool _isActive = false;
  String _code = '';
  final int codeLength = 4;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var model = ref.read(removeAccountModelProvider);
      model.sendSmsAgain();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(removeAccountModelProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppAllColors.commonColorsWhite,
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: AppUi.opacity,
        child: Padding(
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
                  padding: EdgeInsets.only(top: 76.h, bottom: 25.h),
                  child: Column(
                    children: [
                      Text(
                        AppRes.securityCode,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleLarge,
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        "Для удаления своего аккаунта введите код из смс",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textLessMedium,
                      ),
                    ],
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    _code = value;
                    bool isActive = _code.length == codeLength;
                    if (isActive != _isActive) {
                      setState(() {
                        _isActive = isActive;
                      });
                    }
                  },
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(codeLength),
                  ],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.smallTitle13NotBold,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppAllColors.lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.53.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 15.h,
                    bottom: 39.h,
                  ),
                  child: Center(
                    child: provider.smsIsAlreadySended
                        ? _SmsIsAlreadySended()
                        : _SendSmsAgainButton(
                            onTap: () {
                              var model = ref.read(removeAccountModelProvider);
                              model.sendSmsAgain();
                            },
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!_isActive) {
                      return;
                    }
                    try {
                      var model = ref.read(removeAccountModelProvider);
                      setState(() {
                        _isLoading = true;
                      });
                      var res = await model.checkCode(code: _code);

                      if (res.result) {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                          return RemoveAccountSuccessPage();
                        }), (route) => false);
                      } else {
                        AppUi.showToast(context, AppRes.error);
                      }
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
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
                        AppRes.send,
                        style: AppTextStyles.textLarge.copyWith(
                          color: AppAllColors.commonColorsWhite,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getActionColor() {
    return _isActive ? AppAllColors.lightAccent : AppAllColors.inactive;
  }
}

class _SmsIsAlreadySended extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(removeAccountModelProvider);
    return Text(
      AppRes.repeatThrough(provider.durationForRepeatSendSms),
      textAlign: TextAlign.center,
      style: AppTextStyles.descriptionLarge.copyWith(
        color: AppAllColors.lightBlack,
      ),
    );
  }
}

class _SendSmsAgainButton extends StatelessWidget {
  const _SendSmsAgainButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppRes.notCode,
          style: AppTextStyles.descriptionLarge.copyWith(
            color: AppAllColors.lightBlack,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: InkWell(
            onTap: onTap,
            child: Text(
              AppRes.sendAgain,
              style: AppTextStyles.descriptionLarge.copyWith(
                color: AppAllColors.lightAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
