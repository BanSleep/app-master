import 'package:cvetovik/const/app_res.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/comments_response.dart';
import 'package:cvetovik/pages/card/widgets/content/comment/product_comment_item_widget.dart';
import 'package:cvetovik/pages/card/widgets/content/comment/product_rating_widget.dart';
import 'package:cvetovik/widgets/product/title_with_up_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCommentsWidget extends StatelessWidget {
  const ProductCommentsWidget(
      {Key? key, required this.comments, required this.title})
      : super(key: key);

  final CommentData comments;
  final String title;

  @override
  Widget build(BuildContext context) {
    var marks = comments.comments!.map((e) => e.mark).toList();
    return Container(
      color: AppColors.lightBg2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleWithUpItemWidget(
                  title: AppRes.customerReviews,
                  count: comments.commentsNum.toString(),
                ),
                ProductRatingWidget(
                  marks: marks,
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: comments.comments!
                      .map((e) => ProductCommentItemWidget(
                            comment: e,
                            title: title,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
