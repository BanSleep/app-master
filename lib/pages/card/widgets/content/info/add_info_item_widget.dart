import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/core/ui/app_ui.dart';
import 'package:cvetovik/pages/card/widgets/content/info/add_info_card_sheet.dart';
import 'package:cvetovik/pages/card/widgets/content/info/add_info_found_cheaper_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddInfoItemWidget extends StatelessWidget {
  const AddInfoItemWidget(
      {Key? key,
      required this.title,
      required this.icon,
      this.desc = '',
      this.addParam = ''})
      : super(key: key);
  final String title;
  final String desc;
  final String icon;
  final String addParam;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () async {
          var child = (desc.isEmpty)
              ? AddInfoFoundCheaperSheet(
                  title: title,
                  param: addParam,
                )
              : AddInfoCardSheet(
                  title: title,
                  desc: desc,
                );
          await AppUi.showAppBottomSheet(
              context: context, child: child, isShape: true);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  icon,
                  height: 32,
                  width: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11.0),
              child: Text(
                title,
                style: AppTextStyles.descriptionLarge,
                maxLines: 3,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
