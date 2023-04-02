import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    this.title,
    this.showBackButton = true,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = false,
    this.body,
  }) : super(key: key);

  final Widget? title;
  final bool showBackButton;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        backgroundColor: extendBodyBehindAppBar ? Colors.transparent : null,
        shadowColor: Colors.transparent,
        title: title == null
            ? null
            : DefaultTextStyle(
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppAllColors.lightBlack,
                ),
                child: title!,
              ),
        centerTitle: true,
        leading: !showBackButton
            ? SizedBox()
            : InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppAllColors.iconsGrey,
                ),
              ),
      ),
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body,
    );
  }
}
