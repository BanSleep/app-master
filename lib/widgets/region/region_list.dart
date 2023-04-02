import 'package:cvetovik/core/ui/app_colors.dart';
import 'package:cvetovik/models/api/response/region/region_response.dart';
import 'package:flutter/material.dart';

typedef SaveRegionCallback = Future<void> Function(int id);

class RegionList extends StatefulWidget {
  const RegionList(
      {Key? key,
      required this.items,
      required this.saveRegion,
      required this.currentId})
      : super(key: key);
  final List<Region> items;
  final SaveRegionCallback saveRegion;
  final int currentId;
  @override
  _RegionListState createState() => _RegionListState();
}

class _RegionListState extends State<RegionList> {
  late Region dropdownValue;

  @override
  void initState() {
    if (widget.currentId == 0) {
      dropdownValue = widget.items.first;
    } else {
      var curr = widget.items.firstWhere((el) => el.id == widget.currentId,
          orElse: () => widget.items.first);
      dropdownValue = curr;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Region>(
        value: dropdownValue,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: AppColors.primary),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primary,
        ),
        iconSize: 24,
        elevation: 16,
        //style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 0,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (Region? newValue) async {
          if (newValue != null) {
            print(newValue.id);
            await widget.saveRegion(newValue.id);
            setState(() {
              dropdownValue = newValue;
            });
          }
        },
        items: widget.items.map((value) {
          return DropdownMenuItem<Region>(
            value: value,
            child: Text(value.title),
          );
        }).toList());
  }
}
