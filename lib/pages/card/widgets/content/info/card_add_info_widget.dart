import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/const/app_res.dart';
import 'package:flutter/material.dart';

import 'add_info_item_widget.dart';

class CardAddInfoWidget extends StatelessWidget {
  const CardAddInfoWidget(
      {Key? key,
      required this.delivery,
      required this.photoControl,
      required this.freeCard,
      required this.discount})
      : super(key: key);

  final String delivery;
  final String photoControl;
  final String freeCard;
  final String discount;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          AddInfoItemWidget(
            icon: AppIcons.discount,
            title: AppRes.foundCheaper,
            addParam: discount,
          ),
          AddInfoItemWidget(
              icon: AppIcons.truck, title: AppRes.freeDelivery, desc: delivery),
        ]),
        TableRow(children: [
          AddInfoItemWidget(
              icon: AppIcons.photoControl,
              title: AppRes.photoControl,
              desc: photoControl),
          AddInfoItemWidget(
              icon: AppIcons.freeCard, title: AppRes.freeCard, desc: freeCard),
        ]),
      ],
    );
  }
}
