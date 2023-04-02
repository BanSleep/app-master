import 'package:cvetovik/core/services/providers/db_provider.dart';
import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/models/api/response/product_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavIcon extends ConsumerStatefulWidget {
  const FavIcon({Key? key, required this.item, required this.selected})
      : super(key: key);
  final ProductData item;
  final bool selected;
  @override
  _FavIconState createState() => _FavIconState();
}

class _FavIconState extends ConsumerState<FavIcon> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 12.h;
    return InkWell(
      onTap: () async {
        var dao = ref.read(favoritesDaoProvider);
        int res = 0;
        if (!isSelected) {
          /*var catalogId = ref.read(catalogIdProvider);
          if (catalogId.id > 0)
            res = await dao.insertFav(widget.item, catalogId.id);*/
          res = await dao.insertFav(widget.item);
        } else {
          res = await dao.deleteFav(widget.item.id);
        }
        if (res > 0) {
          setState(() {
            isSelected = !isSelected;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 6.w, top: 6.w),
        child: CircleAvatar(
          radius: 10.r,
          backgroundColor: Colors.white,
          child: Center(
            child: Icon(
              Icons.favorite,
              color: (isSelected)
                  ? AppAllColors.commonColorsRed
                  : AppAllColors.greyBd,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
