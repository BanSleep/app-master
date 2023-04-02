import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/helpers/reset_account_state.dart';
import 'package:cvetovik/core/services/providers/navbar_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/response/cabinet/client_info_response.dart';
import 'package:cvetovik/models/app/nav_data.dart';
import 'package:cvetovik/models/enums/app/tab_item.dart';
import 'package:cvetovik/pages/profile/profile_page.dart';
import 'package:cvetovik/pages/profile/register_page.dart';
import 'package:cvetovik/pages/user/auth/auth_number_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AuthCodePage extends ConsumerStatefulWidget {
  const AuthCodePage({Key? key, required this.phoneNumber, this.navKey})
      : super(key: key);
  final String phoneNumber;
  final NavData? navKey;

  @override
  _AuthCodePageState createState() => _AuthCodePageState();
}

class _AuthCodePageState extends ConsumerState<AuthCodePage> {
  bool _isActive = false;
  String _code = '';
  final int codeLength = 4;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var model = ref.read(authNumberModelProvider);
      model.sendSmsAgain(widget.phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(authNumberModelProvider);
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
                  padding: EdgeInsets.only(top: 76.h, bottom: 45.h),
                  child: Center(
                    child: Text(
                      AppRes.securityCode,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge,
                    ),
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
                              var model = ref.read(authNumberModelProvider);
                              model.sendSmsAgain(widget.phoneNumber);
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
                      var model = ref.read(authNumberModelProvider);
                      setState(() {
                        _isLoading = true;
                      });
                      var res = await model.checkCode(
                          phone: widget.phoneNumber, code: _code);
                      var token = (res.result && res.data != null)
                          ? res.data!.token
                          : '';
                      var isNewUser = (res.result && res.data != null)
                          ? res.data!.newUser
                          : false;
                      if (token.isNotEmpty) {
                        if (!isNewUser) return resetAppState(context);
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (isNewUser)
                                ? RegisterPage(
                                    isRegistered: false,
                                    clientData: ClientData(
                                      id: 0,
                                      firstname: '',
                                      phone: widget.phoneNumber,
                                      emailVerified: false,
                                      email: '',
                                    ),
                                  )
                                : ProfilePage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
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
    final provider = ref.watch(authNumberModelProvider);
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
