import 'dart:async';

import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:cvetovik/core/ui/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageSlideshow extends StatefulWidget {
  ImageSlideshow({
    required this.children,
    this.width = double.infinity,
    this.height = 320,
    this.initialPage = 0,
    this.indicatorColor = Colors.blue,
    this.indicatorBackgroundColor = Colors.grey,
    this.onPageChanged,
    this.autoPlayInterval,
    this.mark,
  });
  final String? mark;

  /// The widgets to display in the [ImageSlideshow].
  ///
  /// Mainly intended for image widget, but other widgets can also be used.
  final List<Widget> children;

  /// Width of the [ImageSlideshow].
  final double width;

  /// Height of the [ImageSlideshow].
  final double height;

  /// The page to show when first creating the [ImageSlideshow].
  final int initialPage;

  /// The color to paint the indicator.
  final Color indicatorColor;

  /// The color to paint behind th indicator.
  final Color indicatorBackgroundColor;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// Auto scroll interval.
  ///
  /// Do not auto scroll when you enter null or 0.
  final int? autoPlayInterval;

  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  final StreamController<int> _pageStreamController =
      StreamController<int>.broadcast();
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _onPageChanged(int value) {
    _currentPage = value;
    _pageStreamController.sink.add(value);
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(value);
    }
  }

  Widget _indicator(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: List<Widget>.generate(
        widget.children.length,
        (index) {
          return StreamBuilder<int>(
            initialData: _pageController.initialPage,
            stream: _pageStreamController.stream.where(
              (pageIndex) {
                return index >= pageIndex - 1 && index <= pageIndex + 1;
              },
            ),
            builder: (_, AsyncSnapshot<int> snapshot) {
              return Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: snapshot.data == index
                      ? widget.indicatorColor
                      : widget.indicatorBackgroundColor,
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    _currentPage = widget.initialPage;

    if (widget.autoPlayInterval != null && widget.autoPlayInterval != 0) {
      Timer.periodic(
        Duration(milliseconds: widget.autoPlayInterval!),
        (timer) {
          if (_currentPage < widget.children.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeIn,
            );
          }
        },
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: widget.children.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              return widget.children[index];
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: _indicator(context),
          ),
          if (widget.mark != null &&
              widget.mark!.isNotEmpty &&
              widget.mark! != '0')
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      color: Colors.white,
                    ),
                    height: 20.h,
                    width: 40.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3, right: 2),
                          child: Icon(Icons.star,
                              size: 16.w,
                              color: AppAllColors.commonColorsYellow),
                        ),
                        Text(
                          widget.mark.toString(),
                          style: AppTextStyles.smallTitle13,
                        )
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
