import 'package:cvetovik/core/helpers/color_ext.dart';
import 'package:cvetovik/pages/products/widget/item/base/filter_child_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleColorWidget extends StatefulWidget {
  final String id;
  final String color;
  final bool? isSelected;
  //final OnSelected onSelected;
  const CircleColorWidget(
      {Key? key, required this.id, required this.color, this.isSelected})
      : super(key: key);

  @override
  _CircleColorWidgetState createState() => _CircleColorWidgetState();
}

class _CircleColorWidgetState extends State<CircleColorWidget>
    with FilterChildMix {
  final double sizeNormal = 27.5.w;
  final double sizeSelected = 34.w;

  @override
  void initState() {
    if (widget.isSelected != null && (widget.isSelected!)) {
      isSelected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMix = (widget.color == 'mix');
    BoxDecoration decor;
    if (isMix) {
      decor = BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
          colors: [Colors.green, Colors.red, Colors.yellow, Colors.blueAccent],
        ),
      );
    } else {
      var color = HexColor.fromHex(widget.color);
      bool isWhite = (color == Colors.white);
      decor = BoxDecoration(
          border: Border.all(
            color: _getBorderColor(isWhite),
            width: _getBorderSize(),
          ),
          shape: BoxShape.circle,
          color: color);
    }

    return Padding(
      padding: (isSelected
          ? EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0)
          : EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.25)),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        //splashColor: Colors.transparent,
        child: Container(
          width: _getSize(),
          height: _getSize(),
          decoration: decor,
        ),
      ),
    );
  }

  Color _getBorderColor(bool isWhite) {
    if (isSelected) {
      return Colors.black26;
    } else {
      return (isWhite) ? Colors.black12 : Colors.transparent;
    }
  }

  double _getSize() => (isSelected) ? sizeSelected : sizeNormal;

  double _getBorderSize() => (isSelected) ? 2 : 1;

  /*void updateSelected(FilterSelected value) {
    if(value.id != widget.id){
      if(isSelected && value.selected){
        setState(() {
          isSelected =false;
        });
      }
    }
  }*/

  @override
  String getId() => widget.id;

  @override
  void drop() {
    if (isSelected) {
      setState(() {
        isSelected = false;
      });
    }
  }
}
