import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductPhotosViewer extends StatefulWidget {
  const ProductPhotosViewer({Key? key, required this.url, required this.items})
      : super(key: key);
  final String url;
  final List<String> items;

  @override
  _ProductPhotosViewerState createState() => _ProductPhotosViewerState();
}

class _ProductPhotosViewerState extends State<ProductPhotosViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.getBackground(true),
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: widget.items.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    widget.items[index],
                    /*headers: {
                      'User-Agent': 'Chrome/55.0.9743.98.a1',
                    },*/
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  //initialScale: 0.5,
                  maxScale: PhotoViewComputedScale.covered * 1.8,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),

              /*backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),*/
              loadingBuilder: (context, event) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Positioned(
                top: 35.h,
                left: 5.w,
                child: AppBackButton(
                  color: Colors.white,
                  tap: () => Navigator.pop(context),
                )),
          ],
        ));
  }
}
