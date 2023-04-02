import 'package:cached_network_image/cached_network_image.dart';
import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/pages/card/widgets/images_slider/product_photos_viewer.dart';
import 'package:flutter/material.dart';

import 'image_slide_show_widget.dart';

class ProductImagesSlider extends StatefulWidget {
  final List<String> items;
  final double height;
  final String? mark;
  const ProductImagesSlider(
      {Key? key, required this.items, required this.height, this.mark})
      : super(key: key);

  @override
  _ProductImagesSliderState createState() => _ProductImagesSliderState();
}

class _ProductImagesSliderState extends State<ProductImagesSlider> {
  @override
  Widget build(BuildContext context) {
    var imageSliders = _getSliders();
    return ImageSlideshow(
      width: double.infinity,
      height: widget.height,
      initialPage: 0,
      indicatorColor: AppColors.primary,
      indicatorBackgroundColor: Colors.grey,
      children: imageSliders,
      onPageChanged: (value) {
        print('Page changed: $value');
      },
      autoPlayInterval: 0,
      mark: widget.mark,
    );
  }

  List<Widget> _getSliders() {
    return widget.items
        .map((e) => InkWell(
              onTap: () async {
                List<String> items = widget.items;
                items.remove(e);
                items.insert(0, e);
                /*await Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ProductPhotosViewer(
                            url: e,
                            items: items,
                          )),
                );*/
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute<bool>(
                    builder: (BuildContext context) => ProductPhotosViewer(
                      url: e,
                      items: items,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: e,
                /*httpHeaders: {
                  'User-Agent': 'Chrome/55.0.9743.98.a1',
                },*/
                fit: BoxFit.fill,
              ),
            ))
        .toList();
  }
}
