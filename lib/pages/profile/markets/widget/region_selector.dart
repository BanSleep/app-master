import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/pages/profile/markets/models/regions.dart';
import 'package:cvetovik/pages/profile/markets/widget/drop_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegionSelector extends StatelessWidget {
  final List<RegionModel> list;
  final Function(RegionModel) onSelect;

  const RegionSelector({required this.list, required this.onSelect, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0xff000000).withOpacity(0.15),
                  blurRadius: 18,
                  offset: Offset(0, 0),
                  spreadRadius: -6)
            ]),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вы находитесь здесь',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Город',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black),
            ),
            SizedBox(
              height: 2,
            ),
            RegionDropDown(items: list, onSelect: onSelect),
          ],
        ),
      );
}
