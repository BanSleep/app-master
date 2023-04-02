import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/api/product_api.dart';
import 'package:cvetovik/core/services/settings_services.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/models/api/request/comment_request.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:cvetovik/pages/products/widget/buy_product/button_title_widget.dart';
import 'package:cvetovik/widgets/share/app_text_field.dart';
import 'package:cvetovik/widgets/share/value_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class NewProductCommentWidget extends ConsumerStatefulWidget {
  const NewProductCommentWidget({Key? key, required this.item})
      : super(key: key);
  final ProductData item;

  @override
  _NewProductCommentWidgetState createState() =>
      _NewProductCommentWidgetState();
}

class _NewProductCommentWidgetState
    extends ConsumerState<NewProductCommentWidget> {
  final keyName = GlobalKey();
  final keyComment = GlobalKey();
  final keyEmail = GlobalKey();
  double mark = 5.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 25.h),
                  child: _getTitle(),
                ),
                SizedBox(
                  width: 121.w,
                  height: 44.h,
                  child: Text(
                    widget.item.title,
                    style: AppTextStyles.textLessMedium,
                  ),
                ),
                Center(
                  child: SmoothStarRating(
                    rating: mark,
                    onRated: (double rating) {
                      setState(() {
                        mark = rating;
                      });
                    },
                    color: AppAllColors.commonColorsYellow,
                    size: 27.h,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    starCount: 5,
                    allowHalfRating: true,
                    spacing: 0.85,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                  child: AppTextField(
                    key: keyName,
                    hint: AppRes.hintName,
                    title: AppRes.yourName,
                    minLength: 4,
                    errorText: AppRes.pleaseInputName,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: AppTextField(
                    key: keyEmail,
                    hint: 'email',
                    textFieldType: TextFieldType.email,
                    title: AppRes.yourEmail,
                    minLength: 4,
                    errorText: AppRes.pleaseInputEmail,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: AppTextField(
                    key: keyComment,
                    maxLines: 5,
                    title: AppRes.someWords,
                    minLength: 4,
                    errorText: AppRes.pleaseInputComment,
                  ),
                ),
                SizedBox(
                  height: 36.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppUi.buttonActionStyle,
                    onPressed: () async {
                      var comment =
                          (keyComment.currentState! as GetStrMixin).value();
                      var name = (keyName.currentState! as GetStrMixin).value();
                      var email =
                          (keyEmail.currentState! as GetStrMixin).value();
                      if (comment.isNotEmpty &&
                          name.isNotEmpty &&
                          email.isNotEmpty) {
                        var productApi = ref.read(productApiProvider);
                        var data = CommentRequest(
                            comment: comment,
                            name: name,
                            email: 'email',
                            mark: mark.toString());
                        var set = ref.read(settingsProvider);
                        var deviceRegister = set.getDeviceRegisterWithRegion();
                        var clientInfo = set.getLocalClientInfo();
                        var res = await productApi.addComment(
                          data,
                          deviceRegister,
                          widget.item.id,
                          clientInfo,
                        );
                        Navigator.pop(context);
                        await _showResult(res);
                      }
                    },
                    child: ButtonTitleWidget(
                        height: 14.h,
                        width: 14.h,
                        icon: AppIcons.feedback,
                        title: AppRes.giveFeedback,
                        style: AppTextStyles.textMediumBold
                            .copyWith(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              AppRes.giveFeedback,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLargeSemiBold,
            ),
          ],
        ),
        Divider(
          endIndent: 0,
        ),
      ],
    );
  }

  Future<void> _showResult(bool res) async {
    var title = (res) ? AppRes.congratulations : '';
    var mess = (res) ? AppRes.reviewPublished : AppRes.error;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              //width: 300.w,
              height: 175.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                left: 32.w,
                right: 32.w,
                top: 28.h,
                bottom: 28.h,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: AppTextStyles.titleLarge),
                    Padding(
                      padding: EdgeInsets.only(top: 9.h, bottom: 26.h),
                      child: Text(mess, style: AppTextStyles.textLessMedium),
                    ),
                    SizedBox(
                      height: 44.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: AppUi.buttonActionStyle,
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(AppRes.ok2,
                            style: AppTextStyles.textMediumBold
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
