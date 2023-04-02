import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:cvetovik/models/api/response/comments_response.dart';
import 'package:cvetovik/pages/card/widgets/content/comment/product_rating_widget.dart';
import 'package:flutter/material.dart';

class ProductCommentItemWidget extends StatelessWidget {
  const ProductCommentItemWidget(
      {Key? key, required this.comment, required this.title})
      : super(key: key);
  final Comment comment;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: 272,
        //height: 208,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0x0a000000),
              blurRadius: 40,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          left: 10,
          right: 11,
          top: 17,
          bottom: 17,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  child: CircleAvatar(
                    backgroundColor: AppAllColors.lightGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.name,
                        style: AppTextStyles.titleSmall,
                      ),
                      ProductRatingWidget(
                        rating: comment.mark,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 12),
              child: Text(
                title,
                style: AppTextStyles.textLessMedium,
              ),
            ),
            Text(
              comment.comment,
              style: AppTextStyles.textVerySmall,
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}
