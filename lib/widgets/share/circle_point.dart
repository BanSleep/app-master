import 'package:cvetovik/core/ui/app_all_colors.dart';
import 'package:flutter/material.dart';

class CirclePoint extends StatelessWidget {
  const CirclePoint(
      {Key? key, this.color = AppAllColors.lightAccent, required this.size})
      : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          //border: Border.all(width: 1.0, color: Colors.black),
          color: color,
          shape: BoxShape.circle,
        ));
  }
}
