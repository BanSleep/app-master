import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductRatingWidget extends StatelessWidget {
  const ProductRatingWidget({Key? key, this.marks, this.rating = 0})
      : super(key: key);

  final int rating;
  final List<int>? marks;

  String _getCurrRating() {
    if (marks != null) {
      double res = 0;
      marks!.forEach((el) {
        res += el;
      });
      var result = (res / marks!.length).toStringAsFixed(2);
      return result;
    } else {
      return rating.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var currRatting = _getCurrRating();
    return Center(
      child: SmoothStarRating(
        rating: double.parse(currRatting),
        color: AppAllColors.commonColorsYellow,
        isReadOnly: true,
        size: 17,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        defaultIconData: Icons.star_border,
        starCount: 5,
        allowHalfRating: true,
        spacing: 0.85,
      ),
    );
  }
}
