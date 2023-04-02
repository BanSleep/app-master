import 'package:cvetovik/const/app_icons.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:cvetovik/pages/home/home_model.dart';
import 'package:cvetovik/widgets/region/region_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
    required this.model,
    required this.items,
  }) : super(key: key);

  final HomeModel model;
  final List<Region> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RegionSheet(
            items: items,
            /*saveRegion: (id, title) async {
              await model.saveRegion(id, title);
            },
            currentId: regId,*/
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                print('support');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: AppColors.fillColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SvgPicture.asset(
                      AppIcons.support,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
