import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogScaffold extends StatelessWidget {
  const DialogScaffold({
    Key? key,
    this.title,
    this.body,
    this.constraints,
    this.padding,
  }) : super(key: key);

  final Widget? title;
  final Widget? body;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints ??
          BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height * 0.2,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
      padding: padding ?? EdgeInsets.fromLTRB(10.0.w, 8.h, 10.0.w, 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 5,
            margin: EdgeInsets.only(bottom: 17),
            decoration: BoxDecoration(
              color: AppAllColors.lightDarkGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          if (title != null)
            DefaultTextStyle(
              style: AppTextStyles.titleLarge.copyWith(color: Colors.black),
              child: title!,
            ).paddingOnly(bottom: body == null ? 0 : 15),
          if (body != null) Expanded(child: body!),
        ],
      ),
    );
  }
}

class TextDialog extends StatelessWidget {
  const TextDialog({
    Key? key,
    required this.title,
    this.description,
    this.buttonText,
  }) : super(key: key);

  final String title;
  final String? description;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      constraints: BoxConstraints(maxHeight: 190),
      title: Text(title),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null)
            Text(
              description!,
              style: AppTextStyles.descriptionLarge,
            ),
          SizedBox(height: 30),
          SizedBox(
            height: 44.h,
            width: double.infinity,
            child: ElevatedButton(
              style: AppUi.buttonActionStyle,
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(buttonText ?? AppRes.ok2,
                  style: AppTextStyles.textMediumBold
                      .copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
