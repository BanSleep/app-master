import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnSaveDb = Future<int> Function();

class CircleImageWidget extends StatefulWidget {
  const CircleImageWidget({Key? key, this.source, this.saveDb})
      : super(key: key);
  final String? source;
  final OnSaveDb? saveDb;
  @override
  _CircleImageWidgetState createState() => _CircleImageWidgetState();
}

class _CircleImageWidgetState extends State<CircleImageWidget> {
  final double size = 18.h;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6.w, top: 6.w),
      child: ClipOval(
        child: Material(
          color: Colors.white, // Button color
          child: SizedBox(
              width: size,
              height: size,
              child: Padding(
                  padding: EdgeInsets.only(top: 2.w), child: _getImage())),
        ),
      ),
    );
  }

  Widget _getImage() {
    if (widget.source != null) {
      return CachedNetworkImage(
        width: size,
        height: size,
        imageUrl: widget.source!,
        fit: BoxFit.fitWidth,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
